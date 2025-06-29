class_name GlobalClass
extends Node

var settings: RSettings
var settings_file_path: String = "user://settings.tres"

func _ready() -> void:
	_load_settings()
	settings.init()
	_connect_signals()

func _connect_signals() -> void:
	if settings.settings_changed.connect(_save_settings_to_file): printerr("Fail: ",get_stack())

func _load_settings() -> void:
	if(FileAccess.file_exists(settings_file_path)):
		#print("loading settings")
		_load_settings_from_file()
	else:
		print('Unavailable to find settings files. Load defaults.')
		# Load default settings
		settings = load("uid://dl1cjvhumaiyu") as RSettings

func _load_settings_from_file() -> void:
	var resource: Resource = ResourceLoader.load(settings_file_path, "RSettings",ResourceLoader.CACHE_MODE_REPLACE_DEEP)
	if resource:
		settings = resource as RSettings
	else:
		print("Failed to load settings, using defaults.")
		settings = ResourceLoader.load("uid://dl1cjvhumaiyu") as RSettings

func _save_settings_to_file() -> void:
	var file: FileAccess = FileAccess.open(settings_file_path, FileAccess.WRITE)
	if(file):
		var save_status: Error = ResourceSaver.save(settings, settings_file_path)
		if(save_status == OK):
			print("Settings saved!")
		else:
			print("Failed at saving: " + str(save_status))
		file.close()
	else:
		print("Failed to save settings: " + str(FileAccess.get_open_error()))
