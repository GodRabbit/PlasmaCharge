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
onready var fight_next_button = get_node("fight_next_button")
onready var heal_button = get_node("heal_button")
onready var global_player_data = global_data.get_node("global_player_data")

func _ready():
	fight_next_button.connect("pressed", self, "on_fight_next_pressed")
	heal_button.connect("pressed", self, "on_heal_button_pressed")

func on_fight_next_pressed():
	global_transition.fade_to_combat()

func on_heal_button_pressed():
	# Heal 10% health for 10% charge:
	if(global_player_data.get_current_charge() >= 10 && global_player_data.get_health_percent() != 100):
		global_player_data.add_health_percent(10)
		global_player_data.add_charge(-10)
	
	# DEPRECATED:
#	# heal for the missing percent with the respective charge
#	# a.k.a if you are missing 15% health, you'll heal it for 15% charge
#	var heal = 100.0 - global_player_data.get_health_percent()
#	if(global_player_data.get_current_charge() >= heal): 
#		global_player_data.add_health(500000)
#		global_player_data.add_charge(-heal)
