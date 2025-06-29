class_name GraphicSettingsUI
extends Control

@onready var settings: RSettings = Global.settings

@onready var _frames_options_settings_ui: OptionsSettingsUI = %FramesOptionsSettingsUi

func _ready() -> void:
	_frames_options_settings_ui.init_option_button(settings.FRAME_RATES.keys(), settings.FRAME_RATES.find_key(settings.frame_rate) as String)
	_connect_signals()

func _connect_signals() -> void:
	if _frames_options_settings_ui.new_value_selected.connect(on_new_frame_rate_selected): printerr("Fail: ",get_stack())

func on_new_frame_rate_selected(frame_rate: String) -> void:
	settings.set_frame_rate(settings.FRAME_RATES[frame_rate])
