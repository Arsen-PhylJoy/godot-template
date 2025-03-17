class_name GlobalClass
extends Node

var settings: RSettings
var default_settings: RSettings = preload("uid://dl1cjvhumaiyu") as RSettings
var settings_file_path: String = "user://template_godot/settings.tres"

func _ready() -> void:
	if(true):
		settings = default_settings
	elif(FileAccess.file_exists(settings_file_path)):
		_load_settings_from_file()
	else:
		settings = ResourceLoader.load("uid://dl1cjvhumaiyu") as RSettings
	_connect_signals()

func _connect_signals() -> void:
	if tree_exiting.connect(_on_exiting): printerr("Fail: ",get_stack())

func _load_settings_from_file() -> void:
	var resource: Resource = load(settings_file_path)
	if resource:
		settings = resource as RSettings
	else:
		print("Failed to load settings, using defaults.")
		settings = ResourceLoader.load("uid://dl1cjvhumaiyu") as RSettings

func _save_settings_to_file() -> void:
	var file: FileAccess = FileAccess.open(settings_file_path, FileAccess.WRITE)
	if(file):
		if ResourceSaver.save(settings, settings_file_path): printerr("Fail: ",get_stack()) 
		print("Settings saved!")
		file.close()
	else:
		print("Failed to save settings.")

func _on_exiting() -> void:
	_save_settings_to_file()
