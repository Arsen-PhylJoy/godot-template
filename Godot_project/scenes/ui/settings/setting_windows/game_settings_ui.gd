class_name GameSettingsUI
extends Control

@onready var settings: RSettings = Global.settings
@onready var _options_settings_ui: OptionsSettingsUI = %OptionsSettingsUi
@onready var start_game: Button = %StartGame
@onready var end_game: Button = %EndGame


func _ready() -> void:
	_connect_signals()
	_init_languages_list()

func _connect_signals() -> void:
	if _options_settings_ui.new_value_selected.connect(_on_language_selected): printerr("Fail: ",get_stack()) 
	start_game.connect("pressed",_on_start_game)
	end_game.connect("pressed",_on_end_game)

func _init_languages_list() -> void:
	_options_settings_ui.init_option_button(settings.LANGUAGES.keys(), settings.LANGUAGES.find_key(settings.language) as String)

func _on_language_selected(value: String) -> void:
	settings.set_language(settings.LANGUAGES[value])

func _on_start_game() -> void:
	get_owner().visible = false
	EventBus.fromMenuPause = false
	EventBus.generalPause = false

func _on_end_game() -> void:
	get_tree().quit()
