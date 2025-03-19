class_name ActionButtonUI
extends Button

signal action_button_pressed(action: String)

@onready var _a_button: Button = %AButton
@onready var _label_action: Label = %LabelAction
@onready var _label_input: Label = %LabelInput

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	_a_button.pressed.connect(_on_a_button_pressed)

func init(action: String, input: String) -> void:
	_label_action.text = action
	_label_input.text = input

func _on_a_button_pressed() -> void:
	action_button_pressed.emit(_label_action.text)
