# ESP32-2432S028R River Levels Display

A river monitoring system that displays USGS river gauge data on an ESP32-2432S028R development board (also known as "Cheap Yellow Display" or CYD).

## Hardware

**ESP32-2432S028R Specifications:**
- ESP32 microcontroller
- 2.4" ILI9341 TFT display (320x240 pixels)
- Built-in touchscreen (XPT2046)
- USB-C programming interface
- Onboard voltage regulator

## Features

- Displays 4 rivers in a 2x2 grid layout:
  - Locust Fork
  - Town Creek
  - South Sauty
  - Little River
- Real-time data updates every 5 minutes
- Shows:
  - Flow rate (CFS)
  - Stage/level (feet)
  - Trend (rising/falling/steady)
  - Quantitative Precipitation Forecast (QPF)
  - Water temperature
- Color-coded status indicators:
  - Green: River in good paddling range
  - Red: River below minimum
  - Cyan: River rising
  - Sky Blue: Rain forecast
  - Light Blue: Cold water (<55°F)
  - Orange: Warm water (>60°F)

## Setup Instructions

### 1. Install Arduino IDE

Download and install the Arduino IDE from https://www.arduino.cc/en/software

### 2. Install ESP32 Board Support

1. Open Arduino IDE
2. Go to **File > Preferences**
3. Add this URL to "Additional Board Manager URLs":
   ```
   https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json
   ```
4. Go to **Tools > Board > Boards Manager**
5. Search for "esp32" and install "esp32" by Espressif Systems

### 3. Install Required Libraries

Go to **Sketch > Include Library > Manage Libraries** and install:
- **TFT_eSPI** by Bodmer
- **ArduinoJson** by Benoit Blanchon (version 6.x)

### 4. Configure TFT_eSPI Library

The TFT_eSPI library needs to be configured for the ESP32-2432S028R display.

**Option A: Copy User_Setup.h to library directory (Recommended)**

1. Find your Arduino libraries folder:
   - Linux: `~/Arduino/libraries/`
   - Windows: `Documents/Arduino/libraries/`
   - Mac: `~/Documents/Arduino/libraries/`

2. Navigate to `TFT_eSPI` folder

3. Copy the `User_Setup.h` file from this project to the TFT_eSPI library folder, replacing the existing one:
   ```bash
   cp User_Setup.h ~/Arduino/libraries/TFT_eSPI/User_Setup.h
   ```

**Option B: Modify User_Setup_Select.h**

1. Open `TFT_eSPI/User_Setup_Select.h`
2. Comment out the default setup (usually line ~23)
3. Add a reference to a custom setup file or uncomment an ESP32 setup

### 5. Configure WiFi Credentials

The `secrets.h` file contains your WiFi credentials. Update it with your network information:

```cpp
const char* WIFI_SSID = "YourNetworkName";
const char* WIFI_PASSWORD = "YourPassword";
```

**Important:** Never commit `secrets.h` to a public repository!

### 6. Upload the Sketch

1. Connect the ESP32-2432S028R via USB-C cable
2. Select board: **Tools > Board > ESP32 Arduino > ESP32 Dev Module**
3. Select port: **Tools > Port > /dev/ttyUSB0** (or COM port on Windows)
4. Set Upload Speed: **Tools > Upload Speed > 921600**
5. Click the **Upload** button

## Pin Configuration (ESP32-2432S028R)

The ESP32-2432S028R has the following pin assignments for the display:

| Function | Pin |
|----------|-----|
| TFT_MISO | GPIO 12 |
| TFT_MOSI | GPIO 13 |
| TFT_SCLK | GPIO 14 |
| TFT_CS   | GPIO 15 |
| TFT_DC   | GPIO 2 |
| TFT_RST  | (connected to board RST) |
| TFT_BL   | GPIO 21 (backlight) |
| TOUCH_CS | GPIO 33 |

## API Endpoint

The sketch fetches data from:
```
https://docker-blue-sound-1751.fly.dev/api/river-levels
```

This API aggregates USGS river gauge data with weather forecasts (QPF) and temperature information.

## Troubleshooting

### Display shows garbled output or wrong colors
- Check that `User_Setup.h` is properly configured in the TFT_eSPI library
- Verify the pin definitions match the ESP32-2432S028R specifications
- Try setting `TFT_RGB_ORDER` to `TFT_RGB` if colors are swapped

### WiFi connection fails
- Verify SSID and password in `secrets.h`
- Check that your WiFi is 2.4GHz (ESP32 doesn't support 5GHz)
- Monitor Serial output (115200 baud) for connection status

### Display is blank or backlight doesn't turn on
- The backlight should be controlled by GPIO 21
- Check if `TFT_BACKLIGHT_ON` is set correctly (HIGH or LOW)
- Some boards may need external backlight configuration

### Compilation errors about TFT_eSPI
- Make sure only ONE setup is active in `User_Setup_Select.h`
- Delete the TFT_eSPI library and reinstall it
- Verify all required libraries are installed

## Serial Monitor Output

Connect to the serial monitor at **115200 baud** to see:
- WiFi connection status
- API fetch results
- River data updates
- Error messages

## Project Structure

```
ESP32-2432S028R/
├── ESP32-2432S028R.ino    # Main sketch for CYD board
├── ESP32_River_Levels.ino # Original sketch for HiLetgo ESP32
├── User_Setup.h           # TFT_eSPI configuration for CYD
├── secrets.h              # WiFi credentials (not in git)
└── README.md              # This file
```

## Differences from Original Sketch

The original `ESP32_River_Levels.ino` was designed for a HiLetgo ESP32 UNO with a 3.5" ILI9488 display (480x320). This version (`ESP32-2432S028R.ino`) adapts it for the smaller 2.4" ILI9341 display (320x240):

- Changed from 3-box + 1-featured layout to 2x2 grid
- Reduced text sizes to fit smaller screen
- Abbreviated river names
- Adjusted spacing and layout proportions
- Updated pin definitions for ESP32-2432S028R

## License

This project is open source. Feel free to modify and use it for your own purposes.

## References

- ESP32-2432S028R: https://github.com/witnessmenow/ESP32-Cheap-Yellow-Display
- TFT_eSPI Library: https://github.com/Bodmer/TFT_eSPI
- USGS Water Services: https://waterservices.usgs.gov/
