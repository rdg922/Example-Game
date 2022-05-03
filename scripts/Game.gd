extends Node2D


onready var enemy_scene = preload("res://scenes/Enemy.tscn")

var score = 0 setget update_score

# Called when the node enters the scene tree for the first time.
func _ready():
	$HighScore.text = "HIGH SCORE: " + str(HighScore.score)
	spawn()
	pass # Replace with function body.

func spawn():
	var enemy = enemy_scene.instance()
	add_child(enemy)
	enemy.position.x = rand_range(0, 1024)
	enemy.position.y = rand_range(0, 600)
func reset():
	get_tree().reload_current_scene()

func update_score(amount):
	score = amount
	$Label.text = "POINTS: " + str(score)
	if HighScore.score < score:
		HighScore.score = score 
		$HighScore.text = "HIGH SCORE: " + str(HighScore.score)
	pass
