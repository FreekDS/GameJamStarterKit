extends HBoxContainer

# TODO for audio event player https://docs.godotengine.org/en/stable/tutorials/audio/sync_with_audio.html

# TODO mute button
# TODO persist sound settings

const MAX = 5
const MIN = 0
const INCREMENTS = .001

@onready var hSlider : HSlider = $HSlider
@onready var label = $RichTextLabel

var busId : int :
	set(newId):
		busId = newId
		busName = AudioServer.get_bus_name(newId)
		

var busName : String = "" :
	set(newName):
		busName = newName + ":"
		name = "BUS: " + newName
		label.text = busName
	get:
		return busName.replace(":", "")

func _ready():
	hSlider.min_value = MIN
	hSlider.max_value = MAX
	hSlider.step = INCREMENTS 
	hSlider.value = 1	# TODO persist actual value


func _on_h_slider_value_changed(value: float):
	AudioServer.set_bus_volume_db(busId, linear_to_db(value))
	AudioServer.set_bus_mute(busId, value <= MIN)


func reset():
	AudioServer.set_bus_mute(busId, false)
	AudioServer.set_bus_volume_db(busId, 0)
