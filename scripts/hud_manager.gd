extends Control

@onready var coins_counter = $container/coins_container/coins_counter as Label
@onready var score_counter = $container2/score_container/score_counter as Label
@onready var life_counter = $container/life_container/life_counter as Label

# Called when the node enters the scene tree for the first time.
func _ready():
	coins_counter.text = str("%02d"% Globals.coins)
	score_counter.text = str("%06d"% Globals.score)
	life_counter.text = str(Globals.player_life)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	coins_counter.text = str("%02d"% Globals.coins)
	score_counter.text = str("%06d"% Globals.score)
	life_counter.text = str(Globals.player_life)
