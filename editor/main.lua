love.filesystem.setIdentity('MapMaker')
prefix = ''
require('sound')
require('TESound')
require('tools')
require('controls')
require('vector')
require('camera')
require('imageBatch')
require('pokemon')
require('player')
require('entities')
require('map')
require('SaveTable')

fonts = {}
fonts[12] = love.graphics.newFont(11)
fonts[30] = love.graphics.newFont(30)
love.graphics.setFont(fonts[30])
ended = true
msgWindow = love.graphics.newImage('msgWindow.png')
msgWindow:setFilter('nearest','nearest')
debugFPS = false
--fontImage = love.graphics.newImageFont("font.png", "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890")


map = false
layerNames = {
	'Background',
	'Collisions',
	'Foreground',
	'signs',
	'middleBackground',
}
currentLayer = 2
placeType = 'map'
selected = {X=3,Y=2}
selected.batch = love.graphics.newSpriteBatch( love.graphics.newImage(prefix..'pkmnTiles.png'), 20000 )
selectedEnt = 1


function string.firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end




function love.load()
	tileSize = 16
	numTiles = 50

	local mapCheck = mapFuncs.checkMap('map1')
	if mapCheck then
		tiles, tileset = mapFuncs.loadQuads(numTiles,tileSize)
		map = mapFuncs.loadMap('map1')
	else
		map = mapFuncs.newMap()
	end
	dt = math.min(0.002, love.timer.getDelta()) 
end

function love.update()
	local X = love.mouse.getX()
	local Y = love.mouse.getY()
	local tileX = getTile(X)
	local tileY = getTile(Y)
	if not(currentFunc) and map then
	
		tileMenu = (love.keyboard.isDown('`') or love.keyboard.isDown('~'))
		entMenu = (love.keyboard.isDown('`') or love.keyboard.isDown('~'))

		if (love.keyboard.isDown('lctrl') or love.keyboard.isDown('rctrl')) and love.keyboard.isDown('f') then
			for x = 1, getTile(love.graphics.getWidth()) do
				for y = 1, getTile(love.graphics.getHeight()) do
					if not(map[currentLayer][x]) then map[currentLayer][x] = {} end
					map[currentLayer][x][y] = {X = selected.X, Y = selected.Y}
				end
			
			end
			mapFuncs.buildMap(map, currentLayer)
		end
		
		if (love.keyboard.isDown('lctrl') or love.keyboard.isDown('rctrl')) and love.keyboard.isDown('delete') then
			map[currentLayer] = {}
			mapFuncs.buildMap(map, currentLayer)

		end
		
		if love.mouse.isDown('l') and not(tileMenu) and selected  then
			if placeType == 'map' then
				if not(map[currentLayer]) then map[currentLayer] = {} end
				if not(map[currentLayer][tileX]) then map[currentLayer][tileX] = {} end
				map[currentLayer][tileX][tileY] = {X = selected.X, Y = selected.Y}
				if love.keyboard.isDown('lshift') then
					if tileX-1 > 0 then
						if not(map[currentLayer][tileX-1]) then map[currentLayer][tileX-1] = {} end
						if not(map[currentLayer][tileX+1]) then map[currentLayer][tileX+1] = {} end
						
						map[currentLayer][tileX+1][tileY] = {X = selected.X, Y = selected.Y}
						map[currentLayer][tileX][tileY+1] = {X = selected.X, Y = selected.Y}
						map[currentLayer][tileX+1][tileY+1] = {X = selected.X, Y = selected.Y}
					

					
						map[currentLayer][tileX-1][tileY] = {X = selected.X, Y = selected.Y}
						map[currentLayer][tileX][tileY-1] = {X = selected.X, Y = selected.Y}
						map[currentLayer][tileX-1][tileY-1] = {X = selected.X, Y = selected.Y}

						map[currentLayer][tileX+1][tileY-1] = {X = selected.X, Y = selected.Y}
						map[currentLayer][tileX-1][tileY+1] = {X = selected.X, Y = selected.Y}

					end
				else
					local cX = 0
					local cY = 0
					if selected.start and selected.stop then
						for y = selected.start.Y, selected.stop.Y do
							cY = cY+1
							cX = 1
							for x = selected.start.X, selected.stop.X do
								if not(map[currentLayer][tileX+cX-1]) then map[currentLayer][tileY+cY-1] = {} end
								if not((tileX+cX-1)==0) and not((tileY+cY-1)==0) and map[currentLayer][tileX+cX-1] then
									map[currentLayer][tileX+cX-1][tileY+cY-1] = {X = x, Y = y}
								end
								--selected.batch:addq( tiles[x][y].quad, getPixel(cX), getPixel(cY) )
								cX = cX+1
							end
						end
					end
			
					map[currentLayer][tileX][tileY] = {X = selected.X, Y = selected.Y}
				end
				mapFuncs.buildMap(map, currentLayer)
			elseif placeType == 'player' then
				map.script.playerStart = {X=(tileX-1)*tileSize,Y=(tileY-1)*tileSize}
				player.load(map)
			elseif placeType == 'delete' then
				if map.objectScripts[tileX] and  map.objectScripts[tileX][tileY] then 
					map.objectScripts[tileX][tileY] = nil

				else
					if love.keyboard.isDown('lshift') then
						if tileX-1 > 0 then
							if not(map[currentLayer][tileX-1]) then map[currentLayer][tileX-1] = {} end
							if not(map[currentLayer][tileX+1]) then map[currentLayer][tileX+1] = {} end
							
							map[currentLayer][tileX+1][tileY] = nil
							map[currentLayer][tileX][tileY+1] = nil
							map[currentLayer][tileX+1][tileY+1] = nil
						

						
							map[currentLayer][tileX-1][tileY] = nil
							map[currentLayer][tileX][tileY-1] = nil
							map[currentLayer][tileX-1][tileY-1] = nil

							map[currentLayer][tileX+1][tileY-1] = nil
							map[currentLayer][tileX-1][tileY+1] = nil

						end
					end
					if map[currentLayer] and map[currentLayer][tileX] and map[currentLayer][tileX][tileY] then
						map[currentLayer][tileX][tileY] = nil
					end
				end
				mapFuncs.buildMap(map, currentLayer)
			end

		end
		
		if love.keyboard.isDown('lctrl') and love.keyboard.isDown('s') then
			mapFuncs.saveMap('map1', map)
		end
	end
