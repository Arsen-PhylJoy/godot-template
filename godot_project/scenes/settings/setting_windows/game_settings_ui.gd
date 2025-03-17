class_name GameSettingsUI
extends Control

@onready var settings: RSettings = Global.settings
@onready var _language_option_button: OptionButton = %LanguageOptionButton


func _ready() -> void:
	_connect_signals()
	_init_languages_list()
	for i: int in _language_option_button.item_count:
		if(_language_option_button.get_item_text(i) == settings.LANGUAGES.values()[i]):
			print(str(_language_option_button.get_item_text(i)) + "==" + str(settings.LANGUAGES.values()[i]))
			_language_option_button.select(i)
			break

func _connect_signals() -> void:
	_language_option_button.item_selected.connect(_on_language_selected)

func _init_languages_list() -> void:
	for key: String in settings.LANGUAGES:
		_language_option_button.add_item(settings.LANGUAGES[key])

func _on_language_selected(item: int) -> void:
	var language: String = _language_option_button.get_item_text(item)
	for i: String in settings.LANGUAGES:
		if(settings.LANGUAGES[i] == language):
			settings.set_language(i)
