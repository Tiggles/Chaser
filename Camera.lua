Camera = {}

function Camera:new(height, width, x, y)
	camera = {
		height = height,
		width = width,
		x = x,
		y = y,
	}
	self.__index = self
	return setmetatable(camera, self)
end

function Camera:updateSize(width, height)
	self.width = width
	self.height = height
end

function Camera:updatePlacement(x, y)
	self.x = x
	self.y = y
end