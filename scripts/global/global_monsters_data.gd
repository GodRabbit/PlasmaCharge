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

var monsters_data = {}

func _ready():
	var file = File.new()
	file.open("res://data/monsters_data.json", file.READ)
	var text = file.get_as_text()
	var res = JSON.parse(text) #parse text to dictionary
	monsters_data = res.result #save the result
	file.close() #close file

func get_random_monster():
	randomize()
	var index = randi() % monsters_data.keys().size()
	var rand_key = monsters_data.keys()[index]
	
	return monsters_data[rand_key]

func get_random_monster_id():
	randomize()
	var index = randi() % monsters_data.keys().size()
	var rand_key = monsters_data.keys()[index]
	return rand_key

func get_enemy_dictionary(enemy_id):
	monsters_data[enemy_id]
