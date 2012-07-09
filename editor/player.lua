

	local playerSprites = love.graphics.newImage(prefix..'playerIcon.png')
	playerSprites:setFilter('nearest','nearest')
	local battleStageBG = love.graphics.newImage(prefix..'gui/grassBG.png')
	local battleStagePlatforms = love.graphics.newImage(prefix..'gui/grassStage.png')
	local battleStageInfo = love.graphics.newImage(prefix..'gui/infoBars.png')
	local infoBarsHP = love.graphics.newImage(prefix..'gui/infoBarsHP.png')
	local infoBarsHPBG = love.graphics.newImage(prefix..'gui/infoBarsHPBG.png')
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
	party = {
			--{pID = 2, name = 'Phil', shiney = false, health = 100 } ,
	}
}


function player.checkCollision(x,y)
	if map[2][math.ceil(x)+1] and map[2][math.ceil(x)+1][math.ceil(y)+1] or  (map.objectScripts[math.ceil(x)+1] and map.objectScripts[math.ceil(x)+1][math.ceil(y)+1])then
		return true
	end
end

function player.getSpeed()
	
	return 4*dt
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
			player.walking[player.facing]:draw(math.ceil(player.drawX), math.ceil(player.drawY)-10)
		else
			love.graphics.drawq(playerSprites, player.standing[player.facing], math.ceil(player.drawX), math.ceil(player.drawY)-10)	
		end
	else
		love.graphics.drawq(playerSprites, player.standing[player.facing], editor.X, editor.Y-10)	
	end
end

function player.load(map)
	player.X, player.Y = map.script.playerStart.X/tileSize ,map.script.playerStart.Y/tileSize
	player.drawX, player.drawY = (map.script.playerStart.X), (map.script.playerStart.Y)	
end

function player.move()
	local distance = math.sqrt((getPixel(player.X) - player.drawX)^2 + (getPixel(player.Y) - player.drawY)^2)
	if (player.moving) then
	
		player.drawX = player.drawX+player.run
		player.drawY = player.drawY+player.rise	
		if distance < 1 then
			player.run = 0
			player.rise = 0
			player.moving = false
			entities.runFuncs(map, player.getTile())

		end
	end

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

function player.getFirstPartyPokemon() 
	for i,v in ipairs(player.party) do
		if v.health > 0 then
			return v
		end
	end
	return false
end

function player.battlingDraw()
	if player.battling then 
		--draw stage
		love.graphics.draw(battleStageBG, 0, 0)
		love.graphics.draw(battleStagePlatforms, 0, 0)
		love.graphics.draw(battleStageInfo, 0, 0)
		love.graphics.draw(infoBarsHPBG, 5, 25)
		love.graphics.setColor(255,0,0)
		local xVal = math.floor(1.37*((player.battling.hp/player.battling.maxHP))*100)
		love.graphics.rectangle('fill', 32, 28, xVal, 7)
		love.graphics.setColor(255,255,255)
		love.graphics.draw(infoBarsHP, 5, 25)
		
		
		--draw opponent
		love.graphics.draw(pokedex[player.battling.pID].front, 560, 146)
		
		if player.battling.hp <=0  then 
			signs:drawSelf(player.battling.name..' feinted! \n\r Press \''..string.firstToUpper(controls.accept)..'\' to leave', 1,true)
			if getControl(controls.accept) then player.battling = false end
			
		else
			player.battling.hp = player.battling.hp-0.05
		
			if not player.battling.continue then
				signs:drawSelf('A Wild '..player.battling.name..' Appeared!', 1,true)
				--love.graphics.print(, (love.graphics.getWidth()/2)-100,( love.graphics.getHeight( )/2)-100)
				if getControl(controls.accept) then player.battling.continue = true end
			else
				local playerPoke = player.getFirstPartyPokemon()
					
				if not(playerPoke) then
					signs:drawSelf('You have no Pokemon to fight with\n\rPress \''..string.firstToUpper(controls.accept)..'\' to flee...', 1,true)
					if getControl(controls.accept) then 
						player.battling = false
						--love.audio.stop()
						--love.audio.rewind(sounds.palletTown)			
						--love.audio.play(sounds.palletTown)			
					end
				else
					--draw player poke
					love.graphics.draw(pokedex[playerPoke.pID].back, 80, 530)
				end
			end
		end
	end
end















