## Rich text with a simple grow/shrink animation.
class_name RichPopText
extends RichTextLabel

@export_category("Pop animation settings")
@export var targetScale : Vector2 = Vector2(1.2, 1.2)
@export var growDuration : float = .1
@export var shrinkDuration : float = .1
@export_category("")

signal popStart
signal popEnd

var _originalScale : Vector2 = Vector2.ONE

func _ready() -> void:
	_setPivotOffset()
	doPop()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		doPop()

func _process(delta: float) -> void:
	print(get_size())

## Perform the popping animation
func doPop() -> void:
	var popTween = create_tween()
	popTween.tween_property(self, "scale", targetScale, growDuration)
	popTween.chain().tween_property(self, "scale", _originalScale, shrinkDuration)
	popStart.emit()
	popTween.play()
	popTween.finished.connect(
		func(): 
			_setPivotOffset()
			popEnd.emit()
	)
	

## Centers the pivot for nice scaling
func _setPivotOffset() -> void:
	pivot_offset = Vector2(get_content_width(), get_content_height()) / 2.
