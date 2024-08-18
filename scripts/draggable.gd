extends Node2D

# The parent object is the source of truth.

var held = false
# Remember where on the object we clicked.
# This is relative to the position of the parent object.
var click_pos : Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  self.process_mode = PROCESS_MODE_ALWAYS
  set_process_input(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  if held:
    # Update the position of the parent.
    var mouse_pos = get_viewport().get_mouse_position()
    self.get_parent().position = mouse_pos - click_pos


func _input(event) -> void:
  if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
    if event.pressed:
      # Things are computed using global rather than local position.
      var parent = self.get_parent()
      var global_parent_rect = Rect2(parent.global_position, parent.size * parent.scale)
      if global_parent_rect.has_point(event.position):
        held = true
        click_pos = event.position - self.get_parent().position
    else:
      held = false
  elif event is InputEventScreenTouch:
    if event.pressed and event.get_index() == 0:
      self.position = event.get_position()
