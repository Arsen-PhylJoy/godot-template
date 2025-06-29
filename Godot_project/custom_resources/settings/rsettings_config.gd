class_name RSettings
extends Resource

signal settings_changed()

## Game

@export_storage var LANGUAGES: Dictionary[String,String] = {
	"English" = "en", 
	"Русский" = "ru"
	}:
		get():
			return LANGUAGES
		set(value):
			return

@export_storage var language: String = "en":
	get():
		return language
	set(value):
		language = value

## Sound

@export_storage var master_sound_level: int = 75:
	get():
		return master_sound_level
	set(value):
		if(value > 100 or value <0):
			return
		else:
			master_sound_level = value
@export_storage var sfx_sound_level: int = 75:
	get():
		return sfx_sound_level
	set(value):
		if(value > 100 or value <0):
			return
		else:
			sfx_sound_level = value
@export_storage var music_sound_level: int = 75:
	get():
		return music_sound_level
	set(value):
		if(value > 100 or value < 0):
			return
		else:
			music_sound_level = value

## Graphic

@export_storage var RESOLUTIONS: Dictionary[String,Vector2] = {
	"1280×720" = Vector2(1280,720),
	"1366×768" = Vector2(1366,768),
	"1600×900" = Vector2(1600,900),
	"1920×1080" = Vector2(1920,1080),
	"2560×1080" = Vector2(2560,1080),
	"2560×1440" = Vector2(2560,1440),
	"3200×1800" = Vector2(3200,1800),
	"3440×1440" = Vector2(3440,1440),
	"3840×2160" = Vector2(3840,2160),
	"5120×1440" = Vector2(5120,1440)
	}:
		get():
			return RESOLUTIONS
		set(value):
			return

@export_storage var resolution: Vector2 = Vector2(1920,1080):
	get():
		return resolution
	set(value):
		for i: String in RESOLUTIONS:
			if(RESOLUTIONS[i] == value):
				resolution = value

@export_storage var is_full_screen: bool = false

@export_storage var FRAME_RATES: Dictionary[String,int] = {
	"NO_LIMIT" = 0,
	"30" = 30,
	"60" = 60,
	"75" = 75,
	"120" = 120,
	"144" = 144,
	"244" = 244
	}:
		get():
			return FRAME_RATES
		set(value):
			return

@export_storage var frame_rate: int = 0:
	get():
		return frame_rate
	set(value):
		for i: String in FRAME_RATES:
			if(FRAME_RATES[i] == value):
				frame_rate = value

@export_storage var is_vsync_on: bool = false

##Controls

@export_storage var default_action_map: Dictionary[String,InputEvent] ={}

@export_storage var action_map: Dictionary[String,InputEvent] ={}

##Other
@export_storage var is_first_launch: bool = true

func init() -> void:
	## Audio
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), _volume_to_db(master_sound_level))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), _volume_to_db(sfx_sound_level))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), _volume_to_db(music_sound_level))
	## Graphic
	Engine.max_fps = frame_rate
	DisplayServer.window_set_size(resolution)
	DisplayServer.window_set_position(Vector2(0,0))
	if(is_vsync_on):
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	if(is_full_screen):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	## Translations
	TranslationServer.set_locale(language)
	## Controls
	_init_input_map()

func set_master_to(value: int) -> void:
	master_sound_level = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), _volume_to_db(master_sound_level))
	settings_changed.emit()

func set_sfx_to(value: int) -> void:
	sfx_sound_level = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), _volume_to_db(sfx_sound_level))
	settings_changed.emit()

func set_music_to(value: int) -> void:
	music_sound_level = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), _volume_to_db(music_sound_level))
	settings_changed.emit()

func set_frame_rate(rate: int) -> void:
	frame_rate = rate
	Engine.max_fps = rate
	settings_changed.emit()

func set_resolution(res: Vector2) -> void:
	resolution = res
	DisplayServer.window_set_size(resolution)
	DisplayServer.window_set_position(Vector2(0,0))
	settings_changed.emit()

func set_vsync(state: bool) -> void:
	if(state == true):
		is_vsync_on = true
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		is_vsync_on = false
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	settings_changed.emit()

func set_fullscreen(state: bool) -> void:
	is_full_screen = state
	if(is_full_screen):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	settings_changed.emit()

func set_language(lang: String) -> void:
	if(is_first_launch and LANGUAGES.has(OS.get_locale_language())):
		language = OS.get_locale_language()
		is_first_launch = false
	elif(is_first_launch):
		language = "en"
		is_first_launch = false
	elif(LANGUAGES.find_key(lang) != null):
		language = lang
	TranslationServer.set_locale(language)
	settings_changed.emit()

func change_action_map(action: String, event: InputEvent) -> void:
	action_map[action] = event
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action,action_map[action])
	settings_changed.emit()
	__print_mappings()

func default_keys_controls() -> void:
	action_map = default_action_map.duplicate()
	for action: String in action_map:
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action,action_map[action])
	settings_changed.emit()
	__print_mappings()

func _volume_to_db(volume: float) -> float:
	if volume <= 0:
		return -80
	return 20 * log(volume / 100.0)

func _db_to_volume(db: float) -> float:
	if db <= -80:
		return 0
	return 100 * pow(10, db / 20.0)

func _get_user_defined_actions() -> Dictionary[String,InputEvent]:
	var out: Dictionary[String,InputEvent]
	for action: String in InputMap.get_actions():
		if(action.substr(0,2) != "ui"):
			out.set(action, InputMap.action_get_events(action)[0])
	return out

func _init_input_map() -> void:
	default_action_map = _get_user_defined_actions().duplicate()
	if(is_first_launch):
		action_map = default_action_map.duplicate()
		is_first_launch = false
	else:
		for action: String in action_map:
			if(!InputMap.has_action(action)):
				InputMap.add_action(action)
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action,action_map[action])
		for action: String in InputMap.get_actions():
			if(!action_map.has(action) and action.substr(0,2) != "ui"):
				action_map.set(action,InputMap.action_get_events(action)[0])
				default_action_map.set(action,InputMap.action_get_events(action)[0])
	__print_mappings()

func __print_mappings() -> void:
	print("Defaults")
	for action: String in default_action_map:
		print(action + " is " + default_action_map[action].as_text())
	print("----------------")
	print("Actuals")
	for action: String in action_map:
		print(action + " is " + action_map[action].as_text())
	print("----------------")
	print("InputMap")
	for action: String in InputMap.get_actions():
		if(action.substr(0,2) != "ui"):
			print(action + " is " + InputMap.action_get_events(action)[0].as_text())
