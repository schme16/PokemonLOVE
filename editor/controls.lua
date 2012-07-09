controls = {
	up = 'w',
	down = 's',
	left = 'a',
	right = 'd',
	accept = 'enter',
	cancel = ' ',
	delete = 'backspace',
}

newPress = {}
function getControl(key)
	if key == 'enter' then
		key = 13
	elseif key == 'backspace' then
		key = 8
	else
		key = string.byte(key)
	end
	
	return newPress[key]
end