extends Control


var KeyBindScene = preload("res://UI/helperScenes/SingleKeyBind.tscn")

@onready var KeyBindsContainer : VBoxContainer = %AllKeyBinds
@onready var SaveButton = %SaveButton

@export var StatusLabel : RichTextLabel

# TODO mouse events
# TODO save/reset

func _ready():
	
	for action in InputMap.get_actions():
		
		if action.begins_with("ui_"): # Skip godot specific ones
			continue
		
		# Take the first event only, TODO what if there are multiple options??
		var events = InputMap.action_get_events(action)
		if events.is_empty():
			continue
			
		var event = events[0]
		
		if not event is InputEventKey:
			continue
		
		var newKeyBind = KeyBindScene.instantiate() as SingleKeyBind
		KeyBindsContainer.add_child(newKeyBind)
		
		# Can only be set after adding to scene
		newKeyBind.actionName = action
		newKeyBind.listeningForinput.connect(
			func(): _handle_keybind_listener(action)
		)
		newKeyBind.keyChanged.connect(
			func(from, to): 
				if from != to: SaveButton.disabled = false
				_handle_keybind_changed()
		)
		
		# TODO: We probably do not need to store the key code explictly
		newKeyBind.keyCode = event.physical_keycode
		newKeyBind.theEvent = event


func _handle_keybind_listener(forAction: String):
	for singleKeyBind : SingleKeyBind in KeyBindsContainer.get_children():
		if singleKeyBind.actionName == forAction:
			continue
		singleKeyBind.setEnabled(false)


func _handle_keybind_changed() -> void:
	var bindingsWithNewKey := {}
	for singleKeyBind : SingleKeyBind in KeyBindsContainer.get_children():
		singleKeyBind.setEnabled(true)
		singleKeyBind.setError(false)
		if bindingsWithNewKey.has(singleKeyBind.keyCode):
			bindingsWithNewKey[singleKeyBind.keyCode].append(singleKeyBind)
		else:
			bindingsWithNewKey[singleKeyBind.keyCode] = [singleKeyBind]
	
	for keyCode in bindingsWithNewKey.keys():
		var bindings = bindingsWithNewKey[keyCode]
		if len(bindings) > 1:
			for singleKeyBind : SingleKeyBind in bindings:
				singleKeyBind.setError(true)



func _on_reset_button_pressed():
	InputMap.load_from_project_settings()
	# reload actions
	for singleKeyBind : SingleKeyBind in KeyBindsContainer.get_children():
		singleKeyBind.setEnabled(true)
		singleKeyBind.setError(false)
		
		var events = InputMap.action_get_events(singleKeyBind.actionName)
		if events.is_empty():
			continue
		
		var event = events[0]
		
		if not event is InputEventKey:
			singleKeyBind.queue_free()
			continue
		
		singleKeyBind.keyCode = event.physical_keycode
	
	StatusLabel.text = "Restored default keybinds"
	await get_tree().create_timer(5).timeout
	StatusLabel.text = ""


func _on_save_button_pressed():
	# TODO persist changes on file
	# TODO dont save on error
	for singleKeyBind : SingleKeyBind in KeyBindsContainer.get_children():
		InputMap.action_erase_events(singleKeyBind.actionName)
		InputMap.action_add_event(singleKeyBind.actionName, singleKeyBind.theEvent)
	SaveButton.disabled = true
	SaveButton.release_focus()
	StatusLabel.text = "Saved settings"
	await get_tree().create_timer(5).timeout
	StatusLabel.text = ""



func _on_undo_button_pressed():
	# TODO Implement
	print("Restore unsaved changes")
