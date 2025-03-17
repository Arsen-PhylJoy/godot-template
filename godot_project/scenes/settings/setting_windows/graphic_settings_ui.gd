class_name GraphicSettingsUI
extends Control

@onready var settings: RSettings = Global.settings
@onready var _resolution_option_button: OptionButton = %ResolutionOptionButton
@onready var _frame_rate_option_button: OptionButton = %FrameRateOptionButton
@onready var _vsync_toggle: ToggleSettings = %VsyncToggle
@onready var _fullscreen_toggle: ToggleSettings = %FullscreenToggle

func _ready() -> void:
	for i: int in _resolution_option_button.item_count:
		var reses: PackedStringArray = _resolution_option_button.get_item_text(i).split("×",true)
		if(Vector2(int(reses[0]),int(reses[1])) == settings.get_resolution()):
			_resolution_option_button.select(i)
	if(settings.get_frame_rate_unlimited() == true):
		_frame_rate_option_button.select(0)
	else:
			for i: int in _frame_rate_option_button.item_count:
				if(int(_frame_rate_option_button.get_item_text(i)) == settings.get_frame_rate()):
					_frame_rate_option_button.select(i)
	_vsync_toggle.init_toggle("VSYNC", settings.get_vsync())
	_fullscreen_toggle.init_toggle("FULLSCREEN", settings.get_fullscreen())
	_connect_signals()

func _connect_signals() -> void:
	if _resolution_option_button.item_selected.connect(_on_resolution_item_selected): printerr("Fail: ",get_stack()) 
	if _frame_rate_option_button.item_selected.connect(_on_frame_rate_item_selected): printerr("Fail: ",get_stack())
	if _vsync_toggle.state_changed.connect(_on_vsync_state_changed): printerr("Fail: ",get_stack())
	if _fullscreen_toggle.state_changed.connect(_on_fullscreen_state_changed): printerr("Fail: ",get_stack())

func _on_resolution_item_selected(index: int) -> void:
	var reses: PackedStringArray = _resolution_option_button.get_item_text(index).split("×",true)
	settings.set_resolution(int(reses[0]),int(reses[1]))

func _on_frame_rate_item_selected(index: int) -> void:
	var rate: String = _frame_rate_option_button.get_item_text(index)
	if(rate == "NO_LIMIT"):
		settings.set_frame_rate(0,true)
	else:
		settings.set_frame_rate(int(rate),false)

func _on_vsync_state_changed(state: bool) -> void:
	settings.set_vsync(state)

func _on_fullscreen_state_changed(state: bool) -> void:
	settings.set_fullscreen(state)
