require "Entities"
require "Helper_Functions"
require "Score"
require "Gameloops"
bump = require 'bump/bump'

LUA_INDEX_OFFSET = 1


function love.focus(focus)
	in_focus = focus
end

function love.load(args)
	gameboard =  {
		width = 1280,
		height = 720
	}
    player_colors = {}
	table.insert(player_colors, { R = 255, G = 0, B = 0})
	table.insert(player_colors, { R = 0, G = 255, B = 0})
	table.insert(player_colors, { R = 0, G = 0, B = 255})
	table.insert(player_colors, { R = 255, G = 255, B = 0})
	player_locations = {}
	table.insert(player_locations, { x = gameboard.width * (1/3), y = gameboard.height * (1 / 4) })
	table.insert(player_locations, { x = gameboard.width * (2/3), y = gameboard.height * (3 / 4) })
	table.insert(player_locations, { x = gameboard.width * (1/3), y = gameboard.height * (3 / 4) })
	table.insert(player_locations, { x = gameboard.width * (2/3), y = gameboard.height * (1 / 4) })
	catch_sound = love.audio.newSource("Assets/Sound/Sofa5.ogg")
	skull_image = love.graphics.newImage( "Assets/Images/placeholderskull.png" )
	game_time = 120
	in_focus = false
	update = menu_update
	draw = menu_draw
	menu_index = 0
	menu_options = 2
	next_menu_change = love.timer.getTime()
	options_x_start = gameboard.width / 2 - 100
	options_x = options_x_start
	options_y_start = 300
	horisontal_draw_scale = 1
	vertical_draw_scale = 1
	love.window.setMode( gameboard.width, gameboard.height, { resizable = true, fullscreen = false } )
	player_count = 0
end

function love.update(delta_time)
	check_exit()
	update(delta_time)
end

function love.draw()
	love.graphics.scale(horisontal_draw_scale, vertical_draw_scale)
	draw()
end

function love.resize(width, height)
	horisontal_draw_scale = width / gameboard.width
	vertical_draw_scale = height / gameboard.height
end
