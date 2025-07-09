class_name SettingsWindows
extends CanvasLayer

var _prev_mouse_capture_mode: Input.MouseMode

func _ready() -> void:
	_prev_mouse_capture_mode = Input.mouse_mode
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func _on_pressed_exited() -> void:
	get_tree().paused = false
	Input.mouse_mode = _prev_mouse_capture_mode
	queue_free()
