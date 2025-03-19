class_name OptionsSettingsUI
extends Control

signal new_value_selected(value: String)

@export var options_name: String = "unv"

@onready var _options_label: Label = %OptionsLabel
@onready var _option_button: OptionButton = %OptionButton

func _ready() -> void:
	_connect_signals()
	_options_label.text = options_name

func init_option_button(array_of_values: Array[String], selected_value: String) -> void:
	for i: String in array_of_values:
		_option_button.add_item(i)
	for i: int in array_of_values.size():
		if(array_of_values[i] == selected_value):
			_option_button.select(i)
			break

func _connect_signals() -> void:
	if _option_button.item_selected.connect(_on_item_selected): printerr("Fail: ",get_stack())

func _on_item_selected(index: int) -> void:
	new_value_selected.emit(_option_button.get_item_text(index))
