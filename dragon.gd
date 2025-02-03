extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var playdragonanim = 1

func _physics_process(delta):
	if(playdragonanim == 1):
		$funnylilplayer.play("dragonmovement")


func _on_timer_timeout():
	playdragonanim = -playdragonanim
