{ pkgs, flakeDir, ... }:

pkgs.writeShellScriptBin "autopalette" ''
# NIX Inherited Variables
flakeDir=${flakeDir}

# Local BASH Variables
templatePath=$flakeDir/config/customColorSchemes/template.yaml
colorsPath=$flakeDir/config/customColorSchemes/colors.txt
palettePath=$flakeDir/config/customColorSchemes/custom.yaml
colorPalette=$flakeDir/config/customColorSchemes/palette.html

curWallPaper=$(cat $flakeDir/options.nix | grep curWallPaper | cut -d '=' -f2 | cut -d ';' -f1 | xargs)
imageWidth=$(exiftool $curWallPaper | grep "Image Width" | cut -d ':' -f2 | xargs)
imageHeight=$(exiftool $curWallPaper | grep "Image Height" | cut -d ':' -f2 | xargs)

# Base16 ColorPalette Template
cat <<EOF > $templatePath
scheme: "auto-generated"
author: "Auto Base16 Theme"
base00: "{}"
base01: "{}"
base02: "{}"
base03: "{}"
base04: "{}"
base05: "{}"
base06: "{}"
base07: "{}"
base08: "{}"
base09: "{}"
base0A: "{}"
base0B: "{}"
base0C: "{}"
base0D: "{}"
base0E: "{}"
base0F: "{}"
EOF

# Colors Extraction
schemer2 -width $imageWidth -height $imageHeight -format img::colors -in $curWallPaper -out $colorsPath

# Palette Generator Python Script
${pkgs.python3}/bin/python3 <<EOF
import random
import colorsys
import sys
import argparse

"""
This script generates a "base16" color theme intended for code syntax highlighting.

Base16 Style (from https://github.com/chriskempson/base16/blob/master/styling.md):
    base00 - Default Background
    base01 - Lighter Background (Used for status bars)
    base02 - Selection Background
    base03 - Comments, Invisibles, Line Highlighting
    base04 - Dark Foreground (Used for status bars)
    base05 - Default Foreground, Caret, Delimiters, Operators
    base06 - Light Foreground (Not often used)
    base07 - Light Background (Not often used)
    base08 - Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    base09 - Integers, Boolean, Constants, XML Attributes, Markup Link Url
    base0A - Classes, Markup Bold, Search Text Background
    base0B - Strings, Inherited Class, Markup Code, Diff Inserted
    base0C - Support, Regular Expressions, Escape Characters, Markup Quotes
    base0D - Functions, Methods, Attribute IDs, Headings
    base0E - Keywords, Storage, Selector, Markup Italic, Diff Changed
    base0F - Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
"""

"""

Configuration

"""

# TODO: Make these into modes that auto-set these constraints
# TODO: Make contrast ratio mode which meets accessibility guidelines (see https://webaim.org/resources/contrastchecker/)?

## Background
# These values ensure the backgrounds are nice and dark, even if the color palette values are all bright
# Each background gets progressively lighter. We'll define a different max acceptible value for each level
# For example, the Base00 default background is darkest, so it will be clamped to 0.08 if necessary
maximumBackgroundBrightnessThresholds = [0.08, 0.15, 0.2, 0.25, 0.3, 0.4, 0.45]

## Foreground contrasts (i.e. text color HSL lightness - background color HSL lightness)
# These are relative values instead of ratios because you can't figure a ratio on a black background
minimumCommentTextContrast = 0.3
minimumTextContrast = 0.43
maximumTextContrast = 0.65

## Debugging
debugColorsVerbose = False

## Internal constants
# The index for the darkest background color. This is important to make sure contrast is high enough
#  between the darkest background color and the darkest text
BACKGROUND_COLOR_INDEX = 0

class Base16Color:
    def __init__(self, name, selectionFunction):
        self.name = name
        self.color = None
        self.selectionFunction = selectionFunction

"""

Color utility functions

"""

def rgbColorFromStringHex(colorStringHex):
    # From https://stackoverflow.com/questions/29643352/converting-hex-to-rgb-value-in-python
    return tuple(int(colorStringHex.strip('#')[i:i+2], 16) for i in (0, 2 ,4))

def hlsToRgbStringHex(hlsColor):
    rgbColor = colorsys.hls_to_rgb(hlsColor[0], hlsColor[1], hlsColor[2])
    return '#{0:02x}{1:02x}{2:02x}'.format(int(rgbColor[0] * 255), int(rgbColor[1] * 255), int(rgbColor[2] * 255))

