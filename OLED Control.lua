--[[init_i2c_display()

Sets up the I2C display on pins 5 and 6
Initalize to a 6x10 pixel font ]]
function init_i2c_display()
     --Use pin 5 for SDA, 6 for SCL
     --Everything else is just default values
     i2c.setup(0, 5, 6, i2c.SLOW)

     --Initialize the 128x64 Display
     disp = u8g.ssd1306_128x64_i2c(0x3c)
     
     --Set font to one that takes 6x10 pixels per character
     disp:setFont(u8g.font_6x10)
end

--[[writeText(text)

Takes a table containing text and writes the conents of each cell
Moves to a new line between each cell
If called on its own, does NOT write anything to the OLED (call display instead)]]
function writeText(text)
   disp:drawStr(0, 10, "Hello!")
   --[[Change this function so that it
        1. Writes the text it is given to the display
        2. Moves to a new line between each cell ]]
end

--[[display(text)

Takes a table containing text and displays it on the I2C display]]
function display(text)
  disp:firstPage()
  --This loop writes content until there is no more content to write
  repeat
       writeText(text)
  until disp:nextPage() == false
end

init_i2c_display()

--Write a test case first! (use this as a model)
message = {
    "This is line one",
    "This is line two",
    "This is line three",
    "Hello!"}
display(message)