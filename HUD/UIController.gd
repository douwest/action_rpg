extends CanvasLayer

var playerStats
var showing_death_screen = false

onready var statusScreen = $CharacterUI
onready var audioController = $UIAudioController
onready var deathScreen = $DeathScreen

func init(stats):
	self.update(stats)

func update(stats):
	self.playerStats = stats
	self.update_hp_bar()
	self.update_xp_bar()
	self.update_level()

func update_hp_bar():
	statusScreen.hpBar.set_value(playerStats.get_health_percentage())

func update_xp_bar():
	statusScreen.xpBar.set_value(playerStats.get_xp_percentage())

func update_level():
	statusScreen.set_lvl_label(playerStats.get_current_level())

func play_pause_sound():
	audioController.play()

func show_death_screen():
	if !showing_death_screen:
		print('show')
		deathScreen.feather_in()
		showing_death_screen = true
	
