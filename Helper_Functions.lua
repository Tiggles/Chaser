function check_collision(self, other)
	local self_left = self.x
    local self_right = self.x + 20
    local self_top = self.y
    local self_bottom = self.y + 20

    local other_left = other.x
    local other_right = other.x + 20
    local other_top = other.y
    local other_bottom = other.y + 20

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
    entities.player1:swap_chaser()
    entities.player2:swap_chaser()
    if entities.player3 ~= nil then entities.player3:swap_chaser() end
    if entities.player4 ~= nil then entities.player4:swap_chaser() end
end

function add_point()
    entities.player1:add_point(1)
    entities.player2:add_point(2)
end

function check_exit()
    if love.keyboard.isDown("escape") then love.event.quit() end
end

function reset_position(entities)
    set_position_by_player_count( player_count )
    world:update(entities.player1, entities.player1.x, entities.player1.y); entities.player1.velocity:resetSpeed();
    world:update(entities.player2, entities.player2.x, entities.player2.y); entities.player2.velocity:resetSpeed();
    if entities.player3 ~= nil then world:update(entities.player3, entities.player3.x, entities.player3.y); entities.player3.velocity:resetSpeed(); end
    if entities.player4 ~= nil then world:update(entities.player4, entities.player4.x, entities.player4.y); entities.player4.velocity:resetSpeed(); end
end

function set_position_by_player_count( player_count ) -- TODO better random
    if 2 == player_count then
        if 1 == math.random(2) then
            x1 = gameboard.width * (1 / 3); y1 = gameboard.height * (1/2);
            x2 = gameboard.width * (2 / 3); y2 = gameboard.height * (1/2);
        else
            y1 = gameboard.height * (1 / 3); x1 = gameboard.width * (1/2);
            y2 = gameboard.height * (2 / 3); x2 = gameboard.width * (1/2);
        end
        if 1 == math.random(2) then
            entities.player1.x = x1; entities.player1.y = y1;
            entities.player2.x = x2; entities.player2.y = y2;
        else
            entities.player2.x = x1; entities.player2.y = y1;
            entities.player1.x = x2; entities.player1.y = y2;
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
            entities.player1.x = x1; entities.player1.y = y1;
            entities.player2.x = x2; entities.player2.y = y2;
            entities.player3.x = x3; entities.player3.y = y3;
        elseif 2 == rnd then
            entities.player2.x = x1; entities.player2.y = y1;
            entities.player3.x = x2; entities.player3.y = y2;
            entities.player1.x = x3; entities.player1.y = y3;
        else
            entities.player3.x = x1; entities.player3.y = y1;
            entities.player1.x = x2; entities.player1.y = y2;
            entities.player2.x = x3; entities.player2.y = y3;
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
            entities.player1.x = x1; entities.player1.y = y1;
            entities.player2.x = x2; entities.player2.y = y2;
            entities.player3.x = x3; entities.player3.y = y3;
            entities.player4.x = x4; entities.player4.y = y4;        
        elseif 2 == rnd then
            entities.player2.x = x1; entities.player2.y = y1;
            entities.player3.x = x2; entities.player3.y = y2;
            entities.player4.x = x3; entities.player4.y = y3;
            entities.player1.x = x4; entities.player1.y = y4;
        elseif 3 == rnd then
            entities.player3.x = x1; entities.player3.y = y1;
            entities.player4.x = x2; entities.player4.y = y2;
            entities.player1.x = x3; entities.player1.y = y3;
            entities.player2.x = x4; entities.player2.y = y4;
        elseif 4 == rnd then
            entities.player4.x = x1; entities.player4.y = y1;
            entities.player1.x = x2; entities.player1.y = y2;
            entities.player2.x = x3; entities.player2.y = y3;
            entities.player3.x = x4; entities.player3.y = y4;
        end
    end
end

function handle_collisions( player )
    local player, others = get_players_to_compare( player )
    for i = 1, #others do
        if check_collision(player, others[i]) then
            add_point(entities)
            reset_position(entities)
            count_down = 3
            swap_time = swap_time + 3
            update = countdown_update
            draw = countdown_draw
            return
        end
    end
end

function get_players_to_compare( player )
    local players = {}
    table.insert(players, entities.player1)
    table.insert(players, entities.player2)
    table.insert(players, entities.player3)
    table.insert(players, entities.player4)
    player = table.remove(players, player)
    return player, players
end