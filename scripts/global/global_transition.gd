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
onready var anim = get_node("anim")

# the path to transition to:
var path

func _ready():
	pass

func fade_to_combat():
	path = "res://scenes/combat_scene.tscn"
	anim.play("fade_to")

func fade_to_world():
	path = "res://scenes/overworld.tscn"
	anim.play("fade_to")

func fade_to_main_menu():
	path = "res://scenes/gui/main_menu.tscn"
	anim.play("fade_to")

# PRIVATE FUNCTION. CALLED AT THE MIDDLE OF THE TRANSITION ANIMATION
func change_scene():
	if path != "":
		get_tree().change_scene(path)
		get_tree().set_pause(false)
