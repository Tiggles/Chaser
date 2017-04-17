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

function init_random_map(world)

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
    entities.player1.x = 200; entities.player1.y = 200;
    entities.player2.x = 400; entities.player2.y = 400;
end