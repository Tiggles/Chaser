function game_update(delta_time)
	entities.player1:update(1, delta_time, world)
	entities.player2:update(2, delta_time, world)
	if check_collision(entities.player1, entities.player2) then
		add_point(entities)
		reset_position(entities)
	end
	if swap_time < love.timer.getTime() then
		swap_chaser(entities)
		swap_time = love.timer.getTime() + math.random(5) + 3 
	end
end

function menu_update( delta_time )
	if love.keyboard.isDown("down") then
		menu_index = menu_index + 1
	elseif love.keyboard.isDown("up") then
		menu_index = menu_index - 1
	end
	menu_index = menu_index % menu_options

	if love.keyboard.isDown("return") then
		start(menu_index + LUA_INDEX_OFFSET)
	end

	options_x = options_x + delta_time * 3

end

function start(option)
	if 1 == option then
		swap_time = love.timer.getTime() + math.random(5) + 3 
		world = bump.newWorld(64)
		entities = {
			player1 = Player:new(200, 200, false),
			player2 = Player:new(300, 200, true),
			map = init_random_map(),
			score = nil
		}
		world:add(entities.player1, entities.player1.x, entities.player1.y, 20, 20)
		world:add(entities.player2, entities.player2.x, entities.player2.y, 20, 20)
		draw = game_draw
		update = game_update
	end
end

function menu_draw()
	love.graphics.setColor(0, 0, 255)
	love.graphics.printf( "2-players", options_x_start + math.cos(options_x) * 5, options_y_start, 200, "center" )

end

function game_draw()
	love.graphics.setColor(255, 0, 0)
	entities.player1:draw()
	love.graphics.setColor(0, 255, 0)
	entities.player2:draw()
	love.graphics.setColor(255, 255, 255)
end