def rgb256ToHls(color):
    rgbColor = color
    if type(color) == str:
        rgbColor = rgbColorFromStringHex(color)

    normalizedColor = []
    for component in rgbColor:
        normalizedColor.append(component / 256)

    return colorsys.rgb_to_hls(normalizedColor[0], normalizedColor[1], normalizedColor[2])
    
def getColorBrightness(color):
    hlsColor = rgb256ToHls(color)
        
    return hlsColor[1]

def colorHasBeenUsed(base16Colors, color):
    for base16Color in base16Colors:
        if base16Color.color == color:
            return True
    return False

def isColorWithinContrastRange(color, backgroundColor, minimumContrast, maximumContrast):
    colorBrightness = getColorBrightness(color)
    backgroundBrightness = getColorBrightness(backgroundColor)
    contrast = colorBrightness - backgroundBrightness

    if debugColorsVerbose:
        print('Color {} brightness {} background {} brightness {} difference {}'
              .format(color, colorBrightness, backgroundColor, backgroundBrightness, contrast))
        
    return (contrast >= minimumContrast and contrast <= maximumContrast)

# This is required so backgrounds get progressively lighter
currentMaximumBackgroundBrightnessThresholdIndex = 0

def resetMaximumBackgroundBrightnessThresholdIndex():
    global currentMaximumBackgroundBrightnessThresholdIndex
    currentMaximumBackgroundBrightnessThresholdIndex = 0
    
def popMaximumBackgroundBrightnessThreshold():
    global currentMaximumBackgroundBrightnessThresholdIndex
    threshold = maximumBackgroundBrightnessThresholds[currentMaximumBackgroundBrightnessThresholdIndex]
    currentMaximumBackgroundBrightnessThresholdIndex += 1
    return threshold

"""

Selection heuristics

"""

# Used for the background of dark themes. Make sure it is dark, damn it; change the color if you have to :)
def pickDarkestColorForceDarkThreshold(base16Colors, currentBase16Color, colorPool):
    viableColors = []
    for color in colorPool:
            viableColors.append(color)

    viableColors = sorted(viableColors,
                          key=lambda color: getColorBrightness(color), reverse=False)

    if currentMaximumBackgroundBrightnessThresholdIndex <= len(viableColors):
        bestColor = viableColors[currentMaximumBackgroundBrightnessThresholdIndex]
        # Clamp brightness
        hlsColor = rgb256ToHls(bestColor)
        clampedColor = (hlsColor[0],
                        min(hlsColor[1], popMaximumBackgroundBrightnessThreshold()),
                        hlsColor[2])

        if debugColorsVerbose and clampedColor != hlsColor:
            print('Clamped {} lightness {} to {} (threshold index {})'
                  .format(bestColor, hlsColor[1], clampedColor[1],
                          currentMaximumBackgroundBrightnessThresholdIndex))
            
        return hlsToRgbStringHex(clampedColor)

    # This is weird and probably an error
    return None

# Pick darkest color. If the color is already taken, pick the next unique darkest
def pickDarkestColorUnique(base16Colors, currentBase16Color, colorPool):
    bestColor = None
    bestColorBrightness = 10000
    for color in colorPool:
        rgbColorBrightness = getColorBrightness(color)
        if rgbColorBrightness < bestColorBrightness and not colorHasBeenUsed(base16Colors, color):
            bestColor = color
            bestColorBrightness = rgbColorBrightness

    return bestColor

# Selects the  darkest color which meets the contrast requirements and which hasn't been used yet
def pickDarkestHighContrastColorUnique(base16Colors, currentBase16Color, colorPool):
    viableColors = []
    for color in colorPool:
        if isColorWithinContrastRange(color, base16Colors[BACKGROUND_COLOR_INDEX].color,
                                      minimumCommentTextContrast, maximumTextContrast):
            viableColors.append(color)

    viableColors = sorted(viableColors,
                          key=lambda color: getColorBrightness(color), reverse=False)

    # We've sorted in order of brightness; pick the darkest one which is unique
    bestColor = None
    for color in viableColors:
        if not colorHasBeenUsed(base16Colors, color):
            bestColor = color
            break

    return bestColor
    
