class_name CageButton
extends Area3D

@export var triggerObject:Cage

# Called when the node enters the scene tree for the first time.
func _ready():
	if triggerObject == null:
		printerr("Button with unset cage: " + name)
		get_tree().quit()

func _on_body_entered(body):
	if body.is_in_group('player'):
		triggerObject.activateCage()
		$AnimationPlayer.play('press')


func _on_body_exited(body):
	if body.is_in_group('player'):
		triggerObject.deactivateCage()
		$AnimationPlayer.play_backwards('press')
