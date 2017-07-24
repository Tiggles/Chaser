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
    entities.player1:swap_chaser()
    entities.player2:swap_chaser()
end

function add_point()
    entities.player1:add_point(1)
    entities.player2:add_point(2)
end

function check_exit()
    if love.keyboard.isDown("escape") then love.event.quit() end
end

function reset_position(entities)
    val = math.random(2);
    if 1 == val then
        entities.player2.x = gameboard.width * (1/3); entities.player2.y = gameboard.height * (1/2);
        entities.player1.x = gameboard.width * (2/3); entities.player1.y = gameboard.height * (1/2);
    else
        entities.player1.x = gameboard.width * (1/3); entities.player1.y = gameboard.height * (1/2);
        entities.player2.x = gameboard.width * (2/3); entities.player2.y = gameboard.height * (1/2);
    end
    world:update(entities.player1, entities.player1.x, entities.player1.y)
    world:update(entities.player2, entities.player2.x, entities.player2.y)
end