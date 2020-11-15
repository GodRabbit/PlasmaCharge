extends Node2D

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

# nodes:
onready var new_game_button = get_node("new_game_button")
onready var exit_button = get_node("exit_button")

func _ready():
	set_process_input(true)
	
	# signals:
	new_game_button.connect("pressed", self, "start_new_game")
	exit_button.connect("pressed", self, "on_exit_button_pressed")
	
	# update labels:
	$version_label.text = "version "+global_data.get_node("program_data").game_version

func _input(event):
	if(event.is_action_pressed("ui_accept")):
		start_new_game()

func start_new_game():
	global_data.get_node("global_player_data").set_new_player()
	global_transition.fade_to_world()

# needs to be changed to auto save?
func on_exit_button_pressed():
	get_tree().quit()
