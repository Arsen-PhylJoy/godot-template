class_name GraphicSettingsUI
extends Control

@onready var settings: RSettings = Global.settings

@onready var _vsync_toggle: ToggleSettingsUI = %VsyncToggle
@onready var _resolutions_options_settings_ui: OptionsSettingsUI = %ResolutionsOptionsSettingsUi
@onready var _frames_options_settings_ui: OptionsSettingsUI = %FramesOptionsSettingsUi
@onready var _fullscreen_toggle: ToggleSettingsUI = %FullscreenToggle

func _ready() -> void:
	_vsync_toggle.init_toggle(settings.is_vsync_on)
	_resolutions_options_settings_ui.init_option_button(settings.RESOLUTIONS.keys(), settings.RESOLUTIONS.find_key(settings.resolution) as String)
	_frames_options_settings_ui.init_option_button(settings.FRAME_RATES.keys(), settings.FRAME_RATES.find_key(settings.frame_rate) as String)
	_fullscreen_toggle.init_toggle(settings.is_full_screen)
	_connect_signals()

func _connect_signals() -> void:
	if _vsync_toggle.state_changed.connect(_on_vsync_state_changed): printerr("Fail: ",get_stack())
	if _resolutions_options_settings_ui.new_value_selected.connect(on_new_resolution_selected): printerr("Fail: ",get_stack())
	if _frames_options_settings_ui.new_value_selected.connect(on_new_frame_rate_selected): printerr("Fail: ",get_stack())
	if _fullscreen_toggle.state_changed.connect(_on_fullscreen_state_changed): printerr("Fail: ",get_stack())

func on_new_resolution_selected(res: String) -> void:
	settings.set_resolution(settings.RESOLUTIONS[res])

func on_new_frame_rate_selected(frame_rate: String) -> void:
	settings.set_frame_rate(settings.FRAME_RATES[frame_rate])

func _on_vsync_state_changed(state: bool) -> void:
	settings.set_vsync(state)

func _on_fullscreen_state_changed(state: bool) -> void:
	settings.set_fullscreen(state)
