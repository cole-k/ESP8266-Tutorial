-- setup I2c and connect display
function init_i2c_display()
     i2c.setup(0, 5, 6, i2c.SLOW)
     disp = u8g.ssd1306_128x64_i2c(0x3c)
     disp:setFont(u8g.font_6x10)
end
-- write text, expects variable text as a table
function writeText(text)
   for i, v in ipairs(text) do
    disp:drawStr(0, i*10, v) --multiply i by 10 to space rows by 10px
   end
end

-- display text, takes table
function display(text)
  disp:firstPage()
  repeat
       writeText(text)
  until disp:nextPage() == false
end
init_i2c_display()

-- web server
text="Type Message Here"
function runServer()
    srv=net.createServer(net.TCP)
    srv:listen(80,function(conn)
        conn:on("receive", function(client,request)
            pattern = "text=%S*" --parse until you hit a space character
            patternStart,patternEnd = string.find(request,pattern) --retrieve pattern match
            if(patternStart ~= nil) then --if there is a pattern match
                text = string.sub(request,patternStart,patternEnd) --take out most everything extraneous
                text = text:gsub("+", " ") --replace + with space
                text = text:gsub("%%", string.char(7)) --Replace "%"s with bell symbols so that there are not issues with actual "%"s
                text = text:sub(6) --remove "text="(what's at the beginning of input)
                s_index, e_index = text:find(string.char(7).."..")
                while (s_index ~= nil) do
                    hex_val = text:sub(s_index+1, e_index) --to get rid of "%"
                    ascii_val = string.char(tonumber(hex_val,16))
                    text = text:sub(1, s_index-1) .. ascii_val .. text:sub(e_index + 1)
                    s_index, e_index = text:find(string.char(7).."..")
                end
                print("OUTPUT:")
                print(text)
                if(string.find(text,"\n") ~= nil) then --if there are multiple lines, send them all in a table
                    splitText = {}
                    for line in string.gmatch(text, "[^\n]+") do --split by %, used to delimit newlines
                        table.insert(splitText, line)
                    end
                    text = splitText
                else --if there's only one line, send it in a table
                    text = {text}
                end
                display(text)
                text = table.concat(text,"\n") --rejoin text
            end
            client:send("<h1> ESP8266 Text Input</h1>")
            client:send("<p> Characters that are not alphanumerics, spaces, and linebreaks are not officially supported. They may and often times will behave unpredictably </p>")
            client:send("<form action=\"\" method=\"post\"> <textarea name=\"text\" rows=\"6\" cols=\"50\">"..text.."</textarea> <br> <input type=\"submit\" value=\"Submit\"></form>")
        end)
        conn:on("sent", function(conn)
            conn:close()
            collectgarbage()
        end)
    end)
end

-- setup wifi
wifi.setmode(wifi.STATION)
wifi.sta.config("Claremont-ETC", "abcdeabcde")
tmr.alarm(1,2000, 1, function()
    if(wifi.sta.getip()~=nil) then
        print("IP Address: "..wifi.sta.getip())
        display({"Connect on", wifi.sta.getip()})
        tmr.stop(1)
    end
    end)
runServer()
