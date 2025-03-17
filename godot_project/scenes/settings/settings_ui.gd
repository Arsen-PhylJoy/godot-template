class_name SettingsWindows
extends CanvasLayer

@onready var _exit_button: Button = %ExitButton

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	if _exit_button.pressed.connect(_on_pressed_exited): printerr("Fail: ",get_stack())

func _on_pressed_exited() -> void:
	queue_free()
