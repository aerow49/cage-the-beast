class_name Level
extends Node3D

@export var nextLevel:Resource
@export var player:Player

var cageList:Array
var numCagedBeasts:int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	cageList = get_tree().get_nodes_in_group('cage')
	for cage in cageList:
		cage.cagedBeast.connect(beastCaged)
	var beastList = get_tree().get_nodes_in_group('beast')
	for beast in beastList:
		beast.player = player
		beast.killedPlayer.connect(playerKilled)

func beastCaged():
	numCagedBeasts = numCagedBeasts + 1
	if numCagedBeasts == cageList.size():
		player.kill()
		$ResultsScreen.win(nextLevel)

func playerKilled():
	player.kill()
	$ResultsScreen.lost()

func _on_nex_level_timer_timeout():
	get_tree().change_scene_to_packed(nextLevel)
