extends Control

@onready var coins_counter = $Container/UpLeftContainer/CoinsContainer/CoinsCounter as Label
@onready var score_counter = $Container/ScoreContainer/ScoreCounter as Label
@onready var life_counter = $Container/UpLeftContainer/LifeContainer/LifeCounter as Label
@onready var health_empty = $Container/HealthEmpty as TextureRect
@onready var health_full = $Container/HealthFull as TextureRect


func _ready():
	coins_counter.text = str("%02d"% Globals.coins)
	score_counter.text = str("%06d"% Globals.score)
	life_counter.text = str(Globals.player_life)
	health_empty.custom_minimum_size = Vector2(Globals.player_max_hp * 72 , 64)
	health_full.custom_minimum_size = Vector2(Globals.player_hp * 72, 64)


func _process(_delta):
	coins_counter.text = str("%02d"% Globals.coins)
	score_counter.text = str("%06d"% Globals.score)
	life_counter.text = str(Globals.player_life)
	health_empty.custom_minimum_size = Vector2(Globals.player_max_hp * 72 , 64)
	health_full.custom_minimum_size = Vector2(Globals.player_hp * 72, 64)

