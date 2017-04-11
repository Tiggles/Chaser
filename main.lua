require "Entities"
require "Helper_Functions"
require "Score"
require "bump/bump"


in_focus = false

entities = {}

function love.focus(focus)
	in_focus = focus
end

function love.load(args)
	world = bump.newWorld(64)
	entities = {
		player1 = Player:new(200, 200, false),
		player2 = Player:new(300, 200, true),
		map = init_random_map(),
		score = nil
	}
end

function love.update(delta_time)
	if love.keyboard.isDown("escape") then love.event.quit() end
	entities.player1:update(1, delta_time)
	entities.player2:update(2, delta_time)
end

function love.draw()
	entities.player1:draw(1)
	entities.player2:draw(2)
	if check_collision(entities.player1, entities.player2) then
		add_point(entities)
		reset_position(entities)
	end
end
