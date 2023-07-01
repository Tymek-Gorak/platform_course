extends CharacterBody2D

@export var movement_data : PlayerMovementData

var air_jump := false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var coyote_jump_timer = $CoyoteJumpTimer
@onready var wall_jump_buffer_timer = $WallJumpBufferTimer
@onready var starting_position = global_position
@onready var wall_jump_coyotee_timer = $WallJumpCoyoteeTimer
@onready var restart_label = %RestartLabel

func _physics_process(delta):
	var input_axis = Input.get_axis("move_left", "move_right")
	
	apply_gravity(delta)
	handle_jump()
	handle_walljump(input_axis)
	handle_acceleration(input_axis, delta)
	handle_friction(input_axis, delta)
	handle_air_resistence(input_axis, delta)

	move_and_slide()
	update_animations(input_axis)
	
	if position.y > 300:
		restart_label.show()
	else:
		restart_label.hide()
	
	if Input.is_action_just_pressed("tp_back"):
		_on_hazard_detector_area_entered(null)

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * movement_data.gravity_scale * delta

func handle_jump():
	if is_on_floor():
		coyote_jump_timer.start()
		air_jump = true
		
	if (is_on_floor() or not coyote_jump_timer.is_stopped()) and velocity.y >= 0:
		if Input.is_action_pressed("jump"):
			velocity.y = movement_data.jump_velocity
	else:
		if Input.is_action_just_released("jump") and velocity.y < movement_data.jump_velocity/3:
			velocity.y = movement_data.jump_velocity/3
		if Input.is_action_just_pressed("jump") and air_jump == true:
			velocity.y = movement_data.jump_velocity * 0.8
			air_jump = false

func handle_walljump(input_axis):
	if Input.is_action_just_pressed("jump") and not is_on_floor():
		wall_jump_buffer_timer.start()
	
	
	
	var wall_normal 
	if is_on_wall_only():
		wall_jump_coyotee_timer.start()
		wall_normal = get_wall_normal()
		if (Input.is_action_just_pressed("jump") or not wall_jump_buffer_timer.is_stopped()) and input_axis != 0:
			velocity.x = movement_data.speed * 2 * wall_normal.x
			velocity.y = movement_data.jump_velocity
			air_jump = true
	
	if not wall_jump_coyotee_timer.is_stopped():
		if wall_normal == null: 
			if Input.is_action_just_pressed("jump") and input_axis != 0:
				velocity.x = movement_data.speed * 2 * sign(input_axis)
				velocity.y = movement_data.jump_velocity
				air_jump = true
	
func handle_acceleration(input_axis, delta):
	if is_on_floor():
		if input_axis:
			velocity.x = move_toward(velocity.x, movement_data.speed * input_axis, movement_data.acceleration * delta)
	else:
		if input_axis:
			velocity.x = move_toward(velocity.x, movement_data.speed * input_axis, movement_data.air_acceleration * delta)
		
		
func handle_friction(input_axis, delta):
	if input_axis == 0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)

func handle_air_resistence(input_axis, delta):
	if input_axis == 0 and not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.air_resistance * delta)
	

func update_animations(input_axis):
	if input_axis != 0:
		animated_sprite_2d.play("run")
		animated_sprite_2d.scale.x = sign(input_axis) 
	else:
		animated_sprite_2d.play("idle")
	
	if not is_on_floor():
		animated_sprite_2d.play("jump")
	


func _on_hazard_detector_area_entered(area):
	position = starting_position


func _on_hazard_detector_body_entered(body):
	_on_hazard_detector_area_entered(null)
