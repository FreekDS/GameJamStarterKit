## Load this as autoload to have a visual transition effect
extends CanvasLayer

@onready var anim : AnimationPlayer = $FadeTransition/Animations

signal done(isOpen: bool)

var closed = false

func open():
	anim.play("fade")
	anim.animation_finished.connect(
		func(_file):
			done.emit(true),
		CONNECT_ONE_SHOT
	)
	closed = false

func close():
	anim.play_backwards("fade")
	anim.animation_finished.connect(
		func(_file):
			done.emit(false),
		CONNECT_ONE_SHOT
	)
	closed = true
