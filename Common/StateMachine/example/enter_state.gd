extends StateBase


func enter():
	print("Enter the enter state")
	print(allowedTransitions["WALK"].name)


func _input(event: InputEvent) -> void:
	if not isActive:
		return
	
	if event.is_action_pressed("ui_accept"):
		switchState.emit(
			allowedTransitions.values().pick_random()
		)


func exit():
	print("Exit the enter state")
