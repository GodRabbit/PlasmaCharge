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

#onready var types_helper = preload("res://scripts/utility/types_helper.gd").new()
onready var global_monsters_data = global_data.get_node("global_monsters_data")

export var enemy_types = []

var current_health

export var level = 0
var base_health = 45
var base_dmg = 45
var base_def = 45
var atk_speed = 3.0 #in seconds
var is_dead = false
var enemy_name = "spirit"
var enemy_id = "spirit"

var weaknesses = {}
var resistances = {}

signal health_changed
signal enemy_death

func _ready():
	current_health = get_max_health()

func init_data_from_dictionary(dic):
	base_health = dic["hp"]
	base_dmg = dic["dmg"]
	base_def = dic["def"]
	atk_speed = dic["atk_spd"]
	enemy_name = dic["name"]
	enemy_id = dic["id"]
	#enemy_types = dic["types"] # deprecated
	weaknesses = dic["weaknesses"]
	resistances = dic["resistances"]

#note that this func argument is an enemy dictionary and not id!!
func _init(enemy_dic, lvl):
	#types_helper = preload("res://scripts/utility/types_helper.gd").new()
	level = lvl
	
	#get the enemy_dictionary from the global data:
	init_data_from_dictionary(enemy_dic)
	current_health = get_max_health()

func init_random_enemy(lvl):
	level = lvl
	current_health = get_max_health()
	#enemy_types = types_helper.get_random_types()

func get_id():
	return enemy_id

func get_level():
	return level

func get_max_health():
	var res = ((base_health + 16.0)*2.0)*(level+1.0)/100.0 + 20.0
	return res

func set_health(value):
	if(value > get_max_health()):
		current_health = get_max_health()
	elif(value <= 0.0):
		current_health = 0.0
		is_dead = true
		emit_signal("enemy_death")
	else:
		current_health = value
	emit_signal("health_changed")

func add_health(value):
	set_health(current_health + value)

func get_current_health():
	return current_health

func get_health_percent():
	return (get_current_health()/get_max_health())*100.0

func is_dead():
	return is_dead

func get_defence():
	var res = (base_def + 16.0)*(level + 1.0)/50.0 + 5.0
	return res

func get_types():
	return enemy_types.duplicate()

func get_damage():
	var res = (base_dmg + 16.0)*(level+1.0)/50.0 + 1.0
	return res

func get_attack_speed():
	return atk_speed

func get_weaknesses_dic():
	return weaknesses

func get_resistances_dic():
	return resistances

#returns a number between -2 to 2, which signifies type effectiveness
# -2 relevant resistance is > 20
# -1 relevant resistance is <= 20
# 0 neutral (no resistance or weakness)
# 1 weakness <= 20
# 2 weakness > 20
#together with the damage done in a dictionary of the form {"dmg":<number of true dmg done>, "dmg_index":<the index
# as explained above"}
func damage_enemy(weapon_power, weapon_type, player_damage, player_level):
	#types_helper = load("res://scripts/utility/types_helper.gd").new()
	var true_hp = 0.0
	if(weapon_type == "true"):
		true_hp = weapon_power
	else:
		true_hp = (0.4*(player_level + 1.0) + 2.0)*weapon_power*(player_damage/get_defence())/25.0 + 2.0
	
	# calculate resistances and weakneses into formula:
	var type_mod = 100
	if(weaknesses.has(weapon_type)):
		type_mod += weaknesses[weapon_type]
	if(resistances.has(weapon_type)):
		type_mod -= resistances[weapon_type]
	
	# calculate dmg index:
	var dmg_index = 0
	if(type_mod > 120.0):
		dmg_index = 2
	elif(type_mod <= 120.0 && type_mod > 100.0):
		dmg_index = 1
	elif(type_mod < 100 && type_mod >= 80):
		dmg_index = -1
	elif(type_mod < 80):
		dmg_index = -2
	else:
		dmg_index = 0
		
	true_hp = true_hp * (type_mod/100.0)
	add_health(-true_hp)

	return {"dmg":-true_hp, "dmg_index":dmg_index}
