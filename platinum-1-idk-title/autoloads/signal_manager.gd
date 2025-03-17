extends Node

signal game_started
signal game_paused
signal game_resumed
signal game_ended
signal game_over
signal game_restarted
signal game_exited
signal game_settings

signal level_failed
signal level_completed

signal state_changed(state: State)

# Settings
signal fullscreen_changed
signal borderless_changed
signal v_sync_changed
signal resolution_changed
signal keybind_changed
signal volume_changed

signal settings_saved
signal settings_loaded

signal display_settings_loaded
signal control_settings_loaded
signal sound_settings_loaded
