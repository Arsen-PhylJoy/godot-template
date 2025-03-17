class_name ToggleSettings
extends Control

signal state_changed(status: bool)

@onready var _state_settings_label: Label = %Name
@onready var _check_button: CheckButton = %CheckButton

func _ready() -> void:
	_connect_signals()

func init_toggle(toggle_name: String, state: bool) -> void:
	_state_settings_label.text = toggle_name
	_check_button.button_pressed = state
	if(state):
		_check_button.text = "ON"
	else:
		_check_button.text = "OFF"

func _connect_signals() -> void:
	if _check_button.toggled.connect(_on_toggled): printerr("Fail: ",get_stack())

func _on_toggled(state: bool) -> void:
	if(state == true):
		_check_button.text = "ON"
	else:
		_check_button.text = "OFF"
	state_changed.emit(state)
