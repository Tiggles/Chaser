function menu_update( delta_time )
	if love.keyboard.isDown("down") and love.timer.getTime() > next_menu_change then
		menu_index = menu_index + 1
		next_menu_change = love.timer.getTime() + 0.1
	elseif love.keyboard.isDown("up") and love.timer.getTime() > next_menu_change then
		menu_index = menu_index - 1
		next_menu_change = love.timer.getTime() + 0.1
	end
	menu_index = menu_index % menu_options

	if love.keyboard.isDown("return") then
		menu_start(menu_index + LUA_INDEX_OFFSET)
	end

	options_x = options_x + delta_time * 3

end

function menu_start(option) -- TODO refactor branching statements for different player counts
	if 1 == option then
		swap_time = love.timer.getTime() + math.random(5) + 3 
		world = bump.newWorld(64)
		chaser = math.floor(math.random(2))
		entities = {
			player1 = Player:new(gameboard.width * (1 / 3), gameboard.height * (1/2), 1, 1 == chaser),
			player2 = Player:new(gameboard.width * (2 / 3), gameboard.height * (1/2), 2, 2 == chaser),
			map = init_random_map(),
			score = nil
		}
				
		for i = 1, #entities.map.boundaries do
			world:add(entities.map.boundaries[i], entities.map.boundaries[i].x, entities.map.boundaries[i].y, entities.map.boundaries[i].width, entities.map.boundaries[i].height)
		end

		world:add(entities.player1, entities.player1.x, entities.player1.y, 20, 20)
		world:add(entities.player2, entities.player2.x, entities.player2.y, 20, 20)
		count_down = 3

		Score:setupTimer(game_time, nil, 20, options_x_start)
		draw = countdown_draw
		update = countdown_update
		player_count = 2
	elseif 2 == option and #love.joystick.getJoysticks() > 0 then
		chaser = math.floor(math.random(3))
		entities = {
			player1 = Player:new(gameboard.width * (1 / 3), gameboard.height * (1 / 3), 1, 1 == chaser),
			player2 = Player:new(gameboard.width * (2 / 3), gameboard.height * (1 / 3), 2, 2 == chaser),
			player3 = Player:new(gameboard.width * (1 / 2), gameboard.height * (2 / 3), 3, 3 == chaser),
			map = init_random_map(),
			score = nil
		}
		
		swap_time = love.timer.getTime() + math.random(5) + 3
		world = bump.newWorld(64)
		
		for i = 1, #entities.map.boundaries do
			world:add(entities.map.boundaries[i], entities.map.boundaries[i].x, entities.map.boundaries[i].y, entities.map.boundaries[i].width, entities.map.boundaries[i].height)
		end

		world:add(entities.player1, entities.player1.x, entities.player1.y, 20, 20)
		world:add(entities.player2, entities.player2.x, entities.player2.y, 20, 20)
		world:add(entities.player3, entities.player3.x, entities.player3.y, 20, 20)

		count_down = 3

		Score:setupTimer(game_time, nil, 20, options_x_start)
		draw = countdown_draw
		update = countdown_update
		
		player_count = 3
	elseif 3 == option and #love.joystick.getJoysticks() == 2 then
		chaser = math.floor(math.random(4))

		entities = {
			player1 = Player:new(gameboard.width * (2 / 6), gameboard.height * (1 / 4), 1, 1 == chaser), 
			player2 = Player:new(gameboard.width * (4 / 6), gameboard.height * (1 / 4), 2, 2 == chaser),
			player3 = Player:new(gameboard.width * (2 / 6), gameboard.height * (3 / 4), 3, 3 == chaser),
			player4 = Player:new(gameboard.width * (4 / 6), gameboard.height * (3 / 4), 4, 4 == chaser),
			map = init_random_map(),
			score = nil
		}

		swap_time = love.timer.getTime() + math.random(5) + 3
		world = bump.newWorld(64)
		
		for i = 1, #entities.map.boundaries do
			world:add(entities.map.boundaries[i], entities.map.boundaries[i].x, entities.map.boundaries[i].y, entities.map.boundaries[i].width, entities.map.boundaries[i].height)
		end

		world:add(entities.player1, entities.player1.x, entities.player1.y, 20, 20)
		world:add(entities.player2, entities.player2.x, entities.player2.y, 20, 20)
		world:add(entities.player3, entities.player3.x, entities.player3.y, 20, 20)
		world:add(entities.player4, entities.player4.x, entities.player4.y, 20, 20)

		count_down = 3

		Score:setupTimer(game_time, nil, 20, options_x_start)
		draw = countdown_draw
		update = countdown_update

		player_count = 4
	elseif 4 == option then
		love.event.quit()
	end
