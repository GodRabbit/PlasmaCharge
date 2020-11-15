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

#nodes:
onready var motion_sensor = get_node("movement_sensor")
onready var button_increase = get_node("button_increase")
onready var button_decrease = get_node("button_decrease")
onready var button_reset = get_node("button_reset")

onready var label_test = get_node("test/label_test")
onready var label_accer_test = get_node("test/label_acce_test")
onready var label_acce_str = get_node("test/label_accel_strngth")
onready var label_max_str = get_node("test/label_max_strngth")
onready var label_gyro_test = get_node("test/label_gyro_test")
onready var label_steps_counter = get_node("test/label_steps_counter")
onready var label_step_threshold = get_node("test/label_step_threshold")

onready var label_velocity_monitor = get_node("test/label_velocity_monitor")

var pressed_counter = 0

var max_str = 0

func _ready():
	set_process(true)
	
	#handle signals:
	button_increase.connect("pressed", self, "on_button_increase_pressed")
	button_decrease.connect("pressed", self, "on_button_decrease_pressed")
	button_reset.connect("pressed", self, "on_button_reset_pressed")
	
	update_threshold_labels()

func _process(delta):
	var gyro = Input.get_gyroscope()
	var acc = Input.get_accelerometer() - motion_sensor.current_rest_axis
	var current_str = acc.length()
	if(current_str > max_str):
		max_str = current_str
	
	#update labels:
	label_accer_test.set_text(str(acc))
	label_acce_str.set_text("accel_length " + str(current_str))
	label_max_str.set_text("max acc str " + str(max_str))
	label_gyro_test.set_text("gyro " + str(gyro))
	label_steps_counter.set_text("steps "+str(motion_sensor.get_steps_counter()))
	label_velocity_monitor.set_text("velocity: " + str(motion_sensor.get_last_velocity()))

func update_threshold_labels():
	label_step_threshold.set_text("step threshold " + str(motion_sensor.step_threshold))

func on_button_reset_pressed():
	pressed_counter+=1
	label_test.set_text("yo this is number pressed " +str(pressed_counter))
	
	#resets max str:
	max_str = 0
	motion_sensor.reset_steps_counter()

func on_button_increase_pressed():
	motion_sensor.step_threshold -= 0.01
	update_threshold_labels()

func on_button_decrease_pressed():
	motion_sensor.step_threshold += 0.01
	update_threshold_labels()
