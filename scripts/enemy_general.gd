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

var enemy_class = load("res://scripts/utility/enemy_class.gd")
var type_gui_class = load("res://scenes/gui/type_gui.tscn")

# nodes:
onready var global_monsters_data = global_data.get_node("global_monsters_data")
onready var monster_sprite = get_node("sprite")
onready var type_container = get_node("type_container")
onready var texture_type0 = get_node("type_container/type0")
onready var texture_type1 = get_node("type_container/type1")
onready var weaknesses_box = get_node("weak_resist_box/weaknesses_box")
onready var resistances_box = get_node("weak_resist_box/resistances_box")
onready var hp_bar = get_node("hp_bar")
onready var attack_timer = get_node("attack_timer")
onready var dmg_label = get_node("damage_indicator/dmg_label")
onready var anim = get_node("anim")
onready var innerid_label = get_node("innerid_label")

var current_enemy

var fight_paused = false

signal enemy_attacked
signal death_anim_over

func _ready():
	current_enemy = enemy_class.new(global_monsters_data.get_random_monster(), 4)
	current_enemy.connect("health_changed", self, "update_hp_bar")
	
	attack_timer.wait_time = current_enemy.get_attack_speed()
	attack_timer.connect("timeout", self, "attack")
	
	#update sprites:
	monster_sprite.set_texture(load("res://images/enemies/"+current_enemy.get_id()+".png"))
	
	update_gui()

func get_current_enemy():
	return current_enemy

func set_enemy(enemy):
	current_enemy = enemy
	update_gui()

func _clear_weak_and_resist_types():
	# clear weaknesses first:
	for c in weaknesses_box.get_children():
		if(c.is_in_group("type_gui")):
			weaknesses_box.remove_child(c)
			c.queue_free()
	for c in resistances_box.get_children():
		if(c.is_in_group("type_gui")):
			resistances_box.remove_child(c)
			c.queue_free()

func update_gui():
	# update types: # types are deprecated
#	var types = current_enemy.get_types()
#	if(types.size() == 1):
#		texture_type0.texture = load("res://images/gui/types/"+types[0]+"_type.png")
#		texture_type1.hide()
#	else:
#		texture_type0.texture = load("res://images/gui/types/"+types[0]+"_type.png")
#		texture_type1.texture = load("res://images/gui/types/"+types[1]+"_type.png")
	
	# update weaknesses and resistances:
	_clear_weak_and_resist_types()
	
	var ws = current_enemy.get_weaknesses_dic() # weaknesses dictionary 
	for w in ws.keys():
		var tg = type_gui_class.instance()
		tg.set_type(w)
		tg.set_value(ws[w])
		weaknesses_box.add_child(tg)
	
	var rs = current_enemy.get_resistances_dic() # resistances dictionary 
	for r in rs.keys():
		var tg = type_gui_class.instance()
		tg.set_type(r)
		tg.set_value(rs[r])
		resistances_box.add_child(tg)
	
	innerid_label.text = current_enemy.get_innerid()
	
	# update hp_bar:
	update_hp_bar()

func update_hp_bar():
	hp_bar.value = current_enemy.get_health_percent()

func reset_attack_timer():
	attack_timer.stop()
	attack_timer.start()

func attack():
	if(fight_paused):
		return
	anim.play("attack")
	emit_signal("enemy_attacked")

func damage_enemy(dmg_done, dmg_index, is_true = false):
	var dmg_format = "%.1f"
	dmg_label.set_text(dmg_format % dmg_done)
	
	var color
	var font_size
	match dmg_index:
		2:
			color = Color("#871414") # deep red, a lot of damage
			font_size = 40
		1:
			color = Color("#e8631b") # orange, bit more of damage
			font_size = 30
		0:
			color = Color("#fcf349") # yellowish white
			font_size = 20
		-1:
			color = Color("#3a4b51") # blueish gray
			font_size = 15
		-2:
			color = Color("#21363d") # dark blue with low sat
			font_size = 10
	if(is_true):
		color = Color("#4e0b68") # darkish purple
		font_size = 20
	
	dmg_label.get("custom_fonts/font").set_size(font_size)
	dmg_label.set("custom_colors/font_color", color)
	if(current_enemy.is_dead()):
		anim.stop()
		anim.play("idle")
		anim.play("hurt")
		anim.queue("death")
		fight_paused = true
	else:
		anim.stop()
		anim.play("idle")
		anim.play("hurt")
		reset_attack_timer()


# called when death animation stopped [duh...]
func on_death_animation_stopped():
	emit_signal("death_anim_over")

func hurt_anim_over():
	pass
