extends KinematicBody2D

onready var Enemy_Bullet = load("res://Enemy2/Enemy_Bullet.tscn")
var nose = Vector2(0,-60)
var health = 5
var initial_position = Vector2.ZERO
var y_positions = [100,150,200,500,550]
var direction = Vector2(1.5,0)
var wobble = 30.0
var score = 50

func _ready():
	initial_position.x = -100
	initial_position.y = y_positions[randi() % y_positions.size()]
	position = initial_position

func _physics_process(_delta):
	position += direction
	position.y = initial_position.y + sin(position.x/20)*wobble
	if position.x >= Global.VP.x + 200:
		queue_free()


func damage(d):
	health -= d
	if health <= 0:
		Global.update_score(score)
		queue_free()

func _on_Timer_timeout():
	
	var Player = get_node_or_null("/root/Game/Player_Container2/Player")
	var Effects = get_node_or_null("/root/Game/Effects")
	if Player != null and Effects != null:
		print("shooting")
		var dir = global_position.angle_to_point(Player.global_position) - PI/2
		var enemy_bullet = Enemy_Bullet.instance()
		enemy_bullet.position = global_position + nose.rotated(dir)
		enemy_bullet.rotation = dir
		enemy_bullet.velocity = enemy_bullet.velocity.rotated(dir)
		Effects.add_child(enemy_bullet)
