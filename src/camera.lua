Camera = {}
Camera._x = 0
Camera._y = 0
Camera.scaleX = 1
Camera.scaleY = 1
Camera.rotation = 0

function Camera:attach()
  	love.graphics.push()
  	love.graphics.rotate(-self.rotation)
  	love.graphics.scale(self.scaleX, self.scaleY)
  	love.graphics.translate(-self._x, -self._y)
end

function Camera:detach()
  	love.graphics.pop()
end

function Camera:move(dx, dy)
  	self._x = self._x + (dx or 0)
  	self._y = self._y + (dy or 0)
end

function Camera:rotate(dr)
  	self.rotation = self.rotation + dr
end

function Camera:scale(sx, sy)
  	sx = sx or 1
  	self.scaleX = self.scaleX * sx
  	self.scaleY = self.scaleY * (sy or sx)
end

function Camera:setX(value)
  	if self._bounds then
		self._x = math.clamp(value, self._bounds.x1, self._bounds.x2)
  	else
		self._x = value
  	end
end

function Camera:setY(value)
	if self._bounds then
	  	self._y = math.clamp(value, self._bounds.y1, self._bounds.y2)
  	else
	  	self._y = value
  	end
end

function Camera:setPosition(x, y)
	if x then self:setX(x) end
	if y then self:setY(y) end
end

function Camera:setScale(sx, sy)
	self.scaleX = sx or self.scaleX
	self.scaleY = sy or self.scaleY
end

function Camera:getBounds()
	return unpack(self._bounds)
end

function Camera:setBounds(x1, y1, x2, y2)
	self._bounds = { x1 = x1, y1 = y1, x2 = x2, y2 = y2 }
end

function Camera:getMousePosition()
	return love.mouse.getX() * self.scaleX + self._x, love.mouse.getY() * self.scaleY + self._y
end

function Camera:RePositionX( co_ord_x )
	return co_ord_x * self.scaleX + self._x
end

function Camera:RePositionY( co_ord_y )
	return co_ord_y * self.scaleY + self._y
end

function math.clamp(x, min, max)
	return x < min and min or (x > max and max or x)
end