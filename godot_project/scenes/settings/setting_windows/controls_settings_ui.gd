class_name ControlSettingsUI
extends Control

@onready var settings: RSettings = Global.settings

@onready var _actions_list: VBoxContainer = %ActionsList
@onready var _action_button_ps: PackedScene = preload("res://scenes/settings/primitives/action_button_ui.tscn")
@onready var _reset_button: Button = %ResetButton

func  _ready() -> void:
	for action: String in InputMap.get_actions():
		if(action.substr(0,2) != "ui"):
			var action_button: ActionButtonUI = _action_button_ps.instantiate()
			_actions_list.add_child(action_button)
			action_button.set_action_button(action, settings.action_map[action])
	_connect_signals()

func _connect_signals() -> void:
	for action_button: ActionButtonUI in _actions_list.get_children():
		if action_button.action_button_mapped.connect(_on_action_button_pressed): printerr("Fail: ",get_stack())
	_reset_button.pressed.connect(_on_reset_pressed)

func _on_action_button_pressed(action: String, event: InputEvent) -> void:
	settings.change_action_map(action, event)

func _on_reset_pressed() -> void:
	settings.default_keys_controls()
	var i: int = 0
	var action_buttons: Array[Node] = _actions_list.get_children()
	for action: String in settings.action_map:
		if(action_buttons[i] is ActionButtonUI):
			(action_buttons[i] as ActionButtonUI).set_action_button(action, InputMap.action_get_events(action)[0])
			i+=1
