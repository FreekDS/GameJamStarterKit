class_name DialogBox
extends PanelContainer

@export var timeToComplete := 3.0
@export var clearOnAdvance := true

@onready var Animations = $AnimationPlayer
@onready var Content = $MarginContainer/Content

@onready var Cursor = $Cursor

signal advance
signal textCompletelyVisible

var played = false


func setText(text: String):
	Content.visible_ratio = 0
	Content.text = text


func _ready():
	Content.visible_ratio = 0
	play()


func play():
	Animations.play("RESET")
	await Animations.animation_finished
	played = true
	Animations.play("playText", -1, 1.0 / timeToComplete)


func _input(event):
	if event.is_action_pressed("ui_accept"):
		if Animations.is_playing():
			Cursor.visible = true
			Animations.stop()
			var makeVisible = func(): Content.visible_ratio = 1
			makeVisible.call_deferred()
			textCompletelyVisible.emit()
		elif played:
			advance.emit()
			if clearOnAdvance:
				Content.visible_ratio = 0
			played = false
			Cursor.visible = false


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "RESET": return
	Cursor.visible = true
	textCompletelyVisible.emit()