# Pick high contrast foreground
# High contrast = a minimum brightness difference between this and the brightest background)
def pickHighContrastBrightColorUniqueOrRandom(base16Colors, currentBase16Color, colorPool):
    viableColors = []
    for color in colorPool:
        if isColorWithinContrastRange(color, base16Colors[BACKGROUND_COLOR_INDEX].color,
                                      minimumTextContrast, maximumTextContrast):
            viableColors.append(color)

    if not viableColors:
        return None

    # Prefer a color which is unique
    bestColor = None
    for color in viableColors:
        if not colorHasBeenUsed(base16Colors, color):
            bestColor = color
            break
        
    return bestColor if bestColor else random.choice(viableColors)
    
def pickRandomColor(base16Colors, currentBase16Color, colorPool):
    return random.choice(colorPool)

"""

Procedure

"""

def main():
    colorsFile = open("$colorsPath", 'r')
    colorsLines = colorsFile.readlines()
    colorsFile.close()

    base16Colors = [
        # These go from darkest to lightest via implicit unique ordering
        # base00 - Default Background
        Base16Color('base00', pickDarkestColorForceDarkThreshold),
        # base01 - Lighter Background (Used for status bars)
        Base16Color('base01', pickDarkestColorForceDarkThreshold),
        # base02 - Selection Background
        Base16Color('base02', pickDarkestColorForceDarkThreshold),
        # base03 - Comments, Invisibles, Line Highlighting
        Base16Color('base03', pickDarkestHighContrastColorUnique),
        # base04 - Dark Foreground (Used for status bars)
        Base16Color('base04', pickDarkestHighContrastColorUnique),
        # base05 - Default Foreground, Caret, Delimiters, Operators
        Base16Color('base05', pickDarkestHighContrastColorUnique),
        # base06 - Light Foreground (Not often used)
        Base16Color('base06', pickDarkestColorForceDarkThreshold),
        # base07 - Light Background (Not often used)
        Base16Color('base07', pickDarkestColorForceDarkThreshold),
        # base08 - Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
        Base16Color('base08', pickHighContrastBrightColorUniqueOrRandom),
        # base09 - Integers, Boolean, Constants, XML Attributes, Markup Link Url
        Base16Color('base09', pickHighContrastBrightColorUniqueOrRandom),
        # base0A - Classes, Markup Bold, Search Text Background
        Base16Color('base0A', pickHighContrastBrightColorUniqueOrRandom),
        # base0B - Strings, Inherited Class, Markup Code, Diff Inserted
        Base16Color('base0B', pickHighContrastBrightColorUniqueOrRandom),
        # base0C - Support, Regular Expressions, Escape Characters, Markup Quotes
        Base16Color('base0C', pickHighContrastBrightColorUniqueOrRandom),
        # base0D - Functions, Methods, Attribute IDs, Headings
        Base16Color('base0D', pickHighContrastBrightColorUniqueOrRandom),
        # base0E - Keywords, Storage, Selector, Markup Italic, Diff Changed
        Base16Color('base0E', pickHighContrastBrightColorUniqueOrRandom),
        # base0F - Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
        Base16Color('base0F', pickHighContrastBrightColorUniqueOrRandom)]

    # The colors we are able to choose from
    colorPool = []

    if colorsLines:
        colorPool = colorsLines
    else:
        print('Error: Could not parse colors from input colors file {}'.format(inputColorsFilename))
        return

    # Remove duplicate colors; these throw off the algorithm
    colorPool = list(set(colorPool))

    # Process color pool
    for i, color in enumerate(colorPool):
        # Remove newlines
        colorPool[i] = color.strip('\n')
        color = colorPool[i]

        if debugColorsVerbose:
            print(color)
            rgbColor = rgbColorFromStringHex(color)
            print('RGB =', rgbColor)

    # Make sure we start at the darkest threshold
    resetMaximumBackgroundBrightnessThresholdIndex()

    # Select a color from the color pool for each base16 color
    for i, base16Color in enumerate(base16Colors):
        color = base16Color.selectionFunction(base16Colors, base16Color, colorPool)

        if not color:
            print('WARNING: {} could not select a color! Picking one at random'.format(base16Color.name))
            color = random.choice(colorPool)

        base16Colors[i].color = color
        
        print('Selected {} for {}'.format(base16Colors[i].color, base16Color.name))

    # Output selected colors
    outputTemplateFile = open("$templatePath", 'r')
    outputTemplate = "".join(outputTemplateFile.readlines())
    outputTemplateFile.close()
    
    outputText = outputTemplate.format((base16Colors[0].color)[1:],  (base16Colors[1].color)[1:],
                                       (base16Colors[2].color)[1:],  (base16Colors[3].color)[1:],
                                       (base16Colors[4].color)[1:],  (base16Colors[5].color)[1:],
                                       (base16Colors[6].color)[1:],  (base16Colors[7].color)[1:],
                                       (base16Colors[8].color)[1:],  (base16Colors[9].color)[1:],
                                       (base16Colors[10].color)[1:], (base16Colors[11].color)[1:],
                                       (base16Colors[12].color)[1:], (base16Colors[13].color)[1:],
                                       (base16Colors[14].color)[1:], (base16Colors[15].color)[1:])
    
    outputFile = open("$palettePath", 'w')
    outputFile.write(outputText)
    outputFile.close()

