Color = {}

function Color:color(r, g, b)
	color = {
		r = r,
		g = g,
		b = b
	}
	self.__index = self
	return setmetatable(color, self)
end


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

function Velocity:setSpeedX()
	self.speedX = math.max(math.min(self.speedX, self.max), self.min)
end

function Velocity:setSpeedY()
	self.speedY = math.max(math.min(self.speedY, self.max), self.min)
end

function Velocity:resetSpeed()
	self.speedX = 0; self.speedY = 0;
end

Player = {}

function Player:new(x, y, player_number, is_chaser, RGB, control_scheme, use_controller, controller_index)
	player = {
		x = x,
		y = y,
		name = "player" .. tostring(player_number),
		player_number = player_number,
		RGB = RGB,
		control_scheme = control_scheme,
		use_controller = use_controller,
		controller_index = controller_index
	}
	if is_chaser then
		player.velocity = Velocity:chaser()
	else
		player.velocity = Velocity:chasee()
	end
	self.__index = self
	return setmetatable(player, self)
end

function Player:update(delta_time, world)
	if not self.use_controller then
		self.control_scheme(delta_time, self, world)
	else
		self.control_scheme( self.controller_index, delta_time )
	end
end

function Player:swap_chaser()
	if self.player_number == chaser then
		self.velocity = Velocity:chaser(self.velocity)
	else
		self.velocity = Velocity:chasee(self.velocity)
	end
end

function Player:add_point()
	if self.player_number == chaser then
		if self.player_number == 1 then
			Score.score_count.player1score = Score.score_count.player1score + 1
		elseif self.player_number == 2 then
			Score.score_count.player2score = Score.score_count.player2score + 1
		elseif self.player_number == 2 then
			Score.score_count.player3score = Score.score_count.player3score + 1
		elseif self.player_number == 2 then
			Score.score_count.player4score = Score.score_count.player4score + 1
		end
	end
end

function Player:draw(camera)
	love.graphics.setColor(self.RGB.r, self.RGB.g, self.RGB.b)
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

	player.velocity:setSpeedX()
	player.velocity:setSpeedY()

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

	player.velocity:setSpeedX()
	player.velocity:setSpeedY()

	local actualX, actualY = world:move(player, player.x + player.velocity.speedX, player.y + player.velocity.speedY)

	player.x = actualX
	player.y = actualY
end

function handle_joystick( joystick_number, delta_time )
	local current_joystick = love.joystick.getJoysticks()[joystick_number]
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

	player.velocity:setSpeedX()
	player.velocity:setSpeedY()

	local actualX, actualY = world:move(player, player.x + player.velocity.speedX, player.y + player.velocity.speedY)

	player.x = actualX
	player.y = actualY
end