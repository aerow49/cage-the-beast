class_name Beast
extends CharacterBody3D

signal killedPlayer

@onready var agent:NavigationAgent3D = $NavigationAgent3D
@onready var animation:AnimationPlayer = $Giant/AnimationPlayer

@export var playerKillRange:float = 4.0
@export var speed:float = 3.0
@export var jumpHeight:float = 5.0
@export var gravity:float = 9.8
@export var isStunned:bool = false
@export var isKillingPlayer:bool = false
@export var isCaptured:bool = false


var player:Player
var capturedCoolDown:float = 100

enum State {RUNNING, CHARGING_ATTACK, ATTACKING, STUNNED, IDLE, BONKED}
var state:State = State.RUNNING

func _physics_process(delta):
	match state:
		State.RUNNING:
			var playerPos:Vector3 = player.global_transform.origin
			agent.target_position = playerPos
			var nexPos:Vector3 = agent.get_next_path_position()
			
			velocity = (nexPos - global_transform.origin).normalized() * speed
			animation.speed_scale = speed*0.3
			animation.play('EnemyArmature|EnemyArmature|EnemyArmature|Run')
			look_at(velocity.normalized()*-1 + global_transform.origin)
			if isPlayerInHitRange():
				state = State.CHARGING_ATTACK
			if player.isDead:
				velocity = Vector3.ZERO
				state = State.STUNNED
		State.STUNNED:
			animation.pause()
		State.BONKED:
			velocity = velocity * -7
			$bonkTimer.start()
			state = State.STUNNED
			print('Bonked')
		State.CHARGING_ATTACK:
			animation.play('EnemyArmature|EnemyArmature|EnemyArmature|Attack')
			velocity = Vector3.ZERO
#			animation.speed_scale = 0.7
			if animation.get_current_animation_position() >= 0.3:
				state = State.STUNNED
				$attackTimer.start()
		State.ATTACKING:
			if animation.get_current_animation_position() <= 0.54:
				animation.play()
			else:
				damagePlayer()
				animation.pause()
		State.IDLE:
			look_at(velocity.normalized()*-1 + global_transform.origin)
			animation.play('EnemyArmature|EnemyArmature|EnemyArmature|Idle')
		_:
			printerr('Invalid state: ', state)
	
	
	velocity += Vector3.DOWN*gravity
	move_and_slide()
#	if player != null && !isStunned && !isKillingPlayer && !isCaptured:
#		var playerPos:Vector3 = player.global_transform.origin
#		agent.target_position = playerPos
#		var nexPos:Vector3 = agent.get_next_path_position()
#
#		velocity = (nexPos - global_transform.origin).normalized() * speed
#		look_at(velocity.normalized()*-1 + global_transform.origin)
#		if velocity.length() > 0:
#			animation.speed_scale = speed*0.3
#			animation.play('EnemyArmature|EnemyArmature|EnemyArmature|Run')
#	velocity += Vector3.DOWN*9.8
#	move_and_slide()
#	if global_transform.origin.y <= -1.4:
#		velocity = velocity*Vector3(1,0,1)

func update_target_loc(target:Node3D):
	player = target

func damagePlayer():
	print(global_transform.origin.distance_to(player.global_transform.origin))
	if isPlayerInHitRange():
		state = State.STUNNED
		player.kill()
		print('Killed player')
		emit_signal('killedPlayer')
	else:
		state = State.RUNNING

func capture():
	velocity = Vector3.ZERO
	state = State.IDLE

func bonk():
	if $bonkTimer.is_stopped() && (state != State.CHARGING_ATTACK || !isPlayerInHitRange())&& !player.isDead:
		state = State.BONKED

func _on_bonk_timer_timeout():
	state = State.RUNNING

func _on_attack_timer_timeout():
	state = State.ATTACKING

func isPlayerInHitRange() -> bool:
	return !player.isDead && global_transform.origin.distance_to(player.global_transform.origin) <= playerKillRange
