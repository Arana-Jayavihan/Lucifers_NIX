# Lucifer's NIX Flake ❄️
Hello folks, Welcome to my flake repository for NixOS, I've been loving NixOS since the day I installed it on my system. So here is my current configuration, I'll be updating this pretty often with new features, bug fixes, and improvements. Enjoy 🍃

### Screenshots
![preview1](https://github.com/Arana-Jayavihan/Lucifers_NIX/blob/master/assets/lockscreen.png?raw=true)
![preview2](https://github.com/Arana-Jayavihan/Lucifers_NIX/blob/master/assets/showcase1.png?raw=true)
![preview3](https://github.com/Arana-Jayavihan/Lucifers_NIX/blob/master/assets/showcase2.png?raw=true)
![preview4](https://github.com/Arana-Jayavihan/Lucifers_NIX/blob/master/assets/showcase3.png?raw=true)
![preview4](https://github.com/Arana-Jayavihan/Lucifers_NIX/blob/master/assets/showcase4.png?raw=true)
![preview6](https://github.com/Arana-Jayavihan/Lucifers_NIX/blob/master/assets/wlogout.png?raw=true)

## Installation ⚙️
### Install a fresh NixOS on target system (Recommended).
After installation, reboot to the fresh installation and open a terminal.
```sh
export NIX_CONFIG="experimental-features = nix-command flakes" 
```

### Install Git and Nano (or any preferred editor)
```sh
nix-shell -p git nano
```

### Clone the repository
```sh
git clone https://github.com/Arana-Jayavihan/Lucifers_NIX.git
```

### Recreate the hardware.nix
```sh
cd Lucifers_NIX
rm hardware.nix
nixos-generate-config --show-hardware-config > hardware.nix
```

### Clone the wallpaper repository
```sh
mkdir ~/Projects
cd ~/Projects
git clone https://github.com/Arana-Jayavihan/nix-wallpapers.git
```

### Create user password
This flake have the user's password manually set in the system.nix file, to change the password run the following command and replace the "hashedPassword" in the systems.nix.
```sh
mkpasswd -m sha-512 "password"
```

### Change configuration in options.nix accordingly
The options.nix file contains the options to configure the shell, system, and other configurations.


### Flake Installation
After all optional configurations are done, install the flake by executing,
```sh
sudo nixos-rebuild switch --flake ~/Lucifers_NIX/
```

### Installing packages
#### Pre-Installation
The system.nix file contains the packages to be installed as the system or user, you can add the packages of your preference in the system.nix file.

#### Post-Installation
After flake installation and rebooting, you can simply use "nixInstall" command to install packages
```sh
nixInstall user||system <package1> <package2>
```

Then reboot the system to enjoy 🍃

## Credits 💫
Huge appreciation for Tyler Kelley for building such an amazing flake. Learned a lot from your configuration.

[![credits](https://gitlab.com/uploads/-/system/project/avatar/53038185/Gitlab_Nix_Picture.png?width=48 "Credits to Zaney")](https://gitlab.com/Zaney/zaneyos/-/tree/8e643956f0abf8011101771b956d994a2d052ae7)
