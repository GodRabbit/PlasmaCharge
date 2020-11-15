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

# to get form level n to level n+1 you need EXP_LEVELS[n] experience
const EXP_LEVELS = [100, 300]

const max_level = 2

var weapon_archtype = {} # get this from global weapons data

var current_level = 0
var current_exp = 0

func _init(weapon_id = "plasma_charge", level = 0, curr_exp = 0):
	var weapons_list = global_weapons_data.weapons_list
	
	if(weapons_list.has(weapon_id)):
		weapon_archtype = weapons_list[weapon_id]
	else:
		weapon_archtype = weapons_list["plasma_beam"] #default, in case of error
	current_level = level
	current_exp = curr_exp

func get_weapon_name():
	return weapon_archtype["name"]

func get_weapon_id():
	return weapon_archtype["id"]

func add_exp(value):
	if(current_level >= max_level): # level is maxed
		return
	# if there's enough exp to level up
	if(current_exp + value >= EXP_LEVELS[current_level]):
		current_level = current_level + 1
		current_exp = current_exp + value - EXP_LEVELS[current_level - 1]
	else:
		current_exp = current_exp + value

func get_exp():
	return current_exp

func get_exp_percent():
	return (float(current_exp)/float(EXP_LEVELS[current_level]))*100.0

func get_level():
	return current_level

func get_current_damage_range():
	var dmg_range =  weapon_archtype["dmg"][current_level]
	return dmg_range

# if the damage of the current level is a range, e.g. [3, 5],
# then return a random number in this range. otherwise, return the damage value
func roll_current_damage():
	var dmg_range =  weapon_archtype["dmg"][current_level]
	if(dmg_range[0] == dmg_range[1]):
		return dmg_range[0]
	else:
		randomize()
		return rand_range(dmg_range[0], dmg_range[1])

func get_current_charge_cost():
	var cost = weapon_archtype["cost"][current_level]
	return cost

func get_damage_type():
	return weapon_archtype["dmg_type"]

# read only, the returning dictionary is only a copy
func get_weapon_archtype():
	return weapon_archtype.duplicate()

# checks if the weapon <weapon> equals this weapon
func is_equal(weapon):
	var id = weapon.get_weapon_archtype()["id"]
	if(id == weapon_archtype["id"]):
		return true
	else:
		return false
