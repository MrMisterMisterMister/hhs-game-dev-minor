extends Resource

const DEFAULT_FULLSCREEN: bool = 0 # Is Windowed
const DEFAULT_BORDERLESS: bool = false # Is Borderless 
const DEFAULT_V_SYNC: bool = true # V-Sync turned on
const DEFAULT_RESOLUTION: int = 0 # Index in resolutions

var DEFAULT_VOLUME: Dictionary = {
	"Master": 100.0,
	"Music": 100.0,
	"SFX": 100.0,
}

const SETTINGS_FILE_PATH: String = "user://settings.cfg"

const RESOLUTIONS: Dictionary = {
	"1152x648": Vector2i(1152, 648),
	"1280x720": Vector2i(1280, 720),
	"1366x768": Vector2i(1366, 768),
	"1600x900": Vector2i(1600, 900),
	"1920x1080": Vector2i(1920, 1080),
	"2560x1440": Vector2i(2560, 1440),
	"3840x2160": Vector2i(3840, 2160)
}
