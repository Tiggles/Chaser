
Velocity = {}
	
function Velocity:new(delta, max_min)
	newVelocity = {
		speedX = 0,
		speedY = 0,
		delta = delta,
		min = -max_min,
		max = max_min
	}
	self.__index = self
	return setmetatable(newVelocity, self)
end

function Velocity:chaser()
	return Velocity:new(7, 6)
end

function Velocity:chasee()
	return Velocity:new(6, 5)
end

Player = {}

function Player:new(x, y, is_chaser)
	player = { 
		x = x,
		y = x,
		name = tostring(is_chaser) -- find other identifier
	}
	if is_chaser then
		player.velocity = Velocity:chaser()
	else
		player.velocity = Velocity:chasee()
	end
	self.__index = self
	return setmetatable(player, self)
end

function Player:update(player_number, delta_time)
	if 1 == player_number then
		handleWASD(delta_time, self)
	else
		handleULRD(delta_time, self)
	end
end

function Player:draw()
	love.graphics.rectangle("fill", self.x, self.y, 20, 20)
end

function handleULRD(delta_time, player)
	if love.keyboard.isDown("left") and not love.keyboard.isDown("right") then
		player.velocity.speedX = player.velocity.speedX - player.velocity.delta * delta_time
	elseif player.velocity.speedX < 0 then 
		player.velocity.speedX = math.min(player.velocity.speedX + (player.velocity.delta * 2 * delta_time), 0)
	end
	if love.keyboard.isDown("right") and not love.keyboard.isDown("left") then
		player.velocity.speedX = player.velocity.speedX + player.velocity.delta * delta_time
	elseif player.velocity.speedX > 0 then
		player.velocity.speedX = math.max(player.velocity.speedX - (player.velocity.delta * 2 * delta_time), 0)
	end
	--Vertical movement
	if love.keyboard.isDown("up") and not love.keyboard.isDown("down") then
		player.velocity.speedY = player.velocity.speedY - player.velocity.delta * delta_time
	elseif player.velocity.speedY < 0 then 
		player.velocity.speedY = math.min(player.velocity.speedY + (player.velocity.delta * 2 * delta_time), 0)
	end
	if love.keyboard.isDown("down") and not love.keyboard.isDown("up") then
		player.velocity.speedY = player.velocity.speedY + player.velocity.delta * delta_time
	elseif player.velocity.speedY > 0 then 
		player.velocity.speedY = math.max(player.velocity.speedY - (player.velocity.delta * 2 * delta_time), 0)
	end
	player.velocity.speedX = math.max(math.min(player.velocity.speedX, player.velocity.max), player.velocity.min)
	player.velocity.speedY = math.max(math.min(player.velocity.speedY, player.velocity.max), player.velocity.min)

	player.x = player.x + player.velocity.speedX
	player.y = player.y + player.velocity.speedY
end

function handleWASD(delta_time, player)
	if love.keyboard.isDown("a") and not love.keyboard.isDown("d") then
		player.velocity.speedX = player.velocity.speedX - player.velocity.delta * delta_time
	elseif player.velocity.speedX < 0 then 
		player.velocity.speedX = math.min(player.velocity.speedX + (player.velocity.delta * 2 * delta_time), 0)
	end
	if love.keyboard.isDown("d") and not love.keyboard.isDown("a") then
		player.velocity.speedX = player.velocity.speedX + player.velocity.delta * delta_time
	elseif player.velocity.speedX > 0 then
		player.velocity.speedX = math.max(player.velocity.speedX - (player.velocity.delta * 2 * delta_time), 0)
	end
	--Vertical movement
	if love.keyboard.isDown("w") and not love.keyboard.isDown("s") then
		player.velocity.speedY = player.velocity.speedY - player.velocity.delta * delta_time
	elseif player.velocity.speedY < 0 then 
		player.velocity.speedY = math.min(player.velocity.speedY + (player.velocity.delta * 2 * delta_time), 0)
	end
	if love.keyboard.isDown("s") and not love.keyboard.isDown("w") then
		player.velocity.speedY = player.velocity.speedY + player.velocity.delta * delta_time
	elseif player.velocity.speedY > 0 then 
		player.velocity.speedY = math.max(player.velocity.speedY - (player.velocity.delta * 2 * delta_time), 0)
	end
	player.velocity.speedX = math.max(math.min(player.velocity.speedX, player.velocity.max), player.velocity.min)
	player.velocity.speedY = math.max(math.min(player.velocity.speedY, player.velocity.max), player.velocity.min)

	player.x = player.x + player.velocity.speedX
	player.y = player.y + player.velocity.speedY
end