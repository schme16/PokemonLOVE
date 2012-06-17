prefix = 'editor/' 

require('editor.sound')
require('editor.tools')
require('editor.vector')
require('editor.controls')
require('editor.camera')
require('editor.imageBatch')
require('editor.pokemon')
require('editor.player')
require('editor.entities')
require('editor.map')
require('editor.SaveTable')
require('editor.errors')


--cam = Camera(vector(love.graphics.getWidth()/2, love.graphics.getHeight()/2),1.5) 



fonts = {}
fonts[12] = love.graphics.newFont(11)
fonts[30] = love.graphics.newFont(30)
love.graphics.setFont(fonts[30])

--fontImage = love.graphics.newImageFont("editor/font.png", "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890")


function love.load()
	tileSize = 16
	numTiles = 50
	
	local mapCheck = mapFuncs.checkMap('map1')
	if mapCheck then
		tiles, tileset = mapFuncs.loadQuads(numTiles,tileSize)
		map = mapFuncs.loadMap('map1')
	else
		map = false
	end
	dt = math.min(0.002, love.timer.getDelta()) 	

	
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
	if unicode > 0 then
		--print(string.byte(key),string.char(string.byte(key)))
		newPress[unicode] = true
		newPress['curKey'] = unicode
	end

	

	
	player.move(key)
	if key == 'f1' then
	end
	

end

function love.draw()
	--cam:draw(love.drawP)
	love.drawP()
end

function love.drawP()
	if map then
		mapFuncs.draw(map)
	else
		love.graphics.printf(errors['noMap'], 100,100, 600)
	end
	newPress = {}
end


















