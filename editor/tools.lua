function getTile(n)
	return (math.ceil((n/tileSize)))
end

function getPixel(n)
	return (math.ceil(n)*tileSize)
end

function string.firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

