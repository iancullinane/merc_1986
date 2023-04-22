extends CharacterBody3D


const SPEED = 3.0
const JUMP_VELOCITY = 4.5
@onready var animation_player = $visuals/player/AnimationPlayer
@onready var visuals = $visuals

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var walking = false

func _ready():
	GameManager.set_npc(self)
	animation_player.set_blend_time("idle", "walk", 0.2)
	animation_player.set_blend_time("walk", "idle" , 0.2)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var direction = (transform.basis * Vector3(0, 0, 0)).normalized()
	# movement logic
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		visuals.look_at(direction + position)
		
		if !walking:
			walking = true
			animation_player.play("walk")
	# standing still
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

		if walking:
			walking = false
			animation_player.play("idle")

	move_and_slide()


func _on_area_3d_body_entered(body):
	print("body entered")
