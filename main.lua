prefix = 'editor/' 
require('editor.tools')
require('editor.vector')
require('editor.camera')
require('editor.imageBatch')
require('editor.player')
require('editor.entities')
require('editor.map')
require('editor.saveTable')


--cam = Camera(vector(love.graphics.getWidth()/2, love.graphics.getHeight()/2),1.5) 



fonts = {}
fonts[12] = love.graphics.newFont(11)
fonts[30] = love.graphics.newFont(30)
love.graphics.setFont(fonts[30])

--fontImage = love.graphics.newImageFont("editor/font.png", "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890")


function love.load()
	tileSize = 16
	numTiles = 50

	tiles, tileset = mapFuncs.loadQuads(numTiles,tileSize)
	map = mapFuncs.loadMap('map1')
	

	
end

function love.update()
	local X = love.mouse.getX()
	local Y = love.mouse.getY()
	local tileX = getTile(X)
	local tileY = getTile(Y)
	--cam = Camera(vector(player.drawX, player.drawY),1.5) 
	
	
end

function love.mousepressed(x,y,key)
end

function love.keypressed(key,unicode)

	

	
	player.move(key)
	if key == 'f1' then
	end
	

end

function love.draw()
	--cam:draw(love.drawP)
	love.drawP()
end

function love.drawP()
	mapFuncs.draw(map)
end


















