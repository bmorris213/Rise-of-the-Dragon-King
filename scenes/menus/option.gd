# Rise of the Dragon King
# 07-02-2025
# Brian Morris

extends Node

# Option
# encapsulates a single choice in a menu or dialogue branch

class_name Option

var _option_label : Label
var _callable : Callable
var temp : bool

# init
# constructor for options
func _init(label : Label = null, callable : Callable = _default_function, temporary : bool = false):
	self._option_label = label
	self._callable = callable
	self.temp = temporary

# default function
# a callable for options to use as a default
func _default_function():
	pass
