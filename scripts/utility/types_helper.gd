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

# type system is deprecated in this version
# hence this entire class is now obsolete

const INFERNO = "inferno" # deprecated
const DEPTHS = "depths" # deprecated
const GLACIER = "glacier" # deprecated
const ABYSS = "abyss" # deprecated
const DOOM = "doom" # deprecated
const DESIRE = "desire" # deprecated


const strengths = {"inferno": [GLACIER, ABYSS], "depths":[DEPTHS, INFERNO], 
"glacier":[DEPTHS, DESIRE], "abyss":[DOOM, GLACIER], "doom":[DESIRE, DEPTHS], "desire":[DOOM, ABYSS]}

const weaknesses = {"inferno": [INFERNO, DEPTHS], "depths":[DEPTHS, DOOM], 
"glacier":[GLACIER, ABYSS, INFERNO], "abyss":[ABYSS, DESIRE, INFERNO], 
"doom":[DOOM, DESIRE, ABYSS], "desire":[DESIRE, DOOM, GLACIER]}

func _ready():
	pass

func get_modifier_against(attacking_type : String, defending_types: Array) -> float:
	if(attacking_type == "true"):
		return 1.0
	var mod = 1.0
	# we search in the attacking strengths, if the defending types
	# are in there, we multiply by 1.15 the mod.
	# e.g. attacking inferno -> [inferno, depths], will return a 1.0 modifier [for strengths]
	# but inferno -> [glacier], will return 1.15
	# and inferno -> [glacier, abyss], will return 1.15*1.15 = 1.3225
	for type in strengths[attacking_type]:
		if(defending_types.has(type)):
			mod = mod*1.15
	for type in defending_types:
		if(weaknesses[attacking_type].has(type)):
			mod = mod*0.869
	return mod

#returns a number between -2 to 2, which signifies type effectiveness
# -2 - weak against two types
# -1 weak against 1 type
# 0 neutral
# 1 effective against 1 type
# 2 effective against 2 types
func get_modifier_index(attacking_type, defending_types):
	if(attacking_type == "true"):
		return 0
	var mod = 0
	# we search in the attacking strengths, if the defending types
	# are in there, we multiply by 1.15 the mod.
	# e.g. attacking inferno -> [inferno, depths], will return a 1.0 modifier [for strengths]
	# but inferno -> [glacier], will return 1.15
	# and inferno -> [glacier, abyss], will return 1.15*1.15 = 1.3225
	for type in strengths[attacking_type]:
		if(defending_types.has(type)):
			mod = mod + 1
	for type in defending_types:
		if(weaknesses[attacking_type].has(type)):
			mod = mod - 1
	return mod

func get_random_types():
	var type_list = [INFERNO, DEPTHS, GLACIER, ABYSS, DOOM, DESIRE]
	randomize()
	var num = randi()%2
	if(num == 0): #only 1 type
		var index = randi() % type_list.size()
		return [type_list[index]]
	else: # 2 types
		var result = []
		var index = randi() % type_list.size()
		
		result.append(type_list[index])
		type_list.remove(index)
		
		randomize()
		index = randi() % type_list.size()
		result.append(type_list[index])
		
		return result

func debug_f():
	return 8.0
