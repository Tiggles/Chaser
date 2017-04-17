require "Entities"
require "Helper_Functions"
require "Score"
require "gameloops"
bump = require 'bump/bump'

LUA_INDEX_OFFSET = 1


function love.focus(focus)
	in_focus = focus
end

function love.load(args)
	options_x_start = 300
	options_x = options_x_start
	options_y_start = 200
	in_focus = false
	update = menu_update
	draw = menu_draw
	menu_index = 0
	menu_options = 2
	next_menu_change = love.timer.getTime()
	gameboard =  {
		width = 800,
		height = 600
	}
end

function love.update(delta_time)
	check_exit()
	update(delta_time)
end

function love.draw()
	draw()
end