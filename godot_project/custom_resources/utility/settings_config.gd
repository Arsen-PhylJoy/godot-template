class_name RSettings
extends Resource

## Game
const LANGUAGES: Dictionary[String,String] = {
	"en" = "English", 
	"ru" = "Русский"
	}

var _language: String = "en":
	get():
		return _language
	set(value):
		if(LANGUAGES.has(value)):
			_language = value

## Sound
var _master_sound_level: int = 75:
	get():
		return _master_sound_level
	set(value):
		if(value > 100 or value <0):
			return
		else:
			_master_sound_level = value
var _sfx_sound_level: int = 75:
	get():
		return _sfx_sound_level
	set(value):
		if(value > 100 or value <0):
			return
		else:
			_sfx_sound_level = value
var _music_sound_level: int = 75:
	get():
		return _music_sound_level
	set(value):
		if(value > 100 or value < 0):
			return
		else:
			_music_sound_level = value

## Graphic
var _screen_width: int = 1920:
	get():
		return _screen_width
	set(value):
		if(value <= 10000 and value >= 100):
			_screen_width = value
var _screen_height: int = 1080:
	get():
		return _screen_height
	set(value):
		if(value <= 10000 and value >= 100):
			_screen_height = value
var _is_full_screen: bool = false
var _frame_rate: int = 0:
	get():
		return _frame_rate
	set(value):
		if(value > 0 and value <= 2000):
			_frame_rate = value
var _is_unlimited_frame_rate: bool = true
var _is_vsync_on: bool = false

var _is_first_launch: bool = false

func _init() -> void:
	set_master_to(_master_sound_level)
	set_music_to(_sfx_sound_level)
	set_sfx_to(_music_sound_level)
	set_resolution(_screen_width,_screen_height)
	set_fullscreen(_is_full_screen)
	set_frame_rate(_frame_rate,_is_unlimited_frame_rate)
	set_vsync(_is_vsync_on)
	set_language(_language)

func get_master_value() -> int:
	return _master_sound_level

func set_master_to(value: int) -> void:
	_master_sound_level = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), _volume_to_db(_master_sound_level))

func get_sfx_value() -> int:
	return _sfx_sound_level

func set_sfx_to(value: int) -> void:
	_sfx_sound_level = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), _volume_to_db(_sfx_sound_level))

func get_music_value() -> int:
	return _music_sound_level

func set_music_to(value: int) -> void:
	_music_sound_level = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), _volume_to_db(_music_sound_level))

func get_frame_rate() -> int:
	return _frame_rate

func get_frame_rate_unlimited() -> bool:
	return _is_unlimited_frame_rate

func set_frame_rate(rate: int, unlimited: bool = false) -> void:
	if(unlimited == true):
		_is_unlimited_frame_rate = true
		Engine.max_fps = 0
	elif(rate > 0):
		_is_unlimited_frame_rate = false
		_frame_rate = rate
		Engine.max_fps = rate

func get_resolution() -> Vector2:
	return Vector2(_screen_width,_screen_height)

func set_resolution(width: int, height: int) -> void:
	_screen_width = width
	_screen_height = height
	DisplayServer.window_set_size(Vector2(_screen_width, _screen_height))
	DisplayServer.window_set_position(Vector2(0,0))

func get_vsync() -> bool:
	return _is_vsync_on

func set_vsync(state: bool) -> void:
	if(state == true):
		_is_vsync_on = true
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		_is_vsync_on = false
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func get_fullscreen() -> bool:
	return _is_full_screen

func set_fullscreen(state: bool) -> void:
	_is_full_screen = state
	if(_is_full_screen):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func get_language() -> String:
	return _language

func set_language(lang: String) -> void:
	if(_is_first_launch and LANGUAGES.has(OS.get_locale_language())):
		_language = OS.get_locale_language()
	elif(_is_first_launch):
		_language = "en"
	elif(LANGUAGES.has(lang)):
		_language = lang
	TranslationServer.set_locale(_language)

func _volume_to_db(volume: float) -> float:
	if volume <= 0:
		return -80
	return 20 * log(volume / 100.0)

func _db_to_volume(db: float) -> float:
	if db <= -80:
		return 0
	return 100 * pow(10, db / 20.0)
