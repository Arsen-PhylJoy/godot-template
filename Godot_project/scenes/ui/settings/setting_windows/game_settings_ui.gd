class_name GameSettingsUI
extends Control

@onready var settings: RSettings = Global.settings
@onready var _options_settings_ui: OptionsSettingsUI = %OptionsSettingsUi
@onready var _start_game: Button = %StartGame
@onready var _end_game: Button = %EndGame


func _ready() -> void:
	_connect_signals()
	_init_languages_list()

func _connect_signals() -> void:
	if _options_settings_ui.new_value_selected.connect(_on_language_selected): printerr("Fail: ",get_stack()) 
	if _start_game.pressed.connect(_on_start_game_pressed): printerr("Fail: ",get_stack()) 
	if _end_game.pressed.connect(_on_end_game_pressed): printerr("Fail: ",get_stack()) 

func _init_languages_list() -> void:
	_options_settings_ui.init_option_button(settings.LANGUAGES.keys(), settings.LANGUAGES.find_key(settings.language) as String)

func _on_language_selected(value: String) -> void:
	settings.set_language(settings.LANGUAGES[value])

func _on_start_game_pressed() -> void:
	pass

func _on_end_game_pressed() -> void:
	get_tree().quit()
