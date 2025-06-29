class_name ActionButtonUI
extends Button

signal action_button_mapped(action: String, event: InputEvent)

var _is_active: bool = false

@onready var _label_action: Label = %LabelAction
@onready var _label_input: Label = %LabelInput

func _ready() -> void:
	_connect_signals()

func _input(event: InputEvent) -> void:
	if(_is_active):
		if(event is InputEventKey or (event is InputEventMouseButton and event.is_pressed())):
			if(event is InputEventMouseButton and (event as InputEventMouseButton).double_click):
				(event as InputEventMouseButton).double_click = false
			action_button_mapped.emit(_label_action.text.to_lower(), event)
			accept_event()
			_is_active = false
			_label_input.text = _get_parsed_input_event(InputMap.action_get_events(_label_action.text.to_lower())[0])

func set_action_button(action: String, input: InputEvent) -> void:
	_label_action.text = action.to_upper()
	_label_input.text = _get_parsed_input_event(input)

func _connect_signals() -> void:
	if (self as Button).pressed.connect(_on_a_button_pressed): printerr("Fail: ",get_stack())

func _on_a_button_pressed() -> void:
	_is_active = true
	_label_input.text = "ENTER_NEW_KEY"

func _get_parsed_input_event(event: InputEvent) -> String:
	return event.as_text().trim_suffix(" (Physical)")
