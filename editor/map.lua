mapFuncs = {}


local layers = {
	love.graphics.newSpriteBatch( love.graphics.newImage(prefix..'pkmnTiles.png'), 200000 ),
	love.graphics.newSpriteBatch( love.graphics.newImage(prefix..'pkmnTiles.png'), 200000 ),
	love.graphics.newSpriteBatch( love.graphics.newImage(prefix..'pkmnTiles.png'), 200000 ),
	love.graphics.newSpriteBatch( love.graphics.newImage(prefix..'pkmnTiles.png'), 200000 ),
	love.graphics.newSpriteBatch( love.graphics.newImage(prefix..'pkmnTiles.png'), 200000 ),
}

function mapFuncs.loadQuads(numTiles, tileSize)
	local marginX
	local marginY
	local tiles = {}
	local tileSet = love.graphics.newImage(prefix..'pkmnTiles.png')
	tileSet:setFilter('nearest','nearest')
	tileSetBatch = love.graphics.newSpriteBatch( love.graphics.newImage(prefix..'pkmnTiles.png'), 2000000 )

	for i = 1, numTiles do
		marginX = (1*i)-1
		
		for k = 1, numTiles do
			marginY = (1*k)-1
			local quad = love.graphics.newQuad( (tileSize*i)-tileSize+marginX, (tileSize*k)-tileSize+marginY, tileSize, tileSize, tileSet:getWidth(), tileSet:getHeight() )
			
			if not(tiles[i]) then tiles[i] = {} end
			tiles[i][k] = {quad=quad}
			tileSetBatch:addq( quad, (tileSize*i)-tileSize,  (tileSize*k)-tileSize )
		end
	end
	return tiles,tileSet
end

function mapFuncs.checkMap(mapName)
	mapName = mapName..'.pkm'
	if love.filesystem.exists(mapName) or  love.filesystem.exists(prefix..mapName) then
		if love.filesystem.exists(prefix..mapName) then mapName = prefix..mapName end
		return mapName, true
	end
	return false
end

function mapFuncs.newMap(mapName)
	return {wildPokemon = {10,11,12,13,14,15}, {}, {}, {}, {}, {}, {}, script = {}, objectScripts = { {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {},}, }
end

function mapFuncs.loadMap(mapName)
	mapName = mapFuncs.checkMap(mapName)
	
	if mapName then
		local tempFile, bytes= love.filesystem.read(mapName)
		local map = table.load(tempFile)
		if not(map.wildPokemon) then map.wildPokemon = {1,2,3,4,5,6,7,8,9} end
		if map then
			player.load(map)
			mapFuncs.buildMap(map, layer)
			--love.audio.play(sounds.palletTown) 
			return map
		else 
			return false
		end
	end
	return false
end

function mapFuncs.buildMap(map, layer, tileData)
	
	if layer then
		if tileData then
			layers[layer]:addq( tiles[tileData.newTileX][tileData.newTileY].quad, tileData.X, tileData.Y )
		else
			layers[layer]:clear()
			for i,v in pairs(map[layer]) do
				for k,d in pairs(v) do
					layers[layer]:addq( tiles[d.X][d.Y].quad, (tileSize*i)-tileSize,  (tileSize*k)-tileSize )
				end
			end			
		end

	else	
		--Build Map
		for o,p in pairs(map) do
			if not(string.len(o)>1) then
				layers[o]:bind()
				layers[o]:clear()
				
				for i,v in pairs(p) do
					for k,d in pairs(v) do
						layers[o]:addq( tiles[d.X][d.Y].quad, getPixel(i)-tileSize,  getPixel(k)-tileSize )
					end
				end
				layers[o]:unbind()		
			end
		end
	end
			
end

function mapFuncs.saveMap(mapName, mapData)
	local data = table.save(mapData)
	love.filesystem.write(mapName..'.pkm', data)
end

function mapFuncs.draw(map, editor)
	
	if player.battling then	
		player.battlingDraw()
	else
		for i,v in ipairs(layers) do
			if i == 2 then

			end
			if not(i == 5) then
				love.graphics.draw(v,0,0)
			end
			if i == 2 then
				signs:draw()
				love.graphics.draw(layers[5])
				if map.script.playerStart then
					player.move() 
					player.draw()
					
					
				end
			end
		end
		--print(love.timer.getFPS())
	end
end