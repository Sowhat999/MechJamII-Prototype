extends KinematicBody2D

enum States {
	IDLE
	RUNNING
	IN_AIR
}
var current_state = null
var velocity = Vector2.ZERO
var input_vector = Vector2.ZERO
const MAX_SPEED = 800
const ACCELERATION = 200
const FRICTION = 180

func _physics_process(delta):
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector = input_vector.normalized()
	
	if input_vector == Vector2.LEFT:
		$Animations/Idle.flip_h = true
		$Animations/Running.flip_h = true
	elif input_vector == Vector2.RIGHT:
		$Animations/Idle.flip_h = false
		$Animations/Running.flip_h = false
	
	move_and_slide(velocity)
	
	change_state(delta)
	
	if input_vector != Vector2.ZERO:
		velocity += input_vector * ACCELERATION * delta
		velocity = velocity.clamped(MAX_SPEED * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	print(current_state)

	
func change_state(delta):
	if input_vector.x != 0:
		current_state = States.RUNNING
	else:
		current_state = States.IDLE
	
	
	apply_animations()




func apply_animations():
	match current_state:
		States.IDLE:
			$Animations/Idle.visible = true
			$Animations/Running.visible = false
			$Animations/Jumping.visible = false
			$AnimationPlayer.play("Idle")
		States.RUNNING:
			$Animations/Idle.visible = false
			$Animations/Running.visible = true
			$Animations/Jumping.visible = false
			$AnimationPlayer.play("Running")
		States.IN_AIR:
			$Animations/Idle.visible = true
			$Animations/Running.visible = false
			$Animations/Jumping.visible = false
			$AnimationPlayer.stop()
