extends KinematicBody

signal update_item_name
signal rumble

var rotation_x: float = 0.0
var rotation_y: float = 0.0
var move_speed: float = 5.0
var mouse_sensitivity: float = 0.2
var capture_mouse: bool = true
var ray_cast_object: StaticBody = null
var ray_cast: RayCast = null
var hit_indi = null
var ray_cast_hit: Vector3 = Vector3(0.0, -42.0, 0.0)
var picked_up_object: Node = null

onready var cup = load("res://CoffeeCup.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#$RayCast.enabled = true
	ray_cast = $Camera/RayCast
	if ray_cast:
		print("god")
		ray_cast.enabled = true
	else:
		print("bad")
	hit_indi = get_node("../HitIndicator")
	#Camera.current = false
	

func _process(delta):
	var velocity = Vector2(0.0, 0.0)
	if Input.is_action_pressed("forward"):
		velocity.y += 1
	if Input.is_action_pressed("backward"):
		velocity.y -= 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_just_pressed("ui_cancel"):
		capture_mouse = !capture_mouse
		if capture_mouse:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#if Input.is_action_just_pressed("interact"):
		
	
	velocity = velocity.normalized()
	$Camera.rotation.x = deg2rad(rotation_x)
	$Camera.rotation.y = deg2rad(rotation_y)
	var cam_glob_trans = $Camera.global_transform
	var dir = -cam_glob_trans.basis.z * velocity.y + cam_glob_trans.basis.x * velocity.x
	dir.y = 0.0
	dir = dir.normalized()
	move_and_collide(dir * move_speed * delta)

func _input(event):
	if event is InputEventMouseMotion && capture_mouse:
		rotation_y -= mouse_sensitivity * event.relative.x
		rotation_x -= mouse_sensitivity * event.relative.y
	if event is InputEventMouseButton && !event.pressed && event.button_index == 1 && ray_cast_hit.y > 0.0:
		var inst = cup.instance()
		inst.global_transform.origin = ray_cast_hit
		get_node("..").add_child(inst)

func _physics_process(delta):
	ray_cast.set_cast_to(Vector3(0.0, 0.0, -5.0))
	
	if ray_cast.is_colliding():
		#print(ray_cast.get_collider())
		var object = ray_cast.get_collider()
		print(ray_cast.get_collider().get("item_name"))
		emit_signal("update_item_name", true, object.get("item_name"))
		hit_indi.global_transform.origin = ray_cast.get_collision_point()
		ray_cast_hit = ray_cast.get_collision_point()
		#ray_cast_object = object
	else:
		emit_signal("update_item_name", false, "")
		ray_cast_hit.y = -42.0

func handle_mouse_entered():
	print("is entered")