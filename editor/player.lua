

	local playerSprites = love.graphics.newImage(prefix..'playerIcon.png')
	playerSprites:setFilter('nearest','nearest')

player = {
	standing = {
		down = love.graphics.newQuad( 0, 0, 17, 25, playerSprites:getWidth(), playerSprites:getHeight() ),
		up = love.graphics.newQuad( 102, 0, 17, 25, playerSprites:getWidth(), playerSprites:getHeight() ),
		left = love.graphics.newQuad( 153, 0, 17, 25, playerSprites:getWidth(), playerSprites:getHeight() ),
		right = love.graphics.newQuad( 51, 0, 17, 25, playerSprites:getWidth(), playerSprites:getHeight() ),
	},
	walking = {
		down = newImageAnimation(playerSprites, 0.4,{{17, 0, 17, 25}, {34, 0, 17, 25}}),
		up = newImageAnimation(playerSprites, 0.4,{{119, 0, 17, 25},{136, 0, 17, 25}}),
		left = newImageAnimation(playerSprites, 0.4,{{170, 0, 17, 25},{187, 0, 17, 25},}),
		right = newImageAnimation(playerSprites, 0.4,{{68, 0, 17, 25},{85, 0, 17, 25}}),
	},
	rise = 0, 
	run = 0, 
	moving = false, 
	facing = 'down',
	spriteBatch = {
		up =  love.graphics.newSpriteBatch( playerSprites, 10 ),
		down =  love.graphics.newSpriteBatch( playerSprites, 10 ),
		left =  love.graphics.newSpriteBatch( playerSprites, 10 ),
		right =  love.graphics.newSpriteBatch( playerSprites, 10 ),
	},
	battling = false,
}


function player.checkCollision(x,y)
	if map[2][math.ceil(x)+1] and map[2][math.ceil(x)+1][math.ceil(y)+1] then
		return true
	elseif map.objectScripts[math.ceil(x)+1] and map.objectScripts[math.ceil(x)+1][math.ceil(y)+1] then

		return true
	end
end

function player.getSpeed()
	
	return 8*dt
end

function player.getTile()
	return math.ceil(player.X), math.ceil(player.Y)
end

function player.getPixel()
	local pX,pY = player.getTile()
	return getPixel(pX), getPixel(pY)
end

function player.draw(editor)
	if not (editor) then
		if player.moving then
			player.walking[player.facing]:draw(math.ceil(player.drawX), math.ceil(player.drawY))
		else
			love.graphics.drawq(playerSprites, player.standing[player.facing], math.ceil(player.drawX), math.ceil(player.drawY))	
		end
	else
		love.graphics.drawq(playerSprites, player.standing[player.facing], editor.X, editor.Y)	
	end
end

function player.load(map)
	player.X, player.Y = map.script.playerStart.X/tileSize ,map.script.playerStart.Y/tileSize
	player.drawX, player.drawY = (map.script.playerStart.X), (map.script.playerStart.Y)	
end

function player.move()
	local distance = math.sqrt((getPixel(player.X) - player.drawX)^2 + (getPixel(player.Y) - player.drawY)^2)
	if (player.moving) then
		if distance < 1 then
			player.run = 0
			player.rise = 0
			player.moving = false
		end
	end
	player.drawX = player.drawX+player.run
	player.drawY = player.drawY+player.rise
	if not(player.moving) then
		if love.keyboard.isDown('w') or love.keyboard.isDown('up') then
			player.facing = 'up'
		elseif love.keyboard.isDown('a') or love.keyboard.isDown('left') then

			player.facing = 'left'
		elseif love.keyboard.isDown('s') or love.keyboard.isDown('down') then

			player.facing = 'down'
		elseif love.keyboard.isDown('d') or love.keyboard.isDown('right') then

			player.facing = 'right'
		end
		
		if (love.keyboard.isDown('w') or love.keyboard.isDown('up')) and not(player.checkCollision(player.X, player.Y-1)) then
			player.Y = player.Y-1
			player.facing = 'up'
			player.moving = true
		elseif (love.keyboard.isDown('a') or love.keyboard.isDown('left')) and not(player.checkCollision(player.X-1, player.Y)) then
			player.X = player.X-1
			player.moving = true
			player.facing = 'left'
		elseif (love.keyboard.isDown('s') or love.keyboard.isDown('down')) and not(player.checkCollision(player.X, player.Y+1)) then
			player.Y = player.Y+1
			player.moving = true
			player.facing = 'down'
		elseif (love.keyboard.isDown('d') or love.keyboard.isDown('right')) and not(player.checkCollision(player.X+1, player.Y)) then
			player.X = player.X+1
			player.moving = true
			player.facing = 'right'
		end
		
		player.run = (((getPixel(player.X) - player.drawX)))*player.getSpeed()
		player.rise = (((getPixel(player.Y) - player.drawY)))*player.getSpeed()
		if player.rise ~= 0 or player.run ~= 0 then
			--print(player.rise, player.run)
		end
	end
end

function player.battlingDraw()
	if pokeData then 
		love.graphics.draw(pokeData.front, 100,100)
	end
end















