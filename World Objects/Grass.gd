extends Node2D

func create_grass_effect_and_destroy():
	var grassEffect = loadAndInstanceScene()#create an instance of it
	grassEffect.global_position = global_position #set pos of effect to position of this node.
	var rootNode = get_tree().current_scene #get the root node to add the effect to the scene.
	rootNode.add_child(grassEffect)

func loadAndInstanceScene():
	var GrassEffect = load("res://Effects/GrassDestroyEffect.tscn") # load the scene			
	return GrassEffect.instance()
 
func _on_Hurtbox_area_entered(area):
	create_grass_effect_and_destroy()
	queue_free()