end

function love.mousepressed(x,y,key)
	local tileX = getTile(x)
	local tileY = getTile(y)
	if not(currentFunc) then
	
		if placeType =='map' then
			if key == 'l' and tileX <= numTiles and tileY <= numTiles and tileMenu then
				selected.X = tileX
				selected.Y = tileY
				selected.start = {X = tileX, Y = tileY}
				selected.selecting = true
			end
		elseif placeType =='signs' then
			if key == 'l' then
				if entMenu then 
					local z = ((((tileY-1)*5)-5)+(tileX-1))
				
					if signsTemplate[z] then
						selectedEnt = (z)
					end
				else
					signs:add(selectedEnt, tileX, tileY)
				end
			end
		end
	end
end

function love.mousereleased(X,Y,key)
	local tileX = getTile(X)
	local tileY = getTile(Y)
	ended = true
	if tileMenu then
		selected.stop = {X = tileX, Y = tileY}
		selected.batch:clear()
		selected.batch:bind()
		local cX = 0
		local cY = 0
		if selected.start and selected.stop then
			for y = selected.start.Y, selected.stop.Y do
				cY = cY+1
				cX = 1
				for x = selected.start.X, selected.stop.X do
					selected.batch:addq( tiles[x][y].quad, getPixel(cX), getPixel(cY) )
					cX = cX+1
				end
			end
		end
		selected.batch:unbind()
		selected.selecting = false
	else
		selected.selecting = false
		--selected.start = nil
		--selected.stop = nil
	end
end

function love.keypressed(key,unicode)
	if unicode > 0 then
		--print(string.byte(key),string.char(string.byte(key)))
		newPress[unicode] = true
		newPress['curKey'] = unicode
	end


	if not(currentFunc) then

		if key == 'f1' then
			placeType = 'map'
		elseif key == 'f2' then
			placeType = 'player'
		elseif key == 'f3' then
			placeType = 'delete'
		elseif key == 'f4' then
			placeType = 'signs'
		end
		
		if tonumber(key) then
			if (tonumber(key) < 4 or tonumber(key) == 5) and tonumber(key) > 0 then
				currentLayer = tonumber(key)
			end
		end
	end
end

