#!/bin/bash
# Script to install TFT_eSPI configuration for ESP32-2432S028R

echo "ESP32-2432S028R TFT_eSPI Configuration Installer"
echo "================================================"
echo ""

# Find Arduino libraries directory
ARDUINO_DIR=""

# Check common locations
if [ -d "$HOME/Arduino/libraries" ]; then
    ARDUINO_DIR="$HOME/Arduino/libraries"
elif [ -d "$HOME/Documents/Arduino/libraries" ]; then
    ARDUINO_DIR="$HOME/Documents/Arduino/libraries"
elif [ -d "$HOME/.arduino15/libraries" ]; then
    ARDUINO_DIR="$HOME/.arduino15/libraries"
fi

if [ -z "$ARDUINO_DIR" ]; then
    echo "ERROR: Could not find Arduino libraries directory!"
    echo "Please enter the path to your Arduino libraries folder:"
    read -r ARDUINO_DIR
fi

TFT_ESPI_DIR="$ARDUINO_DIR/TFT_eSPI"

if [ ! -d "$TFT_ESPI_DIR" ]; then
    echo "ERROR: TFT_eSPI library not found at: $TFT_ESPI_DIR"
    echo ""
    echo "Please install TFT_eSPI library first:"
    echo "  Arduino IDE -> Sketch -> Include Library -> Manage Libraries"
    echo "  Search for 'TFT_eSPI' and install it"
    exit 1
fi

echo "Found TFT_eSPI library at: $TFT_ESPI_DIR"
echo ""

# Backup existing User_Setup.h
if [ -f "$TFT_ESPI_DIR/User_Setup.h" ]; then
    BACKUP_FILE="$TFT_ESPI_DIR/User_Setup.h.backup.$(date +%Y%m%d_%H%M%S)"
    echo "Backing up existing User_Setup.h to: $BACKUP_FILE"
    cp "$TFT_ESPI_DIR/User_Setup.h" "$BACKUP_FILE"
fi

# Copy our User_Setup.h
echo "Installing ESP32-2432S028R configuration..."
cp "User_Setup.h" "$TFT_ESPI_DIR/User_Setup.h"

if [ $? -eq 0 ]; then
    echo ""
    echo "SUCCESS! TFT_eSPI has been configured for ESP32-2432S028R"
    echo ""
    echo "You can now compile and upload the ESP32-2432S028R.ino sketch"
else
    echo ""
    echo "ERROR: Failed to copy User_Setup.h"
    echo "You may need to run this script with sudo or adjust permissions"
    exit 1
fi

echo ""
echo "Next steps:"
echo "  1. Open Arduino IDE"
echo "  2. Open ESP32-2432S028R.ino"
echo "  3. Select Board: Tools > Board > ESP32 Arduino > ESP32 Dev Module"
echo "  4. Select Port: Tools > Port > /dev/ttyUSB0 (or your port)"
echo "  5. Upload!"
echo ""
