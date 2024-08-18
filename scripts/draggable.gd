extends Node2D

# The parent object is the source of truth.

signal released

var held = false
# Remember where the initial click was, using the global coordinate system.
var initial_click_position : Vector2
# Remember the initial local position. This will let any listeners of the
# signal revert the movement if they so wish.
var initial_pos : Vector2
# Remember the initial global scale of the parent.
var initial_scale : Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  self.process_mode = PROCESS_MODE_ALWAYS
  set_process_input(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  if held:
    var mouse_pos : Vector2 = get_viewport().get_mouse_position()
    
    # Update the position.
    var drag_position_delta : Vector2 = (mouse_pos - initial_click_position) / initial_scale
    self.get_parent().position = initial_pos + drag_position_delta


func _input(event) -> void:
  if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
    var parent = self.get_parent()
    
    if event.pressed:
      # Things are computed using global rather than local position.
      if Util.global_rect(parent).has_point(event.position):
        held = true
        # See declaration location at top of file for explanations.
        initial_click_position = event.position
        initial_pos = parent.position
        initial_scale = Util.global_scale(parent)
        # Animate the nodes we're dragging.        
        # TODO: Add more tweening to fade out the card when dragging
        #       Everything but the cube should disappear
        #       Cube should also be scaled to match grid
        var tween : Tween = create_tween()
        # Tween the scale value so stuff shrinks a little when you grab it
        tween.tween_property(parent, "scale", Vector2(0.95, 0.95), 0.1).set_trans(Tween.TRANS_ELASTIC)
        # Have the node scale from its center.
        parent.pivot_offset = parent.size / 2

    # We use the release event to scale back stuff after dragging.
    else:
      # I only care if I was the object being held.
      if held:
        held = false
        # Untween.
        var tween : Tween = create_tween()
        tween.tween_property(parent, "scale", Vector2(1, 1), 0.1).set_trans(Tween.TRANS_ELASTIC)
        released.emit(parent, initial_pos)
  # I wish we could support touchscreen, but this might get too complex.
  #elif event is InputEventScreenTouch:
    #if event.pressed and event.get_index() == 0:
      #self.position = event.get_position()
