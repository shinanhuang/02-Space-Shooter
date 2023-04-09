extends KinematicBody2D

var  velocity = Vector2.ZERO
var speed = 5.0
var max_speed = 400
var rot_speed = 5.0

var nose = Vector2(0,-60)

var target_pos = Vector2.ZERO

var health = 40

onready var Bullet = load("res://Player/Bullet.tscn")
onready var Explosion = load("res://Effects/Explosion.tscn")
var Effects = null

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _physics_process(_delta):
	velocity += get_input()*speed
	velocity = velocity.normalized() * clamp(velocity.length(), 0, max_speed)
	velocity = move_and_slide(velocity, Vector2.ZERO)
	position.x = wrapf(position.x, 0.0, Global.VP.x)
	position.y = wrapf(position.y, 0.0, Global.VP.y)
	target_pos = get_viewport().get_mouse_position()
	$Crosshair.global_position = target_pos
	
	
func get_input():
	var dir = Vector2.ZERO
	$Exhaust.hide()
	if Input.is_action_pressed("up"):
		$Exhaust.show()
		dir += Vector2(0,-1)
	if Input.is_action_pressed("left"):
		rotation_degrees -= rot_speed
	if Input.is_action_pressed("right"):
		rotation_degrees += rot_speed
	if Input.is_action_just_pressed("shoot"):
		shoot()
		#var rot = global_position.angle_to_point(target_pos) - PI/2
		#bullet.shoot(global_position + nose.rotated(rot), rot, velocity)
	return dir.rotated(rotation)

func shoot():
	Effects = get_node_or_null("/root/Game/Effects")
	if Effects != null:
		var bullet = Bullet.instance()
		Effects.add_child(bullet)
		bullet.rotation = rotation
		bullet.global_position = global_position + nose.rotated(rotation)
		
	
func damage(d):
	health -= d
	if health <= 0:
		Effects = get_node_or_null("/root/Game/Effects")
		if Effects != null:
			var explosion = Explosion.instance()
			explosion.global_position = global_position
			Effects.add_child(explosion)
		Global.update_lives(-1)
		queue_free()


func _on_Area2D_body_entered(body):
	if body.name != "Player":
			if body.has_method("damage"):
				body.damage(100)
			damage(100)
