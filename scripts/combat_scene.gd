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

# nodes:
onready var text_buffer = get_node("text_buffer")
onready var hud = get_node("hud")
onready var enemy = get_node("enemy_general")
onready var global_player_data = global_data.get_node("global_player_data")
onready var fight_over_button = get_node("fight_over_button")
onready var game_over_button = get_node("game_over_button")
onready var anim = get_node("anim")

var fight_paused = false

func _ready():
	set_process_input(true)
	
	hud.weapon_manager.connect("weapon_used", self, "on_weapon_used")
	enemy.current_enemy.connect("enemy_death", self, "on_enemy_death")
	enemy.connect("death_anim_over", self, "on_enemy_death_animation_over")
	fight_over_button.connect("pressed", self, "on_fight_over_pressed")
	game_over_button.connect("pressed", self, "on_game_over_pressed")
	enemy.connect("enemy_attacked", self, "on_enemy_attack")
	global_player_data.connect("player_death", self, "on_player_death")
	# test the buffer:
	#text_buffer.set_lines(["Down, down, down. Would the fall never come to an end! ‘I wonder how many miles I’ve fallen by this time?’ she said aloud. ‘I must be getting somewhere near the centre of the earth. Let me see: that would be four thousand miles down, I think"])

func _input(event):
	if(event.is_action_pressed("ui_accept") && fight_over_button.is_visible_in_tree()):
		on_fight_over_pressed()
	if(event.is_action_pressed("ui_accept") && game_over_button.is_visible_in_tree()):
		on_game_over_pressed()
	if(event.is_action_released("ui_control")): # debug in computer: adds charge to full
		global_player_data.fully_fill_charge()

func on_weapon_used(weapon):
	if(fight_paused):
		return
	# does the player has enough charge to use this weapon:
	var weapon_cost = weapon.get_current_charge_cost()
	if(global_player_data.get_current_charge() < weapon_cost):
		return
	
	# get weapon data
	var weapon_power = weapon.roll_current_damage()
	var weapon_type = weapon.get_damage_type()
	var dmg_result = enemy.current_enemy.damage_enemy(weapon_power, weapon_type, global_player_data.get_damage(), global_player_data.get_level())
	
	# reduce charge from player:
	global_player_data.add_charge(-weapon_cost)
	
	# animate enemy based on dmg_effect
	if(weapon_type == "true"):
		enemy.damage_enemy(dmg_result["dmg"], dmg_result["dmg_index"], true)
	else:
		enemy.damage_enemy(dmg_result["dmg"], dmg_result["dmg_index"], false)

func on_enemy_death():
	fight_paused = true
	
	var xp = 30 # temporary value, just for testing
	
	global_player_data.add_exp(xp)
	global_player_data.add_exp_to_weapon(hud.weapon_manager.get_selected_weapon(), xp)
	hud.weapon_manager.update_gui()
	# death animation will start automatically

func on_enemy_death_animation_over():
	fight_over_button.show()

func on_fight_over_pressed():
	# transition to overworld
	global_transition.fade_to_world()

func on_enemy_attack():
	if(fight_paused):
		return
	var attack_damage = 5
	var enemy_damage = enemy.current_enemy.get_damage()
	var enemy_level = enemy.current_enemy.get_level()
	global_player_data.damage_player(attack_damage, enemy_damage, enemy_level)
	anim.play("shake1", -1, 2.0)

func on_player_death():
	fight_paused = true
	game_over_button.show()

func on_game_over_pressed():
	global_transition.fade_to_main_menu()