function love.draw()

	
	if map then
		local X = love.mouse.getX()
		local Y = love.mouse.getY()
		local tileX = (math.ceil(X/tileSize))
		local tileY = (math.ceil(Y/tileSize))


		if tileMenu then love.graphics.setColor(255,255,255,80) end
		--Draw Map
		
		mapFuncs.draw(map)

		
		--Correct Colours
		love.graphics.setColor(255,255,255,255)	

		
		--Draw Tilemap
		if tileMenu and (placeType == 'map') then	
			love.graphics.draw(tileSetBatch)
		

			if tileX <= numTiles  and tileY <= numTiles then
				if selected.selecting and selected.start then
					love.graphics.rectangle('line', (tileSize*selected.start.X)-tileSize, (tileSize*selected.start.Y)-tileSize, ((tileX-selected.start.X)+1)*tileSize, ((tileY-selected.start.Y)+1)*tileSize)
				else
					love.graphics.rectangle('line', (tileSize*tileX)-tileSize, (tileSize*tileY)-tileSize, tileSize, tileSize)
				end
			end
			
		end

		
		
		
		--Draw signs menu
		if entMenu and (placeType == 'signs') then	
			for i,v in pairs(signsTemplate) do
				if type(v) == 'table' then
					local x = i+1
					local y = math.ceil(i/5)+1
					x = (i+1)-((y*5)-10)
						love.graphics.drawq(tileset, tiles[v.X][v.Y].quad, (tileSize*x)-tileSize,  (tileSize*y)-tileSize)
				end
			end
		
		
			if tileX <= numTiles  and tileY <= numTiles then
				love.graphics.rectangle('line', (tileSize*tileX)-tileSize, (tileSize*tileY)-tileSize, tileSize, tileSize)
			end
		
			if tileX <= numTiles  and tileY <= numTiles then
					love.graphics.rectangle('line', (tileSize*tileX)-tileSize, (tileSize*tileY)-tileSize, tileSize, tileSize)
			end
		end
		
		if not(currentFunc) then
		if not(tileMenu) and not(entMenu) then

			--Draw shadowed images (for placement help)
			love.graphics.setColor(255,255,255,100)
			if placeType == 'map' then
				if selected.start and selected.start.X == selected.stop.X and selected.start.Y == selected.stop.Y  then
					if love.keyboard.isDown('lshift') then
							love.graphics.drawq(tileset, tiles[selected.X][selected.Y].quad, (tileSize*(tileX+1))-tileSize,  (tileSize*(tileY+1))-tileSize)
							love.graphics.drawq(tileset, tiles[selected.X][selected.Y].quad, (tileSize*(tileX))-tileSize,  (tileSize*(tileY+1))-tileSize)
							love.graphics.drawq(tileset, tiles[selected.X][selected.Y].quad, (tileSize*(tileX-1))-tileSize,  (tileSize*(tileY+1))-tileSize)
							
							love.graphics.drawq(tileset, tiles[selected.X][selected.Y].quad, (tileSize*(tileX-1))-tileSize,  (tileSize*(tileY-1))-tileSize)
							love.graphics.drawq(tileset, tiles[selected.X][selected.Y].quad, (tileSize*(tileX))-tileSize,  (tileSize*(tileY-1))-tileSize)
							love.graphics.drawq(tileset, tiles[selected.X][selected.Y].quad, (tileSize*(tileX+1))-tileSize,  (tileSize*(tileY-1))-tileSize)
							
							love.graphics.drawq(tileset, tiles[selected.X][selected.Y].quad, (tileSize*(tileX+1))-tileSize,  (tileSize*(tileY))-tileSize)
							love.graphics.drawq(tileset, tiles[selected.X][selected.Y].quad, (tileSize*(tileX-1))-tileSize,  (tileSize*(tileY))-tileSize)
					end
					love.graphics.drawq(tileset, tiles[selected.X][selected.Y].quad, (tileSize*tileX)-tileSize,  (tileSize*tileY)-tileSize)
				else
					love.graphics.draw(selected.batch,(tileSize*(tileX-1))-tileSize, (tileSize*(tileY-1))-tileSize)
				end
			elseif placeType == 'signs' then
				local ent = signsTemplate[selectedEnt]
				love.graphics.drawq(tileset, tiles[ent.X][ent.Y].quad, (tileSize*tileX)-tileSize,  (tileSize*tileY)-tileSize)
			elseif placeType == 'player' then
				player.draw({X=(tileSize*tileX)-tileSize,  Y=(tileSize*tileY)-tileSize})
				
			end
			love.graphics.setColor(255,255,255,255)

			--Draw Layer Name and Placement Type
			local font = love.graphics.getFont( )
			love.graphics.print(string.firstToUpper(layerNames[currentLayer]), (love.graphics.getWidth()-font:getWidth(layerNames[currentLayer]))-16,5)
			love.graphics.print(string.firstToUpper(placeType), 16,5)
		end
		
		end
		
		signs:addRun()	

	end
	
	if debugFPS then love.graphics.print(love.timer.getFPS(),10,10) end
		newPress = {}
end


















