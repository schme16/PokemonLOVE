
msgWindow = love.graphics.newImage(prefix..'msgWindow.png')
msgWindow:setFilter('nearest','nearest')


signs = {}
signsTemplate = {
	{X = 5, Y = 2, script = function(x,y,etc) if player.X == x and (player.Y-1) == y then signs:drawSelf(etc.text,etc.page ) end end , solid = true, onAdd = signs.addFunc},  --Signs
}

x =0
local text = ""


function acceptedKey(t)
	local a={
		['a'] = true,
		['b'] = true,
		['c'] = true,
		['d'] = true,
		['e'] = true,
		['f'] = true,
		['g'] = true,
		['h'] = true,
		['i'] = true,
		['j'] = true,
		['k'] = true,
		['l'] = true,
		['m'] = true,
		['n'] = true,
		['o'] = true,
		['p'] = true,
		['q'] = true,
		['r'] = true,
		['s'] = true,
		['t'] = true,
		['u'] = true,
		['v'] = true,
		['w'] = true,
		['x'] = true,
		['y'] = true,
		['z'] = true,
		['A'] = true,
		['B'] = true,
		['C'] = true,
		['D'] = true,
		['E'] = true,
		['F'] = true,
		['G'] = true,
		['H'] = true,
		['I'] = true,
		['J'] = true,
		['K'] = true,
		['L'] = true,
		['M'] = true,
		['N'] = true,
		['O'] = true,
		['P'] = true,
		['Q'] = true,
		['R'] = true,
		['S'] = true,
		['T'] = true,
		['U'] = true,
		['V'] = true,
		['W'] = true,
		['X'] = true,
		['Y'] = true,
		['Z'] = true,	
		['!'] = true,
		["'"] = true,
		['"'] = true,
		['['] = true,
		[']'] = true,
		['1'] = true,
		['2'] = true,
		['3'] = true,
		['4'] = true,
		['5'] = true,
		['6'] = true,
		['7'] = true,
		['8'] = true,
		['9'] = true,
		['0'] = true,
		['!'] = true,
		['@'] = true,
		['#'] = true,
		['$'] = true,
		['%'] = true,
		['^'] = true,
		['&'] = true,
		['*'] = true,
		['('] = true,
		[')'] = true,
		['-'] = true,
		['_'] = true,
		['='] = true,
		['`'] = true,
		['~'] = true,
		['}'] = true,	
		[' '] = true,	
		['>'] = true,	
		['<'] = true,	
		['?'] = true,	
		['/'] = true,	
		['\\'] = true,	
		['|'] = true,	
		['.'] = true,	
	}
	
	if a[t] then return true else return false end
	
end
	local text
	local page 
function signs:addFunc(start)
print('1      1')
	if start then
		text = {""} 
		page = 1 
	end
	if not(text[page]) then text[page] = '' end
	local len = love.graphics.getFont():getWidth(text[page])
	if len > 1200 then page = page+1 end
	if len == 0 and keyIndex[8] and page > 1 then page = page-1 end
	if not(text[page]) then text[page] = '' end
	if keyIndex['curKey'] == 13 then 
		map.objectScripts[currentFunc.X][currentFunc.Y] = {
			script = currentFunc.ent.script,
			imgX = currentFunc.ent.X,
			imgY = currentFunc.ent.Y,
			X=currentFunc.X,
			Y=currentFunc.Y,
			id=currentFunc.id,
			etc = {text = text, page = 1},
		}
		currentFunc = nil
	else
		if keyIndex['curKey'] then
			if keyIndex[8] then 
				text[page] = string.sub(text[page], 0,text[page]:len()-1)
			elseif acceptedKey(string.char(keyIndex['curKey'])) then
				text[page] = tostring(text[page])..string.char(keyIndex['curKey'])
			end
		end
	
	end
	signs:drawSelf(text,page, true)
end

function signs:drawSelf(text, page, overrideDraw)
	love.graphics.setFont(fonts[12])
	if player.facing =='up' and not(player.moving) or overrideDraw then
		love.graphics.draw(msgWindow,(love.graphics.getWidth()/2)-100, love.graphics.getHeight()-55)

		local textY = (love.graphics.getHeight()-63)
		local textX = ((love.graphics.getWidth()/2)-100)+5
		textY = textY + (textY-(textY)+(fonts[12]:getHeight()))
		
		love.graphics.setColor(0,0,0,255)

		if type(text) == 'string' then
			--textX = textX + (textX+((fonts[12]:getWidth(text)/2)))
			--text = (wrap(text))
			love.graphics.printf(tostring(text),textX, textY,192)
		elseif type(text) == 'table' then
			love.graphics.printf(tostring(text[1]),textX, textY,192)
		end
		love.graphics.setColor(255,255,255,255)
	end
	love.graphics.setFont(fonts[30])
		
end

function signs:add(id, x, y)
	local ent = signs[id]
	currentFunc = {run = ent.onAdd, ent = ent,X=x,Y=y, id = id, firstRun = true}
end

function signs:draw()
	for x,v in pairs(map.objectScripts) do
		for y,d in pairs(v) do
			local ent = signsTemplate[d.id]
				ent.script(x-1,y-1,d.etc)

			if ent then love.graphics.drawq(tileset, tiles[ent.X][ent.Y].quad, (tileSize*x)-tileSize,  (tileSize*y)-tileSize) end
		end
	end

end

function signs:addRun()
	if currentFunc then 
		if currentFunc.firstRun then
			currentFunc.firstRun = false
			currentFunc:run(true)
		else
			currentFunc:run()
		end

	end
end



entitiesList = {}
entities = {}

entityFuncs = {
	wildEncounter = function()
		if player.moving and map.wildPokemon then
			local chance = 250
			local num = math.random(1,chance)
			
		
			if num == math.ceil(chance/2) then
				chance = #map.wildPokemon
				num = math.random(1, chance)
				if pokedex[num] then
					pokeData = {name = pokedex[num].name,
					front = love.graphics.newImage(prefix..'sprites/'..num..'.png'),
					back = love.graphics.newImage(prefix..'sprites/back/'..num..'.png'),
					}
				end
				
				if pokeData then player.battling = pokeData end
			end
		end
	end,

}


function entities.build()
	entitiesList[7] = {}
	entitiesList[7][1] = entityFuncs.wildEncounter--Long Grass
end

entities.build()

function entities.draw(map, pX, pY)
pX, pY = pX+1, pY+1
	if map[5][pX] then
					--print(1111)
		if map[5][pX][pY] then
					---print(2222)
			if entitiesList[map[5][pX][pY].X] then
					---print(3333)
				if entitiesList[map[5][pX][pY].X][map[5][pX][pY].Y] then
					--love.graphics.rectangle('fill', getPixel(pX-1), getPixel(pY), 16,16)
					entitiesList[map[5][pX][pY].X][map[5][pX][pY].Y]()
				end
			end
		end
	end
end




























