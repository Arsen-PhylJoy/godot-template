class_name SoundSettingsUI
extends Control

@onready var settings: RSettings = Global.settings
@onready var _master_slider: SliderSettings = %MasterSlider
@onready var _sfx_slider: SliderSettings = %SFXSlider
@onready var _music_slider: SliderSettings = %MusicSlider

func _ready() -> void:
	_master_slider.init_slider("MASTER", settings.get_master_value())
	_sfx_slider.init_slider("SOUND_EFFECTS", settings.get_sfx_value())
	_music_slider.init_slider("MUSIC", settings.get_music_value())
	_connect_signals()

func _connect_signals() -> void:
	if _master_slider.value_changed.connect(_on_value_changed_master): printerr("Fail: ",get_stack())
	if _sfx_slider.value_changed.connect(_on_value_changed_sfx): printerr("Fail: ",get_stack())
	if _music_slider.value_changed.connect(_on_value_changed_music): printerr("Fail: ",get_stack())

func _on_value_changed_master(value: int) -> void:
	settings.set_master_to(value)

func _on_value_changed_sfx(value: int) -> void:
	settings.set_sfx_to(value)

func _on_value_changed_music(value: int) -> void:
	settings.set_music_to(value)
