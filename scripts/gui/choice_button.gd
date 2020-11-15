extends TouchScreenButton

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

# represent a button in the choice screen. the button can have a general purpose,
# it may be a weapon, a site or a badge (when those will be implemented)
# the type variable determines the choice type

const weapon_image_path = "res://images/gui/types/%s_square.png"

enum OPTIONS{
	WEAPON,
	SITE,
	BADGE
}

var type = OPTIONS.WEAPON
var content = "abyss" # the type of the weapon or 

# Called when the node enters the scene tree for the first time.
func _ready():
	update_gui()

func set_button(btype, bcontent):
	type = btype
	content = bcontent

func update_gui():
	#TODO: make it look nicer.
	if type == OPTIONS.WEAPON:
		$choice_label.text = content + " weapon"
		$sprite.texture = load(weapon_image_path % content)
	elif type == OPTIONS.SITE:
		$choice_label.text = content
	else:
		$choice_label.text = "unknown"
