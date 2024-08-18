extends Node2D

# The parent object is the source of truth.

signal released

var held = false
# Remember where on the object we clicked.
# This is relative to the position of the parent object.
var click_pos : Vector2
# Remember the initial local position. This will let any listeners of the
# signal revert the movement if they so wish.
var initial_pos : Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  self.process_mode = PROCESS_MODE_ALWAYS
  set_process_input(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  if held:
    # Update the position of the parent.
    var mouse_pos = get_viewport().get_mouse_position()
    var parent = self.get_parent()
    parent.position = (mouse_pos - click_pos) / Util.global_scale(parent)


func _input(event) -> void:
  if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
    var parent = self.get_parent()
    if event.pressed:
      # Things are computed using global rather than local position.
      if Util.global_rect(parent).has_point(event.position):
        held = true
        click_pos = event.position - parent.position * Util.global_scale(parent)
        initial_pos = parent.position
    else:     # This was a release event.
      if held:  # I only care if I was the object being held.
        held = false
        released.emit(parent, initial_pos)
  # I wish we could support touchscreen, but this might get too complex.
  #elif event is InputEventScreenTouch:
    #if event.pressed and event.get_index() == 0:
      #self.position = event.get_position()
