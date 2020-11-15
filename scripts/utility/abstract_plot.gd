extends Node

#	Copyright 2020  Dor "GodRabbit" Shlush
# This file is part of "Plasma Charge".
#
#    "Plasma Charge" is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    "Plasma Charge" is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with "Plasma Charge".  If not, see <https://www.gnu.org/licenses/>.
#
#	Copyright 2020  Dor "GodRabbit" Shlush

# A class to represnt a "plot" and a point within this "plot".
# a plot is  series of choices the player has to make, about weapon, sites to visit or
# [later badges...]

enum OPTIONS_TYPES{
	SITE,
	WEAPON,
	ENEMY,
	ENEMY_BASIC
}

var general_plot = [OPTIONS_TYPES.ENEMY_BASIC, OPTIONS_TYPES.WEAPON, 
OPTIONS_TYPES.SITE, OPTIONS_TYPES.ENEMY, OPTIONS_TYPES.ENEMY, OPTIONS_TYPES.ENEMY,
OPTIONS_TYPES.WEAPON]

var current_position = 0

var plot_ended = false

signal ended_plot

func _init():
	reset_plot()

func reset_plot():
	current_position = 0
	plot_ended = false

func to_next():
	current_position = current_position + 1
	if(current_position >= general_plot.size()):
		plot_ended = true
		emit_signal("ended_plot")

func get_current_event():
	if(current_position < general_plot.size()):
		return general_plot[current_position]
	else:
		return -1
	
