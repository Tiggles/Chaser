function check_collision(self, other)
	local self_left = self.x
    local self_right = self.x + 32
    local self_top = self.y
    local self_bottom = self.y + 32

    local other_left = other.x
    local other_right = other.x + 32
    local other_top = other.y
    local other_bottom = other.y + 32

    if self_right >= other_left and
    self_left <= other_right and
    self_bottom >= other_top and
    self_top <= other_bottom then
        return true
    else
        return false
    end
end

function init_random_map()
    boundaries = {}
    --Left
    table.insert(boundaries, { x = -1, y = 0, width = 1, height = gameboard.height })
    --Top
    table.insert(boundaries, { x = 0, y = -1, width = gameboard.width, height = 1 })
    -- Right
    table.insert(boundaries, { x = gameboard.width, y = 0, width = 1, height = gameboard.height })
    -- Bottom
    table.insert(boundaries, { x = 0, y = gameboard.height, width = gameboard.width, height = 1 })

    map = {
        boundaries = boundaries,
        boxes = nil
    }
    return map
end

function swap_chaser(entities)
    chaser = chaser % player_count + 1
    for i = 1, #entities.players do
        local player = entities.players[i];
        player:swap_chaser()
    end
end

function add_point()
    entities.players[chaser]:add_point()
end

function check_exit()
    if love.keyboard.isDown("escape") then love.event.quit() end
end

function reset_position(entities)
    set_position_by_player_count()
    for i = 1, #entities.players do
        local player = entities.players[i];
        world:update(player, player.x, player.y); player.velocity:resetSpeed();
    end
end

function set_position_by_player_count( ) -- TODO better random
    if 2 == player_count then
        if 1 == math.random(2) then
            x1 = gameboard.width * (1 / 3); y1 = gameboard.height * (1/2);
            x2 = gameboard.width * (2 / 3); y2 = gameboard.height * (1/2);
        else
            y1 = gameboard.height * (1 / 3); x1 = gameboard.width * (1/2);
            y2 = gameboard.height * (2 / 3); x2 = gameboard.width * (1/2);
        end
        if 1 == math.random(2) then
            entities.players[1].x = x1; entities.players[1].y = y1;
            entities.players[2].x = x2; entities.players[2].y = y2;
        else
            entities.players[2].x = x1; entities.players[2].y = y1;
            entities.players[1].x = x2; entities.players[1].y = y2;
        end
    elseif 3 == player_count then
        if 1 == math.random(2) then
            x1 = gameboard.width * (1 / 3); y1 = gameboard.height * (1 / 3)
            x2 = gameboard.width * (2 / 3); y2 = gameboard.height * (1 / 3)
            x3 = gameboard.width * (1 / 2); y3 = gameboard.height * (2 / 3)
        else
            x1 = gameboard.width * (1 / 3); y1 = gameboard.height * (2 / 3)
            x2 = gameboard.width * (2 / 3); y2 = gameboard.height * (2 / 3)
            x3 = gameboard.width * (1 / 2); y3 = gameboard.height * (1 / 3)
        end
        local rnd = math.random(3)
        if 1 == rnd then
            entities.players[1].x = x1; entities.players[1].y = y1;
            entities.players[2].x = x2; entities.players[2].y = y2;
            entities.players[3].x = x3; entities.players[3].y = y3;
        elseif 2 == rnd then
            entities.players[2].x = x1; entities.players[2].y = y1;
            entities.players[3].x = x2; entities.players[3].y = y2;
            entities.players[1].x = x3; entities.players[1].y = y3;
        else
            entities.players[3].x = x1; entities.players[3].y = y1;
            entities.players[1].x = x2; entities.players[1].y = y2;
            entities.players[2].x = x3; entities.players[2].y = y3;
        end
    else  -- 4 players
        if 1 == math.random(2) then
            x1 = gameboard.width * (2 / 6); y1 = gameboard.height * (1 / 4)
            x2 = gameboard.width * (4 / 6); y2 = gameboard.height * (1 / 4)
            x3 = gameboard.width * (2 / 6); y3 = gameboard.height * (3 / 4)
            x4 = gameboard.width * (4 / 6); y4 = gameboard.height * (3 / 4)
        else
            x1 = gameboard.width * (1 / 3); y1 = gameboard.height * (1 / 2)
            x2 = gameboard.width * (1 / 2); y2 = gameboard.height * (1 / 4)
            x3 = gameboard.width * (2 / 3); y3 = gameboard.height * (1 / 2)
            x4 = gameboard.width * (1 / 2); y4 = gameboard.height * (3 / 4)
        end
        local rnd = math.random(4)
        if 1 == rnd then
            entities.players[1].x = x1; entities.players[1].y = y1;
            entities.players[2].x = x2; entities.players[2].y = y2;
            entities.players[3].x = x3; entities.players[3].y = y3;
            entities.players[4].x = x4; entities.players[4].y = y4;        
        elseif 2 == rnd then
            entities.players[2].x = x1; entities.players[2].y = y1;
            entities.players[3].x = x2; entities.players[3].y = y2;
            entities.players[4].x = x3; entities.players[4].y = y3;
            entities.players[1].x = x4; entities.players[1].y = y4;
        elseif 3 == rnd then
            entities.players[3].x = x1; entities.players[3].y = y1;
            entities.players[4].x = x2; entities.players[4].y = y2;
            entities.players[1].x = x3; entities.players[1].y = y3;
            entities.players[2].x = x4; entities.players[2].y = y4;
        elseif 4 == rnd then
            entities.players[4].x = x1; entities.players[4].y = y1;
            entities.players[1].x = x2; entities.players[1].y = y2;
            entities.players[2].x = x3; entities.players[2].y = y3;
            entities.players[3].x = x4; entities.players[3].y = y4;
        end
    end
