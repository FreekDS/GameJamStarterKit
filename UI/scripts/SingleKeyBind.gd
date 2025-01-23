class_name SingleKeyBind
extends HBoxContainer

const ERR_COLOR = "[color=red]"
const DISABLED_COLOR = "[color=black]"

signal listeningForinput
signal keyChanged(from: String, to: String)

@onready var button = $Button
@onready var listening = $listening
@onready var label = $Label

var keyCode : int :
	set(newKeyCode):
		keyName = OS.get_keycode_string(newKeyCode)
		keyCode = newKeyCode

var theEvent : InputEvent

var keyName : String :
	set(newName):
		button.text = newName
		keyName = newName
		name = "Keybind: " + keyName
	get:
		return button.text

var actionName : String :
	set(newName):
		actionName = newName
		var parsed = ""
		for ch in newName:
			if ch == ch.to_upper():
				parsed += " "
			parsed += ch
		
		newName = parsed.replace("_", " ")
		label.text = newName.capitalize()
	get:
		return actionName

# TODO: mouse clicks should have different button ofc :D
# TODO: how are we going to represent mouse clicks? Via enum values < 0?
# TODO: probably better to use the Godot defined enums though...

func _ready():
	set_process_input(false)


func setEnabled(enabled: bool):
	button.disabled = not enabled
	if enabled:
		label.text = str(label.text).replace(DISABLED_COLOR, "")
	else:
		var errorIndex = str(label.text).find(ERR_COLOR)
		if errorIndex != -1:
			label.text = label.text.insert(errorIndex + len(ERR_COLOR), DISABLED_COLOR)
		else:
			label.text = DISABLED_COLOR + label.text


func setError(errored: bool):
	if errored:
		label.text = ERR_COLOR + label.text
	else:
		label.text = str(label.text).replace(ERR_COLOR, "")


func isInvalid():
	return label.text.contains(ERR_COLOR)


func _on_key_button_pressed():
	listeningForinput.emit()
	listening.visible = true
	button.disabled = true
	set_process_input(true)


func _input(event):
	if event is InputEventKey and event.is_pressed():
		var newKey = event.physical_keycode
		var oldKey = keyCode
		keyCode = newKey
		theEvent = event
		keyChanged.emit(oldKey, newKey)
		set_process_input(false)
		listening.visible = false
		button.disabled = false
