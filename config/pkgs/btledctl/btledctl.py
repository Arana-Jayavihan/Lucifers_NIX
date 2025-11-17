import asyncio
import argparse
from bleak import BleakClient

CHARACTERISTIC_UUID = "0000ff12-0000-1000-8000-00805f9b34fb"

RED_SCALE = 1.0
GREEN_SCALE = 0.95
BLUE_SCALE = 1.05

CMD_PREFIX = bytes.fromhex("AA00")
CMD_SUFFIX = bytes.fromhex("0055AA")

CMD_TURN_ON = CMD_PREFIX + bytes.fromhex("01010000000000") + CMD_SUFFIX
CMD_TURN_OFF = CMD_PREFIX + bytes.fromhex("01000000000000") + CMD_SUFFIX

def CMD_BRIGHT_FORMAT(level): return CMD_PREFIX + \
    bytes.fromhex(f"02{level:02x}0000000000") + CMD_SUFFIX


def CMD_COLOR_FORMAT(r, g, b): return CMD_PREFIX + \
    bytes.fromhex(f"03{r:02x}{g:02x}{b:02x}000000") + CMD_SUFFIX


def adjust_brightness(color, target_brightness=200):
    r, g, b = color
    current_brightness = 0.2126 * r + 0.7152 * g + 0.0722 * b
    scaling_factor = target_brightness / \
        current_brightness if current_brightness > 0 else 1

    r_new = min(255, int(r * scaling_factor))
    g_new = min(255, int(g * scaling_factor))
    b_new = min(255, int(b * scaling_factor))

    return r_new, g_new, b_new


def gamma_correction(r, g, b, gamma=2.2):
    r_corrected = int((r / 255.0) ** (1 / gamma) * 255)
    g_corrected = int((g / 255.0) ** (1 / gamma) * 255)
    b_corrected = int((b / 255.0) ** (1 / gamma) * 255)
    return r_corrected, g_corrected, b_corrected

def apply_calibration(r, g, b):
    r_calibrated = min(255, int(r * RED_SCALE))
    g_calibrated = min(255, int(g * GREEN_SCALE))
    b_calibrated = min(255, int(b * BLUE_SCALE))
    return r_calibrated, g_calibrated, b_calibrated

def adjust_brightness(color, enable=False, target_brightness=200):
    if not enable:
        return color

    r, g, b = color
    current_brightness = 0.2126 * r + 0.7152 * g + 0.0722 * b
    if current_brightness == 0:
        return r, g, b

    scale = target_brightness / current_brightness

    return (
        min(255, int(r * scale)),
        min(255, int(g * scale)),
        min(255, int(b * scale)),
    )

def parse_hex_color(hex_color):
    """Convert a hex color code to an RGB tuple."""
    hex_color = hex_color.lstrip('#')  # Remove the '#' if present
    if len(hex_color) != 6:
        raise ValueError("Invalid hex color code. Must be 6 characters long.")
    try:
        r, g, b = int(hex_color[0:2], 16), int(
            hex_color[2:4], 16), int(hex_color[4:6], 16)
        return r, g, b
    except ValueError:
        raise ValueError(
            "Hex color code must contain only valid hexadecimal digits.")


async def send_command(device_address, command):
    """Send a command to the BLE device."""
    client = BleakClient(device_address)

    try:
        await client.connect()
        if not client.is_connected:
            print(f"Failed to connect to {device_address}")
            return False

        print(f"Connected to {device_address}")
        print(f"Sending command: {command.hex()}")

        await client.write_gatt_char(CHARACTERISTIC_UUID, command, response=False)

        print("Command sent")

    except Exception as e:
        print(f"Error during send_command: {e}")

    finally:
        try:
            if client.is_connected:
                await client.disconnect()
        except Exception:
            pass

    return True



async def adjust_brightness_for_group(devices, brightness):
    command = CMD_BRIGHT_FORMAT(brightness)
    write_count = 0

    for device in devices:
        await send_command(device, command)
        write_count += 1

    print(f"Brightness adjusted for {write_count} devices.")
    return write_count > 0


async def control_light(device_address, action, brightness=None, color=None, devices=None):
    """
    Control the smart light.
    - action: "on", "off", "brightness", or "color"
    - brightness: Int (0-100) for brightness level (required if action="brightness")
    - color: Tuple (R, G, B) for RGB color values (required if action="color")
    - devices: List of device addresses for group actions (required if action="brightness" or "color" and group control is needed)
    """
    if action == "on":
        await send_command(device_address, CMD_TURN_ON)
    elif action == "off":
        await send_command(device_address, CMD_TURN_OFF)
    elif action == "brightness" and brightness is not None:
        if devices:
            await adjust_brightness_for_group(devices, brightness)
        else:
            await send_command(device_address, CMD_BRIGHT_FORMAT(brightness))
    elif action == "color" and color is not None:
        print(f"Original color input: {color}")

        # --- Step 1: calibration ---
        r, g, b = apply_calibration(*color)

        # --- Step 2: gamma correction ---
        r, g, b = gamma_correction(r, g, b)

        # --- Step 3: optional brightness normalization ---
        r, g, b = adjust_brightness((r, g, b), enable=False)

        print(f"Final color sent: R={r}, G={g}, B={b}")

        command = CMD_COLOR_FORMAT(r, g, b)
        await send_command(device_address, command)
    else:
        print("Invalid action or missing parameters.")


def parse_arguments():
    parser = argparse.ArgumentParser(description="Control a BLE smart light.")

    # Required arguments
    parser.add_argument(
        "device_address", help="The MAC address of the BLE device")
    parser.add_argument("action", choices=[
                        "on", "off", "brightness", "color"], help="Action to perform on the light")

    # Optional arguments
    parser.add_argument("--brightness", type=int, choices=range(101),
                        help="Brightness level (0-100) if action is 'brightness'")
    parser.add_argument("--color", type=str,
                        help="RGB values for color change as hex code (e.g., #FFAABB) or three integers (R, G, B)")
    parser.add_argument("--devices", type=str, nargs="*",
                        help="List of device addresses for group actions (space-separated)")

    return parser.parse_args()


if __name__ == "__main__":
    args = parse_arguments()

    # Parse the color if provided
    color_rgb = None
    if args.color:
        print(args.color)
        try:
            if ',' in args.color:
                # Parse as integers if provided as "R, G, B"
                color_rgb = tuple(map(int, args.color.split(',')))
            else:
                # Parse as hex code
                color_rgb = parse_hex_color(args.color)
        except ValueError as e:
            print(f"Error: {e}")
            exit(1)

    # List of devices for group actions (if provided)
    devices = args.devices if args.devices else None

    # Run the asyncio loop
    asyncio.run(control_light(args.device_address, args.action,
                args.brightness, color_rgb, devices))

