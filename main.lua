local utf8 = require"utf8"

function love.load()
    keys = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}
    fase = 1
    textos = { "Por favor escriba el PRIMER FOLIO c:", "Porfis escriba el ÚLTIMO FOLIO :D", "¿Por cuánto los divido? ;)", "Listo uwu, \n el archivo quedó guardado en %APPDATA%/love" }
    data = {}
    text = ""
    ceros = 0
    ztxt = ""
    video = love.graphics.newVideo("background.ogg")
    video:play()
    bg = love.graphics.newImage("bg1.png")
    fonts = { text = love.graphics.newFont("fonts/Lilita_One/LilitaOne-Regular.ttf", 31), num = love.graphics.newFont("fonts/OSWALD/Oswald-Bold.ttf", 125)}
end

function love.update()
    if love.keyboard.isDown("escape") then love.event.quit() end

    if not video:isPlaying() then video:rewind() end
end

function love.draw()
   love.graphics.setColor(1,1,1)
   love.graphics.draw(video, 0, 0, nil, 0.4, 0.4)
   love.graphics.draw(bg)

   love.graphics.setFont(fonts.text)
   love.graphics.print(textos[fase], 40, 30)
   love.graphics.setFont(fonts.num)
    love.graphics.print(text, 40, 175)
    
end

function love.textinput(t)  for i = 1, 10, 1 do
    if t == keys[i] and string.len(text) < 7 then text = text .. t end
    end
end

function printFolios(n1, n2, div)
    local fLong = ((n2-n1) + 1) / div
    f = love.filesystem.newFile("FOLIOS "..ztxt.." al "..n2.." - x"..div..".txt")
    f:open("w")

    for i = 1, div, 1 do
        f:write("".."F"..i)
        if i < div then f:write("\t") end
    end
    f:write("\r\n")

    for i = 1, fLong, 1 do
        for a = 1, div, 1 do
            for u = 1, ceros, 1 do
                if ((i-1) + n1 + (fLong * (a-1))) < 10^u then
                    f:write("0")
                end
            end

            f:write((i-1) + n1 + (fLong * (a-1)))
            if a < div then f:write("\t") end
        end
        f:write("\r\n")
    end
    f:close()
end

function love.keypressed(key)
    if fase == 4 then
        fase = 1
        data = {}
        text = ""
    end
    if key == "backspace" then
		local byteoffset = utf8.offset(text, -1)
		if byteoffset then
			text = string.sub(text, 1, byteoffset - 1)
		end
    elseif (key == "return" or key == "kpenter") and fase < 4 and text ~= "" then
        if fase == 1 then
            if string.len(text) > 1 then ceros = string.len(text) - 1 end
            ztxt = text
        end

        data[fase] = tonumber(text)
        fase = fase + 1
        text = ""
        if fase == 4 then
            printFolios(data[1], data[2], data[3])
            love.system.openURL("file://"..love.filesystem.getSaveDirectory())
        end
    end
end