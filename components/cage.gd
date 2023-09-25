class_name Cage
extends Node3D

signal cagedBeast

var isBeastCaged:bool = false

func activateCage():
	print('activate')
	$AnimationPlayer.play('capture')
	
func deactivateCage():
	if !isBeastCaged:
		$AnimationPlayer.play_backwards('capture')


func _on_area_3d_body_entered(body):
	print('entered cage')
	if body.is_in_group('beast'):
		isBeastCaged = true
		print('caged the beast')
		body.capture()
		emit_signal('cagedBeast')
