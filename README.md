# ESP8266-Tutorial
Interactive code snippets designed to highlight the ESP8266's capabilities

[Slides](https://docs.google.com/a/g.hmc.edu/presentation/d/1hklxqxTjTlcK6zbn6wWgUUC_U2BwH9-dWDtHl9vmpwc/edit?usp=sharing)

### How it works
1. You connect the ESP8266 to the OLED display.
2. You edit a code snippet in Lua provided for controlling an OLED display so that it can take text input and display it on the OLED.
3. You edit a code snippet in Lua provided for hosting a web server that takes text input.
4. You edit a code snippet in Lua that brings together the above two files to host a web server that takes a user's input and displays it on an OLED display.

### Prerequisites
1. You should own an ESP8266 (preferably an ESP-12 variant), an OLED display (128x64 px is what is in the code, but you can change this), and some jumpers.
2. You should have the necessary drivers for your ESP (Windows shouldn't need anything, [here is a link to Mac OSX Drivers](https://www.silabs.com/Support%20Documents/Software/Mac_OSX_VCP_Driver.zip))
3. You should have [ESPlorer](http://esp8266.ru/esplorer/) downloaded and set up (this requires [Java](http://www.oracle.com/technetwork/java/javase/downloads/jre8-downloads-2133155.html), if you don't have it installed)
