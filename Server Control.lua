function fixText(text)
    bell = string.char(7)
    --replace + with space
    text = text:gsub("+", " ")
    
    --Replace "%"s with bell symbols so that there are not issues with actual "%"s
    text = text:gsub("%%", bell)
    
    --Remove "text="(what's at the beginning of input)
    text = text:sub(6)
    
    s_index, e_index = text:find(bell.."..")
    while (s_index ~= nil) do
        hex_val = text:sub(s_index+1, e_index) --Get the two values after the % sign
        ascii_val = string.char(tonumber(hex_val,16)) --convert these values to hex and then interpret them as ascii
        text = text:sub(1, s_index-1) .. ascii_val .. text:sub(e_index + 1) --insert the ascii value and resize the string
        s_index, e_index = text:find(bell.."..") --find the next bell character (what we replaced % with)
    end
    return text
end

--[[splitTextBy(text, char)

Takes text, a string, and char, a character
Returns a table consisting of text split at each char]]
function splitTextBy(text, char)
    splitText = {}
    --Match a sequence of one or more characters that are not char
    for line in string.gmatch(text, "[^" .. char .."]+") do
        --Append each sequence to the table
        splitText:insert(line)
    end
    return splitText
end

--[[readFile(filename)

Returns a table containing the conents of filename split by lines
Expects a file with one or more lines
]]
function readFile(filename)
    file.open(filename)
    --Create a table for the lines
    lines = {}
    
    repeat
        line = file.readline()
        lines:insert(line)
    until line == nil

    return lines
end
        
-- web server
text="Type Message Here"
function runServer()
    srv=net.createServer(net.TCP)
    srv:listen(80,function(conn)
        conn:on("receive", function(client,request)
            pattern = "text=%S*" --parse until you hit a space character
            patternStart,patternEnd = string.find(request,pattern) --retrieve pattern match
            if(patternStart ~= nil) then --if there is a pattern match
                --Get the text
                text = string.sub(request,patternStart,patternEnd)
                
                --Fix the text
                text = fixText(text)

                --Print the text
                print("OUTPUT:",text)
                
                --Split the text by newlines so it can be parsed by display()
                text = splitTextBy(text, "\n")
                
                --Display the text on the OLED
                --display(text)
                
                --Rejoin text so we can display it on the webpage
                text = table.concat(text,"\n")
            end
            client:send("<h1> ESP8266 Text Input</h1>")
            client:send("<p> Characters that are not alphanumerics, spaces, and linebreaks are not officially supported. They may and often times will behave unpredictably </p>")
            client:send("<form action=\"\" method=\"post\"> <textarea name=\"text\" rows=\"6\" cols=\"50\">"..text.."</textarea> <br> <input type=\"submit\" value=\"Submit\"></form>")
        end)
        conn:on("sent", function(conn) --when you send information to the client
            conn:close() --close the connection
            collectgarbage() --collect garbage
        end)
    end)
end

-- Setup WiFi
wifi.setmode(wifi.STATION)
--Replace WIFINAME and WIFIPASSWORD with your network name and password
wifi.sta.config("WIFINAME", "WIFIPASSWORD")
--Wait 2 seconds before starting
tmr.alarm(1,2000, 1, function()
    if(wifi.sta.getip()~=nil) then
        print("IP Address: "..wifi.sta.getip())
        display({"Connect on", wifi.sta.getip()})
        tmr.stop(1)
    end
    end)
runServer()
