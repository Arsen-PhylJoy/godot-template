class_name RSettings
extends Resource

signal settings_changed()

## Game
const LANGUAGES: Dictionary[String,String] = {
	"English" = "en", 
	"Русский" = "ru"
	}

var language: String = "en":
	get():
		return language
	set(value):
		language = value

## Sound
var master_sound_level: int = 75:
	get():
		return master_sound_level
	set(value):
		if(value > 100 or value <0):
			return
		else:
			master_sound_level = value
var sfx_sound_level: int = 75:
	get():
		return sfx_sound_level
	set(value):
		if(value > 100 or value <0):
			return
		else:
			sfx_sound_level = value
var music_sound_level: int = 75:
	get():
		return music_sound_level
	set(value):
		if(value > 100 or value < 0):
			return
		else:
			music_sound_level = value

## Graphic

const RESOLUTIONS: Dictionary[String,Vector2] = {
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
	}

var resolution: Vector2 = Vector2(1920,1080):
	get():
		return resolution
	set(value):
		for i: String in RESOLUTIONS:
			if(RESOLUTIONS[i] == value):
				resolution = value

var is_full_screen: bool = false

const FRAME_RATES: Dictionary[String,int] = {
	"NO_LIMIT" = 0,
	"30" = 30,
	"60" = 60,
	"75" = 75,
	"120" = 120,
	"144" = 144,
	"244" = 244
	}

var frame_rate: int = 0:
	get():
		return frame_rate
	set(value):
		for i: String in FRAME_RATES:
			if(FRAME_RATES[i] == value):
				frame_rate = value

var is_vsync_on: bool = false

var is_first_launch: bool = false

func _init() -> void:
	set_master_to(master_sound_level)
	set_music_to(sfx_sound_level)
	set_sfx_to(music_sound_level)
	set_resolution(resolution)
	set_fullscreen(is_full_screen)
	set_frame_rate(frame_rate)
	set_vsync(is_vsync_on)
	set_language(language)

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
	if(rate == 0):
		Engine.max_fps = 0
	else:
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
	elif(is_first_launch):
		language = "en"
	elif(LANGUAGES.find_key(lang) != null):
		language = lang
	TranslationServer.set_locale(language)
	settings_changed.emit()

func _volume_to_db(volume: float) -> float:
	if volume <= 0:
		return -80
	return 20 * log(volume / 100.0)

func _db_to_volume(db: float) -> float:
	if db <= -80:
		return 0
	return 100 * pow(10, db / 20.0)
