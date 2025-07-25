## Base class for all StateMachine states
class_name StateBase
extends Node

## Populate this dictionary with references to allowed next states.
@export var allowedTransitions : Dictionary[StringName, StateBase]
# TODO: check if there is a better, more strongly typed alternative to this


## Emitted when the state wants to switch to another.
## Each state decides on its own when to transition to the next
@warning_ignore("unused_signal")
signal switchState(oldState: StateBase)


## Set by the state machine when the state is activated.
## WARNING: do not set this yourself!
var isActive := false


## Setup references to required components
@warning_ignore("unused_parameter")
func setup(componentData: Dictionary[StringName, Node]) -> void:
	pass


## Called first when the state becomes active
func enter() -> void:
	pass


## Called before the state is deactivated
func exit() -> void:
	pass

## Hook to determine whether a state transition can happen
## default: true
func isActivatable() -> bool:
	return true


## Called each physics frame if the state is active
@warning_ignore("unused_parameter")
func physics_tick(delta: float) -> void:
	pass

## Called each process frame if the state is active
@warning_ignore("unused_parameter")
func process_tick(delta: float) -> void:
	pass


## Determine if this state is a start state
func isStartState() -> bool:
	return false

## Determine if this state is an end state
func isEndState() -> bool:
	return false
