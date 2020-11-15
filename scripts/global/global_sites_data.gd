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

# has 2 jobs: have the abstract data of all the sites you can get. Have the current plot
# advancement and the current visited sites

# the plot class
onready var abstract_plot = preload("res://scripts/utility/abstract_plot.gd")

var sites_list = {}

var current_plot

# ids of sites the player has already visited
var visited_sites = []

var current_site = "basic_enemy"
var next_enemy = "d_bug" #default

# Called when the node enters the scene tree for the first time.
func _ready():
	var file = File.new()
	file.open("res://data/sites_data.json", file.READ)
	var text = file.get_as_text()
	var res = JSON.parse(text) #parse text to dictionary
	sites_list = res.result #save the result
	file.close() #close file
	
	generate_new_plot()

func generate_new_plot():
	current_plot = abstract_plot.new()

func get_random_site_id(blacklist = []):
	# first create a new array with the un-blacklisted ids:
	var sites_ids = []
	for id in sites_list.keys():
		if(not id in blacklist): # as long as id is not in the black list
			sites_ids.append(id)
	
	# now pick a random id from the array:
	randomize()
	var index = randi() % sites_ids.size()
	var rand_key = sites_ids[index]
	return rand_key

func to_next():
	current_plot.to_next()
