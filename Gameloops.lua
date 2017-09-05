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
		next_menu_change = love.timer.getTime() + 1
		menu_start(menu_index + LUA_INDEX_OFFSET)
	end

	options_x = options_x + delta_time * 3
end

function menu_start( option ) -- TODO refactor branching statements for different player counts
	entities = {}
	entities.players = {}
	if 1 == option then
		swap_time = love.timer.getTime() + math.random(5) + 3 
		world = bump.newWorld(64)
		entities.map = init_random_map()
					
		for i = 1, #entities.map.boundaries do
			world:add(entities.map.boundaries[i], entities.map.boundaries[i].x, entities.map.boundaries[i].y, entities.map.boundaries[i].width, entities.map.boundaries[i].height)
		end

		count_down = 3

		draw = menu_controls_draw
		update = menu_controls_update
		player_count = 0
	elseif 2 == option then
		love.event.quit()
	end
end

function menu_controls_draw()
	draw_input_strings()
end

function menu_controls_update()
	if menu_delay == nil then
		menu_delay = love.timer.getTime()
	end
	
	if not player_already_added(handleWASD) and love.keyboard.isDown("w", "a", "s", "d") then
		table.insert(entities.players, Player:new(gameboard.width * (2 / 6), gameboard.height * (1 / 4), 1, false, Color:color(255, 0, 0), handleWASD, false, 0))
		print("inserted WASD")
		player_count = player_count + 1
	end


	if not player_already_added(handleULRD) and love.keyboard.isDown("up", "left", "right", "down") then
		table.insert(entities.players, Player:new(gameboard.width * (2 / 3), gameboard.height * (1/2), 2, false, Color:color(0, 255, 0), handleULRD, false, 0))
		print("inserted ULRD")
		player_count = player_count + 1
	end	

	local current_joysticks = love.joystick.getJoysticks()

	if #current_joysticks > 0 then
		if not player_already_added_controller(handle_joystick_left, 1) and current_joysticks[1]:isDown( 5 ) then -- LB
			table.insert(entities.players, Player:new(gameboard.width * (4 / 10), gameboard.height * (1/2), 2, false, Color:color(0, 0, 255), handle_joystick_left, true, 1))
			print("inserted Left joystick 1")
			player_count = player_count + 1
		end
		if not player_already_added_controller(handle_joystick_right, 1) and current_joysticks[1]:isDown( 6 ) then -- RB
			table.insert(entities.players, Player:new(gameboard.width * (4 / 10), gameboard.height * (1/2), 2, false, Color:color(0, 255, 255), handle_joystick_right, true, 1))
			print("inserted Right joystick 1")
			player_count = player_count + 1
		end
		if #current_joysticks > 1 then
			if not player_already_added_controller(handle_joystick_left, 2) and current_joysticks[2]:isDown( 5 ) then -- LB
				table.insert(entities.players, Player:new(gameboard.width * (4 / 10), gameboard.height * (1/2), 2, false, Color:color(255, 255, 0), handle_joystick_left, true, 2))
				print("inserted Left joystick 2")
				player_count = player_count + 1
			end
			if not player_already_added_controller(handle_joystick_right, 2) and current_joysticks[2]:isDown( 6 ) then -- RB
				table.insert(entities.players, Player:new(gameboard.width * (4 / 10), gameboard.height * (1/2), 2, false, Color:color(255, 0, 255), handleJoystickRight, true, 2))
				print("inserted Right joystick 2")
				player_count = player_count + 1
			end
		end
	end

	if love.keyboard.isDown("return") and #entities.players > 1 and love.timer.getTime() > menu_delay + 0.2 then
		chaser = math.random(1, #entities.players)
		entities.players[chaser].velocity = Velocity:chaser()
		for i = 1, #entities.players do
			local player = entities.players[i]
			world:add(player, player.x, player.y, 32, 32)
		end
		draw = menu_time_draw
		update = menu_time_update
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
	love.graphics.printf( "Play", loc_x, options_y_start + 50, 200, "center" )
	if 1 == menu_index then	love.graphics.setColor(0, 200, 255); loc_x = options_x_start + math.cos(options_x) * 5 else love.graphics.setColor(255, 255, 255); loc_x = options_x_start end
	love.graphics.printf( "Quit", loc_x, options_y_start + 100, 200, "center" )
end

function menu_time_draw()
	love.graphics.printf( "Select time (in seconds): " .. game_time, loc_x, options_y_start, 200, "center" )
end

function menu_time_update()
	if love.keyboard.isDown("return") and next_menu_change < love.timer.getTime() then
		draw = countdown_draw
		update = countdown_update
		Score:setupTimer(game_time, nil, 20, options_x_start)
	end
	if love.keyboard.isDown("up") and next_menu_change < love.timer.getTime() then
		next_menu_change = love.timer.getTime() + 0.05
		game_time = math.min(game_time + 1, 99999)
	elseif love.keyboard.isDown("down") and next_menu_change < love.timer.getTime() then
		next_menu_change = love.timer.getTime() + 0.05
		game_time = math.max(game_time - 1, 1)
	end	
end

function game_draw()
	love.graphics.setBackgroundColor(125, 100, 150)
	for i = 1, #entities.players do
		entities.players[i]:draw()
	end
	Score:drawScore()
end

function game_update(delta_time)
	for i = 1, #entities.players do
		entities.players[i]:update(delta_time, world)
	end
	handle_collisions( chaser )
	if swap_time < love.timer.getTime() then
		swap_chaser(entities)
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
	
	love.graphics.setColor(255, 0, 0)
	love.graphics.printf( "Player 1: " .. Score.score_count.player1score, options_x_start, options_y_start + 20, 200, "center" )
	
	love.graphics.setColor(0, 255, 0)
	love.graphics.printf( "Player 2: " .. Score.score_count.player2score, options_x_start, options_y_start + 40, 200, "center" )
	
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