end

function handle_collisions( player_number )
    local player, others = get_players_to_compare( player_number )
    for i = 1, #others do
        if check_collision(player, others[i]) then
            add_point( player.player_number )
            reset_position(entities)
            count_down = 3
            swap_time = swap_time + 3
            update = countdown_update
            draw = countdown_draw
            return
        end
    end
end

function get_players_to_compare( player_number )
    local players = {}
    local player = entities.players[player_number]
    for i = 1, #entities.players do
        if entities.players[i].player_number ~= player_number then
            table.insert(players, entities.players[i])
        end
    end
    return player, players
end

function draw_input_strings()
    local location_x = gameboard.width / 2 - 50
    local location_y = gameboard.height / 2 - 100
    if not player_already_added(handleWASD) then
        love.graphics.setColor(255, 255, 255)
        love.graphics.printf( "Press W, S, A or D to join.", location_x, location_y, 200, "left" )
    else
        love.graphics.setColor(0, 255, 0)
        love.graphics.printf( "WASD joined.", location_x, location_y, 200, "left" )
    end
    if not player_already_added(handleULRD) then
        love.graphics.setColor(255, 255, 255)
        love.graphics.printf( "Press up, down, left or right to join.", location_x, location_y + 20, 300, "left" )
    else
        love.graphics.setColor(0, 255, 0)
        love.graphics.printf( "Up, down, left or right joined.", location_x, location_y + 20, 200, "left" )
    end
    if not player_already_added_controller(handle_joystick_left, 1) then
        love.graphics.setColor(255, 255, 255)
        love.graphics.printf( "Press LB on the first controller to join.", location_x, location_y + 40, 300, "left" )
    else
        love.graphics.setColor(0, 255, 0)
        love.graphics.printf( "LB on first controller joined.", location_x, location_y + 40, 200, "left" )
    end
    if not player_already_added_controller(handle_joystick_right, 1) then
        love.graphics.setColor(255, 255, 255)
        love.graphics.printf( "Press RB on the first controller to join.", location_x, location_y + 60, 300, "left" )
    else
        love.graphics.setColor(0, 255, 0)
        love.graphics.printf( "RB on first controller joined.", location_x, location_y + 60, 200, "left" )
    end
    if not player_already_added_controller(handle_joystick_left, 2) then
        love.graphics.setColor(255, 255, 255)
        love.graphics.printf( "Press LB on the second controller to join.", location_x, location_y + 80, 300, "left" )
    else
        love.graphics.setColor(0, 255, 0)
        love.graphics.printf( "LB on second controller joined.", location_x, location_y + 80, 200, "left" )
    end 
    if not player_already_added_controller(handle_joystick_right, 2) then
        love.graphics.setColor(255, 255, 255)
        love.graphics.printf( "Press RB on the second controller to join.", location_x, location_y + 100, 300, "left" )
    else
        love.graphics.setColor(0, 255, 0)
        love.graphics.printf( "LB on second controller joined.", location_x, location_y + 100, 200, "left" )
    end 
end

function player_already_added( control_scheme )
    for i = 1, #entities.players do
        if entities.players[i].control_scheme == control_scheme then return true end
    end
    return false
end

function player_already_added_controller( control_scheme, index )
    for i = 1, #entities.players do
        if entities.players[i].control_scheme == control_scheme then
            if entities.players[i].controller_index == index then
                return true 
            end
        end
    end
    return false
end