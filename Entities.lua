
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

function Velocity:chaser(old_velocity)
	if old_velocity ~= nil then
		vel = Velocity:new(7, 6)
		vel.speedX = old_velocity.speedX
		vel.speedY = old_velocity.speedY
		return vel
	else
		return Velocity:new(7, 6)
	end
end

function Velocity:chasee(old_velocity)
	if old_velocity ~= nil then
		vel = Velocity:new(6, 5)
		vel.speedX = old_velocity.speedX
		vel.speedY = old_velocity.speedY
		return vel
	else
		return Velocity:new(6, 5)
	end
end

function Velocity:resetSpeed()
	self.speedX = 0; self.speedY = 0;
end

Player = {}

function Player:new(x, y, player_number, is_chaser)
	player = {
		x = x,
		y = y,
		name = "player" .. tostring(player_number),
		player_number = player_number
	}
	if is_chaser then
		player.velocity = Velocity:chaser()
	else
		player.velocity = Velocity:chasee()
	end
	self.__index = self
	return setmetatable(player, self)
end

function Player:update(player_number, delta_time, world) -- Redo with function pointers instead?
	if 1 == self.player_number then
		handleWASD(delta_time, self, world)
	elseif 2 == self.player_number then
		handleULRD(delta_time, self, world)
	elseif 3 == self.player_number then
		if love.joystick.getJoystickCount() > 0 then
			handle_joystick(1, delta_time)
		end
	elseif 4 == self.player_number then
		if love.joystick.getNumJoysticks > 1 then
			handle_joystick(2, delta_time)
		end
	end
end

function Player:swap_chaser()
	if self.player_number == chaser then
		self.velocity = Velocity:chaser(self.velocity)
	else
		self.velocity = Velocity:chasee(self.velocity)
	end
end

function Player:add_point(player_number)
	if self.player_number == chaser then
		if 1 == player_number then
			Score.score_count.player1score = Score.score_count.player1score + 1
		elseif 2 == player_number then
			Score.score_count.player2score = Score.score_count.player2score + 1
		end
	end
end

function Player:draw(camera)
	if self.player_number == chaser then
		drawmode = "fill"
	else
		drawmode = "line"
	end
	love.graphics.rectangle(drawmode, self.x, self.y, 20, 20)
end

function handleULRD(delta_time, player, world)
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

	local actualX, actualY, cols, len = world:move(player, player.x + player.velocity.speedX, player.y + player.velocity.speedY)

	player.x = actualX
	player.y = actualY
end

function handleWASD(delta_time, player, world)
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

	local actualX, actualY = world:move(player, player.x + player.velocity.speedX, player.y + player.velocity.speedY)

	player.x = actualX
	player.y = actualY
end

function handle_joystick( joystick_number, delta_time )
	local current_joystick = love.joystick.getJoysticks()[joystick_number]
	player = {}
	if 1 == joystick_number then player = entities.player3 else player = entities.player4 end

	-- actual movement
	local left_right_axis = current_joystick:getAxis(1)
	local up_down_axis = current_joystick:getAxis(2)

	if left_right_axis > 0.2 or left_right_axis < -0.2 then
		player.velocity.speedX = player.velocity.speedX - player.velocity.delta * (left_right_axis * -1) * delta_time	
	elseif player.velocity.speedX < 0 then 
		player.velocity.speedX = math.min(player.velocity.speedX + (player.velocity.delta * 2 * delta_time), 0)
	elseif player.velocity.speedX > 0 then
		player.velocity.speedX = math.max(player.velocity.speedX - (player.velocity.delta * 2 * delta_time), 0)
	end

	if up_down_axis > 0.2 or up_down_axis < -0.2 then
		player.velocity.speedY = player.velocity.speedY - player.velocity.delta * (up_down_axis * -1) * delta_time
	elseif player.velocity.speedY < 0 then 
		player.velocity.speedY = math.min(player.velocity.speedY + (player.velocity.delta * 2 * delta_time), 0)
	elseif player.velocity.speedY > 0 then 
		player.velocity.speedY = math.max(player.velocity.speedY - (player.velocity.delta * 2 * delta_time), 0)
	end

	player.velocity.speedX = math.max(math.min(player.velocity.speedX, player.velocity.max), player.velocity.min)
	player.velocity.speedY = math.max(math.min(player.velocity.speedY, player.velocity.max), player.velocity.min)

	local actualX, actualY = world:move(player, player.x + player.velocity.speedX, player.y + player.velocity.speedY)

	player.x = actualX
	player.y = actualY
end