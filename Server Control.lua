--[[fixText(text)
    Take string where spaces are replaced by +
    
    ]]
function fixText(text)
    bell = string.char(7)
        
    --Replace "%"s with bell symbols so that there are not issues with actual "%"s
    --We use "%%" instead of "%" because "%" is a special character
    text = text:gsub("%%", bell)
    
    --Put a command here that replaces each "+" with a " "
    --command goes here
    
    --Remove "text="(what's at the beginning of input) by taking a substring starting from 6
    text = text:sub(6)

    --Get the start and end indeces of the pattern "B.." where B is a bell character
    s_index, e_index = text:find(bell.."..")

    --Keep looping until text:find doesn't find anything
    while (s_index ~= nil) do
        --Get the two values after the bell character and convert to hex
        hex_val = tonumber(text:sub(s_index+1, e_index),16)
        
        --Convert the two values combined to hex and then interpret them as ascii
        ascii_val = string.char(hex_val)
        
        --Insert the ascii value and resize the string
        text = text:sub(1, s_index-1) .. ascii_val .. text:sub(e_index + 1)

        --Find the next bell character (what we replaced % with)
        s_index, e_index = text:find(bell.."..")
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
        --Replace this next line so that line is inserted into splitText
        --Replace this line
    end
    return splitText
end
        
--Global variable to store current value
text="Type Message Here"

function runServer()
    srv=net.createServer(net.TCP)
    srv:listen(80,function(conn)
        conn:on("receive", function(client,request)
            --Parse until you hit a space character
            pattern = "text=%S*"

            --Retrieve pattern match
            patternStart,patternEnd = string.find(request,pattern)

            --if there is a pattern match
            if(patternStart ~= nil) then
                --Get the text submitted
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
            --Send webserver information to the client
            client:send("<h1> ESP8266 Text Input</h1>")
            client:send("<p> Characters that are not alphanumerics, spaces, and linebreaks are not officially supported. They may and often times will behave unpredictably </p>")
            client:send("<form action=\"\" method=\"post\"> <textarea name=\"text\" rows=\"6\" cols=\"50\">"..text.."</textarea> <br> <input type=\"submit\" value=\"Submit\"></form>")
        end)
        --When you send information to the client
        conn:on("sent", function(conn)
            --Close the connection 
            conn:close()
            --Collect garbage
            collectgarbage()
        end)
    end)
end

-- Setup WiFi
wifi.setmode(wifi.STATION)

--Replace WIFINAME and WIFIPASSWORD with your network name and password
wifi.sta.config("WIFINAME", "WIFIPASSWORD")

--Wait 2 seconds before starting
tmr.alarm(1, 2000, 1, function()
    if(wifi.sta.getip()~=nil) then
        print("IP Address: "..wifi.sta.getip())
        display({"Connect on", wifi.sta.getip()})
        tmr.stop(1)
    end
    end)
runServer()
