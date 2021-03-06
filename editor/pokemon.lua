pokedex = {
	{name = "Bulbasaur", hp = 45, attack = 49, speed = 45, special = 65, front = love.graphics.newImage(prefix..'sprites/'.. 1 ..'.png'), back = love.graphics.newImage(prefix..'sprites/back/'.. 1 ..'.png')},
	{name = "Ivysaur", hp = 60, attack = 62, speed = 60, special = 80, front = love.graphics.newImage(prefix..'sprites/'.. 2 ..'.png'), back = love.graphics.newImage(prefix..'sprites/back/'.. 2 ..'.png')},
	{name = "Venusaur", hp = 80, attack = 82, speed = 80, special = 100, front = love.graphics.newImage(prefix..'sprites/'.. 3 ..'.png'), back = love.graphics.newImage(prefix..'sprites/back/'.. 3 ..'.png')},
	{name = "Charmander", hp = 39, attack = 52, speed = 65, special = 50, front = love.graphics.newImage(prefix..'sprites/'.. 4 ..'.png'), back = love.graphics.newImage(prefix..'sprites/back/'.. 4 ..'.png')},
	{name = "Charmeleon", hp = 58, attack = 64, speed = 80, special = 65, front = love.graphics.newImage(prefix..'sprites/'.. 5 ..'.png'), back = love.graphics.newImage(prefix..'sprites/back/'.. 5 ..'.png')},
	{name = "Charizard", hp = 78, attack = 84, speed = 100, special = 85, front = love.graphics.newImage(prefix..'sprites/'.. 6 ..'.png'), back = love.graphics.newImage(prefix..'sprites/back/'.. 6 ..'.png')},
	{name = "Squirtle", hp = 44, attack = 65, speed = 43, special = 50, front = love.graphics.newImage(prefix..'sprites/'.. 7 ..'.png'), back = love.graphics.newImage(prefix..'sprites/back/'.. 7 ..'.png')},
	{name = "Wartortle", hp = 59, attack = 80, speed = 58, special = 65, front = love.graphics.newImage(prefix..'sprites/'.. 8 ..'.png'), back = love.graphics.newImage(prefix..'sprites/back/'.. 8 ..'.png')},
	{name = "Blastoise", hp = 79, attack = 100, speed = 78, special = 85, front = love.graphics.newImage(prefix..'sprites/'.. 9 ..'.png'), back = love.graphics.newImage(prefix..'sprites/back/'.. 9 ..'.png')},
	{name = "Caterpie", hp = 45, attack = 30, speed = 45, special = 20, front = love.graphics.newImage(prefix..'sprites/'.. 10 ..'.png'), back = love.graphics.newImage(prefix..'sprites/back/'.. 10 ..'.png')},
	{name = "Metapod", hp = 50, attack = 20, speed = 30, special = 25, front = love.graphics.newImage(prefix..'sprites/'.. 11 ..'.png'), back = love.graphics.newImage(prefix..'sprites/back/'.. 11 ..'.png')},
	{name = "Butterfree", hp = 60, attack = 45, speed = 70, special = 80, front = love.graphics.newImage(prefix..'sprites/'.. 12 ..'.png'), back = love.graphics.newImage(prefix..'sprites/back/'.. 12 ..'.png')},
	{name = "Weedle", hp = 40, attack = 35, speed = 50, special = 20, front = love.graphics.newImage(prefix..'sprites/'.. 13 ..'.png'), back = love.graphics.newImage(prefix..'sprites/back/'.. 13 ..'.png')},
	{name = "Kakuna", hp = 45, attack = 25, speed = 35, special = 25, front = love.graphics.newImage(prefix..'sprites/'.. 14 ..'.png'), back = love.graphics.newImage(prefix..'sprites/back/'.. 14 ..'.png')},
	{name = "Beedrill", hp = 65, attack = 80, speed = 75, special = 45, front = love.graphics.newImage(prefix..'sprites/'.. 15 ..'.png'), back = love.graphics.newImage(prefix..'sprites/back/'.. 15 ..'.png')},
}

function getWildPokeStat(pID, level, shiney)
	local tempPoke = pokedex[pID]
	tempPoke.pID = pID
	tempPoke.level = level
	tempPoke.shiney = shiney
	tempPoke.hp = tempPoke.hp+(1.5*level)
	tempPoke.attack = tempPoke.attack+(1.5*level)
	tempPoke.speed = tempPoke.speed+(1.5*level)
	tempPoke.special = tempPoke.special+(1.5*level)
	tempPoke.maxHP = tempPoke.hp
	return tempPoke
end