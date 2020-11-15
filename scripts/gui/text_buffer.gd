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

# nodes:
onready var text = get_node("text")
onready var continue_button = get_node("continue_button")

const max_line_length = 99

# 0 is the current line, 1 is the line after that, and so on...
var lines_queue = ["................................"]

# Emitted when lines_queue has no more lines.
signal queue_ended

func _ready():
	# signals:
	continue_button.connect("pressed", self, "on_continue_button_pressed")
	
	update_gui()

# Called to update the gui elements, in case something changed
func update_gui():
	text.set_text(lines_queue[0])

func add_to_lines(line):
	if(line.length() <= max_line_length):
		lines_queue.append(line)
	else: # splits the line into multiple lines:
		var words = line.split(" ", false) # splits the line into words
		# we are adding the words 1 by 1 to a line, if the line is too long,
		# we add the last word to a new line, and start again
		while(words.size() > 0):
			var n_line = ""
			var last_word = words[0]
			var last_line = n_line
			
			# as long as the new line is shorter than the mex length, add more words
			# unless there are no more words to add
			while(n_line.length() < max_line_length && words.size() > 0):
				last_line = n_line
				if(n_line == ""):
					n_line = words[0]
				else:
					n_line = n_line +" " + words[0]
				last_word = words[0]
				words.remove(0)
			
			if(words.size() != 0): # we still have more words to use
				words.insert(0, last_word)
				lines_queue.append(last_line)
			else: # we ran out of words
				lines_queue.append(n_line)

func set_lines(lines):
	lines_queue = []
	for l in lines:
		add_to_lines(l)
	self.show()
	update_gui()

# move the buffer to the next line. if there's no lines
func show_next():
	if(lines_queue.size() == 1): # besides the current line, no more lines left
		self.hide()
		emit_signal("queue_ended")
	else:
		lines_queue.remove(0) # removes the current line
		update_gui() # updates the disply [next line will be shown]

#mobile button handling
func on_continue_button_pressed():
	show_next()