if __name__ == '__main__':  
    main()
EOF

base00=""
base01=""
base02=""
base03=""
base04=""
base05=""
base06=""
base07=""
base08=""
base09=""
base0A=""
base0B=""
base0C=""
base0D=""
base0E=""
base0F=""

while IFS="" read -r p || [ -n "$p" ]
do
  if [ "$p" != 'scheme: "auto-generated"' ] && [ "$p" != 'author: "Auto Base16 Theme"' ]; then
    base=$(printf '%s\n' "$p" | cut -d ':' -f1 | xargs)
    color="#$(printf '%s\n' "$p" | cut -d ':' -f2 | xargs)"
    
    case $base in
      "base00")
	base00=$color
	;;
      "base01")
	base01=$color
	;;
      "base02")
	base02=$color
	;;
      "base03")
	base03=$color
	;;
      "base04")
	base04=$color
	;;
      "base05")
	base05=$color
	;;
      "base06")
	base06=$color
	;;
      "base07")
	base07=$color
	;;
      "base08")
	base08=$color
	;;
      "base09")
	base09=$color
	;;
      "base0A")
	base0A=$color
	;;
      "base0B")
	base0B=$color
	;;
      "base0C")
	base0C=$color
	;;
      "base0D")
	base0D=$color
	;;
      "base0E")
	base0E=$color
	;;
      "base0F")
	base0F=$color
    	;;
    esac
  fi
done < $palettePath

cat <<EOF > $colorPalette
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Base16 Color Palette</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
            background-color: #f0f0f0;
        }
        .palette-info {
            margin-bottom: 20px;
        }
        .palette-info h1 {
            margin: 0;
            font-size: 24px;
        }
        .palette-info p {
            margin: 5px 0 0;
            font-size: 18px;
        }
        .color-grid {
            display: grid;
            grid-template-columns: repeat(4, 100px);
            grid-gap: 10px;
        }
        .color-box {
            width: 100px;
            height: 100px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.7);
        }
    </style>
</head>
<body>
    <div class="palette-info">
        <h1>Palette: auto-generated</h1>
        <p>Author: Auto Base16 Theme</p>
    </div>
    <div class="color-grid">
        <div class="color-box" style="background-color: $base00;">base00</div>
        <div class="color-box" style="background-color: $base01;">base01</div>
        <div class="color-box" style="background-color: $base02;">base02</div>
        <div class="color-box" style="background-color: $base03;">base03</div>
        <div class="color-box" style="background-color: $base04;">base04</div>
        <div class="color-box" style="background-color: $base05;">base05</div>
        <div class="color-box" style="background-color: $base06;">base06</div>
        <div class="color-box" style="background-color: $base07;">base07</div>
        <div class="color-box" style="background-color: $base08;">base08</div>
        <div class="color-box" style="background-color: $base09;">base09</div>
        <div class="color-box" style="background-color: $base0A;">base0A</div>
        <div class="color-box" style="background-color: $base0B;">base0B</div>
        <div class="color-box" style="background-color: $base0C;">base0C</div>
        <div class="color-box" style="background-color: $base0D;">base0D</div>
        <div class="color-box" style="background-color: $base0E;">base0E</div>
        <div class="color-box" style="background-color: $base0F;">base0F</div>
    </div>
</body>
</html>
EOF
''
