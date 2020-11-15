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

# This is the gui for a single type weakness or resistance.
# if you're confused about its name, so do I. Not the best name for this node, but
# life isn't perfect and I'm tired and dumb.


const path_format = "res://images/gui/types/%s.png"
const percentage_format = "%d%%"

var stat_name = "frost"
var value = 25 # in percentage

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("type_gui") # a unique group for this kind of gui.
	pass # Replace with function body.

func set_type(s):
	stat_name = s
	update_gui()

func set_value(v):
	value = v
	update_gui()

func is_resource_exist(type_name):
	#var file2check = File.new()
	return ResourceLoader.exists(path_format % type_name)

func update_gui():
	if(is_resource_exist(stat_name)):
		$type_cover.texture = load(path_format % stat_name)
		$type_cover/percentage_label.text = percentage_format % value
	else:
		$type_cover.texture = load(path_format % "none")
		$type_cover/percentage_label.text = ""
	
