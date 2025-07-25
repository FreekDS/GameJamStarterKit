class_name RichFloatyText
extends RichPopText

signal floatEnded

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func startFloat():
	animation_player.play("float")
	await animation_player.animation_finished
	floatEnded.emit()
