extends Control

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

#global nodes:
var player_data = global_data.get_node("global_player_data")

# consts:
onready var weapon_type_img_path = "res://images/gui/weapon_types/%s_weapon.png"
# nodes:
onready var weapon_button = get_node("weapon_button_container/weapon_button") # fire button more or less
onready var test_button = get_node("weapon_button_container/weapon_button/test_button")
onready var label_weapon_name = get_node("weapon_button_container/label_containers/label_weapon_name")
onready var label_weapon_level = get_node("weapon_button_container/label_containers/level_container/label_weapon_level")
onready var weapon_exp_bar = get_node("weapon_button_container/label_containers/level_container/weapon_exp_bar")
onready var label_weapon_damage = get_node("weapon_button_container/label_containers/label_weapon_damage")
onready var label_weapon_cost = get_node("weapon_button_container/label_containers/label_weapon_cost")
onready var next_button = get_node("next_button_container/next_button")
onready var back_button = get_node("back_button_container/back_button")
onready var atk_speed_timer = get_node("atk_speed_timer")

export var atk_speed = 1.5 # in seconds
var is_on_cooldown = false # attack speed cooldown. you can only attack after at least 1.5 seconds after your previous attack

#var weapon_list = [] # no need for it, use global player data
#var current_weapon_index = 0 # no need for it, use global player data

#signals:
signal weapon_used(weapon)

func _ready():
	atk_speed_timer.wait_time = atk_speed
	set_process_input(true)
	
	# signals:
	atk_speed_timer.connect("timeout", self, "on_atk_speed_timeout")
	next_button.connect("pressed", self, "on_next_button_pressed")
	back_button.connect("pressed", self, "on_back_button_presed")
	weapon_button.connect("pressed", self, "on_weapon_button_pressed")
	test_button.connect("pressed", self, "on_weapon_button_pressed") # used to test on computer
	
	update_gui()

func _input(event):
	if(event.is_action_pressed("ui_accept")):
		on_weapon_button_pressed()
	elif(event.is_action_pressed("ui_right")):
		on_next_button_pressed()
	elif(event.is_action_pressed("ui_left")):
		on_back_button_presed()

func update_gui():
	var weapon_list = global_data.get_node("global_player_data").get_weapons_list()
	var weapon = weapon_list[player_data.get_current_weapon_index()] # instance of weapon_class
	
	var dmg_range = weapon.get_current_damage_range()
	var dmg_type = weapon.get_damage_type()
	var cost = weapon.get_current_charge_cost()
	
	var dmg_format_range = "Deals %d - %d %s Damage"
	var dmg_format_const = "Deals %d %s Damage"
	var cost_format = "Costs %d%% Charge"
	
	# updates labels:
	label_weapon_name.set_text(weapon.get_weapon_name() )
	label_weapon_level.set_text("lvl. "+str(weapon.get_level()))
	weapon_exp_bar.value = weapon.get_exp_percent()
	
	if(dmg_range[0] != dmg_range[1]):
		label_weapon_damage.set_text(dmg_format_range % [dmg_range[0], dmg_range[1], dmg_type])
	else:
		label_weapon_damage.set_text(dmg_format_const % [dmg_range[0], dmg_type])
	
	if(dmg_type == "true"): # true dmg is puerple!! because!
		label_weapon_damage.set("custom_colors/font_color", Color("#4e0b68")) # durkish purple
	else:
		label_weapon_damage.set("custom_colors/font_color", Color("#ffffff"))
	label_weapon_cost.set_text(cost_format % cost)
	
	# set the gui ckack color to the corresponding image:
	var t = load(weapon_type_img_path % dmg_type)
	$weapon_button_container/weapon_displayer_back.texture = t

func get_selected_weapon():
	return player_data.get_current_weapon_index()

func on_atk_speed_timeout():
	is_on_cooldown = false

func on_next_button_pressed():
	player_data.select_next_weapon()
	update_gui()

func on_back_button_presed():
	player_data.select_previous_weapon()
	update_gui()

func on_weapon_button_pressed():
	var weapon_list = global_data.get_node("global_player_data").get_weapons_list()
	var weapon = weapon_list[player_data.get_current_weapon_index()] # instance of weapon_class
	
	emit_signal("weapon_used", weapon)
	
	is_on_cooldown = true # start  attack cooldown
	atk_speed_timer.start()
