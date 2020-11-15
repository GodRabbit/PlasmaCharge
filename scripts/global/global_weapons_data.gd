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

var weapons_list = {}

func _ready():
	var file = File.new()
	file.open("res://data/weapons_data.json", file.READ)
	var text = file.get_as_text()
	var res = JSON.parse(text) #parse text to dictionary
	weapons_list = res.result #save the result
	file.close() #close file

func get_random_weapons(amount, blacklist = []):
	var result = []
	
	var id_list = weapons_list.keys().duplicate()
	
	# remove exception from blacklist
	for e in blacklist:
		id_list.erase(e)
	
	# pick <amount> of the remaining from id_list
	for i in range(0, int(min(amount, id_list.size()))):
		randomize()
		var index = randi() % id_list.size()
		
		result.append(id_list[index])
		id_list.remove(index)
	
	return result

# after removing the blacklist of weapons ids, this function return all the types
# that are still avaliable to use as an array of strings.
# NOTE: pretty ineffecient.... there must be a way to make it quicker?
func get_types_left(blacklist = []):
	var result = []
	
	var id_list = weapons_list.keys().duplicate()
	
	# remove exception from blacklist
	for e in blacklist:
		id_list.erase(e)
	
	# get all the types in an array, without repetition
	for id in id_list:
		var type = weapons_list[id]["dmg_type"]
		if !(type in result): # if the type not included yet, then:
			result.append(type) # add the type
	
	return result

# returns an id of a weapon of the required type. the weapon is chosen at random:
# return -1 in case of not founding a weapon of this type.
func get_random_weapon_by_type(type):
	var result = []
	
	# gets a copy of the list of weapon ids :
	var id_list = weapons_list.keys().duplicate()
	
	# loop through the id list and pick only the ids the are 
	# weapons of the specified type, and enter it into 'result':
	for id in id_list:
		# get the type of the current id in the loop:
		var id_type = weapons_list[id]["dmg_type"]
		
		# type match?
		if id_type != type:
			result.append(id)
	
	# is result empty? return -1:
	if result.size() <= 0:
		return -1
	
	# now choose a random element from result:
	# pick an index
	randomize()
	var index = randi() % result.size()
	
	# return the value
	return result[index]
