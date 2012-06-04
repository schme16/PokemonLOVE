local animation = {}
animation.__index = animation

function newImageAnimation(image, delay, frames)
	local a = {}
	local f = {}
	for i,v in ipairs(frames) do
		table.insert(f,love.graphics.newQuad( v[1], v[2], v[3],v[4], image:getWidth(), image:getHeight() ))
	end
	
	a.img = image
	a.timer = 0
	a.playing = true
	a.speed = delay
	a.rawFrames = frames
	a.frames = #f
	a.quads = f
	a.currentFrame = 1
	a.step = 0

	return setmetatable(a, animation)

end

function animation:update(dt)
	if self.playing then
		self.step = self.step + love.timer.getDelta()
		if self.step > self.speed then
			self.currentFrame = self.currentFrame + 1
			self.step = 0
			if self.currentFrame > self.frames then
				self.currentFrame = 1
			end
		end
	end
end

function animation:toggle(state)
	if state then self.playing = state else self.playing = not(self.playing) end
end

function animation:reset(frame)
	if frame then self.currentFrame = frame else self.currentFrame = 1 end
end

function animation:draw(x, y, angle, sx, sy, ox, oy)
	self:update()
	love.graphics.drawq(self.img, self.quads[self.currentFrame], x,y, angle,sx,sy,ox,oy)

	--love.graphics.drawq(self.frames[self.currentFrame], x, y, angle, sx, sy, ox, oy)
end