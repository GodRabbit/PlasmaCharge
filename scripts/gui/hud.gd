extends CanvasLayer

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
onready var charge_bar = get_node("charge_bar")
onready var hp_bar = get_node("hp_bar")
onready var exp_bar = get_node("exp_bar")
onready var lvl_label = get_node("charge_bar/labels_vbox/lvl_label")
onready var weapon_manager = get_node("weapon_manager")
onready var charge_label = get_node("charge_bar/labels_vbox/charge_label")

func _ready():
	update_gui()
	
	# connect_signals
	global_data.get_node("global_player_data").connect("health_changed", self, "update_health_bar")
	global_data.get_node("global_player_data").connect("charge_changed", self, "update_charge_bar")
	global_data.get_node("global_player_data").connect("exp_changed", self, "update_exp_bar")
	
	$button_close.connect("pressed", self, "on_close_button_pressed")

func update_gui():
	update_charge_bar()
	update_health_bar()
	update_exp_bar()

func update_charge_bar():
	charge_bar.value = global_data.get_node("global_player_data").get_current_charge()
	charge_label.text = "%d%%" % global_data.get_node("global_player_data").get_current_charge()

func update_health_bar():
	hp_bar.value = global_data.get_node("global_player_data").get_health_percent()

func update_exp_bar():
	exp_bar.value = global_data.get_node("global_player_data").get_exp_percent()
	lvl_label.set_text("LVL. %01d" % global_data.get_node("global_player_data").get_level())

# go to main menu
func on_close_button_pressed():
	global_transition.fade_to_main_menu()
