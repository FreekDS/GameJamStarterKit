@tool
extends EditorScript


func _run() -> void:
	EditorInterface.popup_node_selector(_tadaa, ["StateMachine"])


static func _tadaa(selected: NodePath):
	if selected.is_empty():
		print_debug("No StateMachine selected")
		return
		
	var tree := EditorInterface.get_edited_scene_root()
	var selectedNode := tree.get_node(selected) as StateMachine
	
	print("digraph G {")
	for child in selectedNode.get_children():
		if child is StateBase:
			print(get_transitions(child))
	print("}")

static func get_transitions(state: StateBase) -> String:
	var res = ""
	
	for reachable in state.allowedTransitions.values():
		res += "\n" + state.name + " -> " + reachable.name
	
	return res
