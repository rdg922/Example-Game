extends KinematicBody2D

enum STATES {STARTUP, POINTING, FOLLOWING, DONE_FOLLOWING}
const ROTATION_SPEED = 290
var rotations = 0

onready var player_pointer = $PlayerPointer
onready var player = get_node("../Player")

var target
var state = STATES.STARTUP

const SPEED = 250
const DONE_SPEED = SPEED - 100
var follow_rotation = 2*PI

var old_rotation = global_rotation

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.modulate.a = 0.5
	$EnemyParticles.emitting = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	player_pointer.global_rotation = atan2(- global_position.y + player.global_position.y, - global_position.x + player.global_position.x) - PI/2
	if state == STATES.STARTUP:
		rotation_degrees+=delta * ROTATION_SPEED
		if rotation_degrees > 360:
			state = STATES.POINTING
	if state == STATES.POINTING:
		var rotation_diff = abs((int(global_rotation) % 360) - (atan2(- global_position.y + player.global_position.y, - global_position.x + player.global_position.x)))
		if rotation_diff < deg2rad(15):
			state = STATES.FOLLOWING
			$Sprite.modulate.a = 1
			$EnemyParticles.emitting = true
		else:
			rotation_degrees+=delta * ROTATION_SPEED
	if state == STATES.FOLLOWING:
		var motion = Vector2(0, SPEED).rotated(player_pointer.global_rotation)
		var rotation_diff = (global_rotation - player_pointer.global_rotation - PI/2)

		global_rotation -= rotation_diff
		follow_rotation -= abs(rotation_diff)
		move_and_slide(motion)

		if follow_rotation < 0:
			state = STATES.DONE_FOLLOWING
			$EnemyParticles.emitting = false
			get_parent().call("spawn")
			get_parent().score += 1
	if state == STATES.DONE_FOLLOWING:
		var motion = Vector2(DONE_SPEED, 0).rotated(global_rotation)
		move_and_slide(motion)
		
	pass


func _on_Area2D_body_entered(body:Node):
	if body.is_in_group("Player") and state == STATES.FOLLOWING or state == STATES.DONE_FOLLOWING:
		get_parent().call("reset")

	pass # Replace with function body.
