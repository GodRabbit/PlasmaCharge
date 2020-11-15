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

#classes:
var weapon_class = preload("res://scripts/utility/weapon_class.gd")

#nodes:
onready var movement_sensor = get_node("movement_sensor")

#to get from level n to level n+1, you need EXP_LEVELS[n] experience
const EXP_LEVELS = [100, 200, 500, 500, 600, 600, 700, 800, 800, 900, 950, 1000]

const DIFFICULTY_VERY_EASY = 3.0 # 1 step -> 3% charge
const DIFFICULTY_EASY = 2.0 # 1 step -> 2% charge
const DIFFICULTY_NORMAL = 1.0 # 1 step -> 1% charge
const DIFFICULTY_HARD = 0.5 # 1 step -> 0.5% charge
const DIFFICULTY_VERY_HARD = 0.2 # 1 step -> 0.2% charge

var current_difficulty = DIFFICULTY_EASY

var personal_modifiers = {"dmg":2, "hp":2, "def":2}


#var max_health = 100.0
var current_health

const max_charge = 100.0 #can't be changed, charge is by percents anyway
var current_charge = max_charge

var level = 0
var current_exp = 0

var base_health = 75
var base_dmg = 55
var base_def = 45

# an array of weapon_class objects
var player_weapons = []
var current_weapon_index = 0

# signals:
signal player_death
signal health_changed #not necesrily changed, but at least updated
signal charge_changed
signal exp_changed


func _ready():
	movement_sensor.connect("steps_updated", self, "on_step_made")
	
	if(player_weapons.size() == 0): # first run, set player; only relevant in testing
		create_random_personal_modifiers()
		add_weapon_by_id("plasma_beam")
		current_health = get_max_health()
		current_charge = max_charge

func create_random_personal_modifiers():
	randomize()
	var dmg = rand_range(0, 30)
	var hp = rand_range(0, 30)
	var def = rand_range(0, 30)
	personal_modifiers = {"dmg":dmg, "hp":hp, "def":def}

func set_new_player():
	create_random_personal_modifiers()
	current_health = get_max_health()
	current_charge = max_charge
	
	player_weapons = []
	
	add_weapon_by_id("plasma_beam")
	var random_weapons_ids = global_weapons_data.get_random_weapons(3, ["plasma_beam"])
	for r in random_weapons_ids:
		add_weapon_by_id(r)

# returns a duplicate!
func get_weapons_list():
	return player_weapons.duplicate()

func get_current_weapon_index():
	return current_weapon_index

func select_next_weapon():
	var size = player_weapons.size()
	current_weapon_index = (current_weapon_index + 1) % size

func select_previous_weapon():
	var size = player_weapons.size()
	current_weapon_index = (current_weapon_index + size - 1) % size

func add_exp(value):
	if(level >= EXP_LEVELS.size()): #level is maxed
		return
	# if there's enough exp to level up
	if(current_exp + value >= EXP_LEVELS[level]):
		level = level + 1
		current_exp = current_exp + value - EXP_LEVELS[level - 1]
	else:
		current_exp = current_exp + value
	emit_signal("exp_changed")

func get_exp_percent():
	return (float(current_exp)/float(EXP_LEVELS[get_level()]))*100.0

func add_exp_to_weapon(index, amount):
	player_weapons[index].add_exp(amount)

func get_max_health():
	var res = 0
	res = ((base_health+personal_modifiers["hp"])*2.0)*(level+1.0)/100.0 + 20.0
	return res

func set_health(value):
	if(value > get_max_health()):
		current_health = get_max_health()
	elif(value < 0.0):
		current_health = 0.0
		emit_signal("health_changed")
		emit_signal("player_death")
		return
	else:
		current_health = value
	emit_signal("health_changed")

func add_health(value):
	set_health(current_health + value)

# p is percentage of health to add.
# example: p = 10 wil heal the player for 10 percent of the total health.
# of course p being negative will hurt the player.
func add_health_percent(p):
	var h = (p/100.0)*get_max_health()
	add_health(h)

func get_current_health():
	return current_health

func get_health_percent():
	return (get_current_health()/get_max_health())*100.0

func get_defence():
	var res = (base_def + personal_modifiers["def"])*(level+1.0)/50.0+20.0
	return res

func damage_player(attack_damage, enemy_damage, enemy_level):
	var true_hp = (0.4*(enemy_level + 1.0) + 2.0)*attack_damage*(enemy_damage/get_defence())/50.0 + 1.0
	add_health(-true_hp)

# value can be negative. but must be between -100 - 100, because it
# represents percents!
func add_charge(value):
	if(current_charge + value > max_charge):
		current_charge = max_charge
	elif(current_charge + value < 0.0):
		current_charge = 0.0
	else:
		current_charge = current_charge + value
	emit_signal("charge_changed")

func fully_fill_charge():
	add_charge(200.0)

func get_current_charge():
	return current_charge

func get_damage():
	var res = (base_dmg + personal_modifiers["dmg"])*(level+1.0)/50.0 + 10.0
	return res

func get_level():
	return level

# when the player takes a step
func on_step_made():
	if(current_charge != max_charge):
		var added_charge = current_difficulty
		add_charge(added_charge)
		emit_signal("charge_changed")

# try to add a new weapon to the weapon list.
# returns false if not scceeded true eitherway
func add_weapon(weapon):
	for w in player_weapons:
		if(w.is_equal(weapon)):
			return false
	player_weapons.append(weapon)
	return true

func add_weapon_by_id(weapon_id):
	return add_weapon(weapon_class.new(weapon_id))
