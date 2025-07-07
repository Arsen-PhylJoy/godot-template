class_name SettingsWindows
extends CanvasLayer

var _prev_mouse_capture_mode: Input.MouseMode

func _ready() -> void:
	_prev_mouse_capture_mode = Input.mouse_mode
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	EventBus.fromMenuPause = true
	
func _process(_delta: float) -> void:
	if EventBus.fromMenuPause:
		visible = true
	else:
		visible = false

func _on_pressed_exited() -> void:
	get_tree().paused = false
	Input.mouse_mode = _prev_mouse_capture_mode
	get_tree().quit(0)
	queue_free()
