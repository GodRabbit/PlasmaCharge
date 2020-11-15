extends Node2D

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

# a screen for choosing between 2 options: site, weapon or badge.

# the class for choice button, for the options enum
onready var bchoice_class = preload("res://scripts/gui/choice_button.gd")

var type = bchoice_class.OPTIONS.WEAPON

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
