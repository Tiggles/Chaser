require "Entities"
require "Helper_Functions"
require "Score"
local bump = require 'bump/bump'


function love.focus(focus)
	in_focus = focus
end

function love.load(args)
	in_focus = false
	swap_time = love.timer.getTime() + math.random(5) + 3 
	world = bump.newWorld(64)
	entities = {
		player1 = Player:new(200, 200, false),
		player2 = Player:new(300, 200, true),
		map = init_random_map(),
		score = nil
	}
end

function love.update(delta_time)
	check_exit()
	entities.player1:update(1, delta_time)
	entities.player2:update(2, delta_time)
	if check_collision(entities.player1, entities.player2) then
		add_point(entities)
		reset_position(entities)
	end
	if swap_time < love.timer.getTime() then
		swap_chaser(entities)
		swap_time = love.timer.getTime() + math.random(5) + 3 
	end
end

function love.draw()
	entities.player1:draw(1)
	entities.player2:draw(2)
end