end

function menu_draw()
	love.graphics.setBackgroundColor(125, 125, 150)
	if 0 == menu_index then	
		love.graphics.setColor(0, 200, 255);
		loc_x = options_x_start + math.cos(options_x) * 5
	else 
		love.graphics.setColor(255, 255, 255); 
		loc_x = options_x_start 
	end
	love.graphics.printf( "2-player", loc_x, options_y_start + 50, 200, "center" )
	
	if 1 == menu_index then	love.graphics.setColor(0, 200, 255); loc_x = options_x_start + math.cos(options_x) * 5 else love.graphics.setColor(255, 255, 255); loc_x = options_x_start end
	if 0 == #love.joystick.getJoysticks() then love.graphics.setColor(255, 0, 0); end
	love.graphics.printf( "3-player (requires one controller)", loc_x, options_y_start + 100, 200, "center" )
	
	if 2 == menu_index then	love.graphics.setColor(0, 200, 255); loc_x = options_x_start + math.cos(options_x) * 5 else love.graphics.setColor(255, 255, 255); loc_x = options_x_start end
	if 2 > #love.joystick.getJoysticks() then love.graphics.setColor(255, 0, 0); end
	love.graphics.printf( "4-player (requires two controllers)", loc_x, options_y_start + 150, 200, "center" )
	
	if 3 == menu_index then	love.graphics.setColor(0, 200, 255); loc_x = options_x_start + math.cos(options_x) * 5 else love.graphics.setColor(255, 255, 255); loc_x = options_x_start end
	love.graphics.printf( "exit", loc_x, options_y_start + 200, 200, "center" )

end

function game_draw()
	love.graphics.setBackgroundColor(125, 100, 150)
	love.graphics.setColor(255, 0, 0)
	entities.player1:draw()
	love.graphics.setColor(0, 255, 0)
	entities.player2:draw()
	if entities.player3 ~= nil then
		love.graphics.setColor(0, 0, 255)
		entities.player3:draw()
	end
	if entities.player4 ~= nil then
		love.graphics.setColor(255, 255, 0)
		entities.player4:draw()
	end
	love.graphics.setColor(255, 255, 255)
	Score:drawScore()
end

function game_update(delta_time)
	entities.player1:update(1, delta_time, world)
	entities.player2:update(2, delta_time, world)
	if entities.player3 ~= nil then entities.player3:update(3, delta_time, world) end
	if entities.player4 ~= nil then entities.player4:update(4, delta_time, world) end
	handle_collisions( chaser )
	if swap_time < love.timer.getTime() then
		print("Swapping. Chaser is " .. chaser)
		swap_chaser(entities)
		print("Swapoed. Chaser is " .. chaser)
		swap_time = love.timer.getTime() + math.random(5) + 3
	end
	if Score:getCurrentGameTime() < 0 then
		draw = score_draw
		update = score_update
	end
	Score:updateTimer(delta_time)
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

function score_draw( )
	love.graphics.setBackgroundColor(150,150,150)
	love.graphics.setColor(255, 255, 255)
	love.graphics.printf( "TIME EXPIRED" , options_x_start, options_y_start, 200, "center" )
	love.graphics.printf( "To play again, press space", options_x_start, options_y_start + 100, 200, "center" )
	if entities.player1 ~= nil then
		love.graphics.setColor(255, 0, 0)
		love.graphics.printf( "Player 1: " .. Score.score_count.player1score, options_x_start, options_y_start + 20, 200, "center" )
	end
	if entities.player2 ~= nil then
		love.graphics.setColor(0, 255, 0)
		love.graphics.printf( "Player 2: " .. Score.score_count.player2score, options_x_start, options_y_start + 40, 200, "center" )
	end
	if entities.player3 ~= nil then
		love.graphics.setColor(0, 0, 255)
		love.graphics.printf( "Player 3: " .. Score.score_count.player3score, options_x_start, options_y_start + 60, 200, "center" )
	end
	if entities.player4 ~= nil then
		love.graphics.setColor(255, 255, 0)
		love.graphics.printf( "Player 4: " .. Score.score_count.player4score, options_x_start, options_y_start + 80, 200, "center" )
	end
end

function score_update()
	if time == nil then
		time = love.timer.getTime() + 0.5
	end
	if time < love.timer.getTime() then
		if love.keyboard.isDown("space") then
			time = nil
			update = menu_update
			draw = menu_draw
		end
	end
end