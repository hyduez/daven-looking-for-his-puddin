extends CharacterBody2D

const SPEED = 100.0
const MAX_JUMP_VELOCITY = -400.0
const MIN_JUMP_VELOCITY = -100.0
const MAX_CHARGE_TIME = 2

var charge_time: float = 0.0
var is_charging: bool = false

var daven_shift = load('res://game/daven_shift.png')
var daven_right = load("res://game/daven_right.png")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		is_charging = true
		charge_time = 0.0
		velocity.x = 0
		$Sprite2D.texture = daven_shift
	
	if is_charging:
		charge_time += delta
		charge_time = min(charge_time, MAX_CHARGE_TIME)
	
	if Input.is_action_just_released("jump") and is_charging:
		is_charging = false
		$Sprite2D.texture = daven_right
		
		var charge_pct = charge_time / MAX_CHARGE_TIME
		
		velocity.y = lerp(MIN_JUMP_VELOCITY, MAX_JUMP_VELOCITY, charge_pct)
		
		var direction = Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = 0
		
		AudioController.play_jump()

	if not is_charging and is_on_floor():
		var direction = Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
			$Sprite2D.flip_h = (direction <  0)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
