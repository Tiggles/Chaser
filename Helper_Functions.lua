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
    world:update(entities.player1, entities.player1.x, entities.player1.y)
    world:update(entities.player2, entities.player2.x, entities.player2.y)
    if entities.player3 ~= nil then world:update(entities.player3, entities.player3.x, entities.player3.y) end
    if entities.player4 ~= nil then world:update(entities.player4, entities.player4.x, entities.player4.y) end
end

function set_position_by_player_count( player_count )
    if 2 == player_count then
        if math.random(2) then

        end
    elseif 3 == player_count then

    else 

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