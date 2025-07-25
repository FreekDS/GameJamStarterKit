## Simple state machine
class_name StateMachine
extends Node

var _current : StateBase = null

## On which state the state machine should start
@export var startState : StateBase = null

# TODO: we can also abuse process mode to make sure states are not listening for updates anymore... To be checked if this is desired

func _ready() -> void:
	for child in get_children():
		if child is StateBase:
			setupState(child)
			child.switchState.connect(
				func(to: StateBase): 
					on_state_switch_requested(child, to)
			)
	
	if startState != null:
		forceStateSwitch(startState)


func forceStateSwitch(to: StateBase):
	on_state_switch_requested(_current, to)


## Setup a single state. Override this method in your state machine
## To make sure each state has the required references
func setupState(state: StateBase) -> void:
	state.setup({})
	

## Hook called when a state requested a state change.
## Performs the state switch.
## If custom logic is desired, make sure to also call this base method
func on_state_switch_requested(from: StateBase, to: StateBase):
	if from != null:
		from.exit()
		from.isActive = false
	
	_current = to
	_current.enter()
	_current.isActive = true


func _physics_process(delta: float) -> void:
	if _current and _current.isActive:
		_current.physics_tick(delta)

func _process(delta: float) -> void:
	if _current and _current.isActive:
		_current.process_tick(delta)
