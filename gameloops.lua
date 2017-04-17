function menu_update( delta_time )
	if love.keyboard.isDown("down") and love.timer.getTime() > next_menu_change then
		menu_index = menu_index + 1
		next_menu_change = love.timer.getTime() + 0.5
	elseif love.keyboard.isDown("up") and love.timer.getTime() > next_menu_change then
		menu_index = menu_index - 1
		next_menu_change = love.timer.getTime() + 0.5
	end
	menu_index = menu_index % menu_options

	if love.keyboard.isDown("return") then
		menu_start(menu_index + LUA_INDEX_OFFSET)
	end

	options_x = options_x + delta_time * 3

end

function menu_start(option)
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
		count_down = 3
		Score:setupTimer()
		draw = countdown_draw
		update = countdown_update
	elseif 2 == option then
		love.event.quit()
	end
end

function menu_draw()
	if 0 == menu_index then	love.graphics.setColor(0, 0, 255); loc_x = options_x_start + math.cos(options_x) * 5 else love.graphics.setColor(255, 255, 255); loc_x = options_x_start end
	love.graphics.printf( "2-players", loc_x, options_y_start, 200, "center" )
	if 1 == menu_index then	love.graphics.setColor(0, 0, 255); loc_x = options_x_start + math.cos(options_x) * 5 else love.graphics.setColor(255, 255, 255); loc_x = options_x_start end
	love.graphics.printf( "exit", loc_x, options_y_start + 50, 200, "center" )

end

function game_draw()
	love.graphics.setColor(255, 0, 0)
	entities.player1:draw()
	love.graphics.setColor(0, 255, 0)
	entities.player2:draw()
	love.graphics.setColor(255, 255, 255)
	Score:drawScore()
end

function game_update(delta_time)
	entities.player1:update(1, delta_time, world)
	entities.player2:update(2, delta_time, world)
	if check_collision(entities.player1, entities.player2) then
		add_point(entities)
		reset_position(entities)
		count_down = 3
		update = countdown_update
		draw = countdown_draw
	end
	if swap_time < love.timer.getTime() then
		swap_chaser(entities)
		swap_time = love.timer.getTime() + math.random(5) + 3 
	end
end

function countdown_update( delta_time )
	if count_down < 0 then
		update = game_update
		draw = game_draw
	end
	count_down = count_down - delta_time
end

function countdown_draw()
	game_draw()
	love.graphics.setColor(255,255,255)
	love.graphics.printf( math.ceil(count_down), options_x_start, options_y_start, 200, "center" )
end