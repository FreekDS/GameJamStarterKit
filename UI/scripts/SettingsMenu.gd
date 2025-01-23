extends TabContainer


signal closeRequest

func _ready() -> void:
	set_tab_disabled(2, true) # Graphics tab is not working yet

func _on_close_pressed():
	closeRequest.emit()
