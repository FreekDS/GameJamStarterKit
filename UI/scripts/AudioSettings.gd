extends Control

var SingleBusVolumeSlider : PackedScene = preload("res://UI/helperScenes/SingleBusVolumeSlider.tscn")
@onready var all_volume_sliders = %AllVolumeSliders

# TODO maybe separate container layout into separate scene?

func _ready():
	for busIdx in range(0, AudioServer.bus_count):
		var slider = SingleBusVolumeSlider.instantiate()
		all_volume_sliders.add_child(slider)
		slider.busId = busIdx
