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

        # We need to create a tween to animate the nodes we're dragging

        # We do this to make sure the node we're dragging scales from its center
        parent.pivot_offset = parent.size/2
        
        # Create the tween
        var tween = create_tween()
        # TODO: Add more tweening to fade out the card when dragging
        #       Everything but the cube should disappear
        #       Cube should also be scaled to match grid

        # Tween the scale value so stuff shrinks a little when you grab it
        tween.tween_property(parent, "scale", Vector2(0.95, 0.95), 0.1).set_trans(Tween.TRANS_ELASTIC)

        # Something is wrong here... Not sure what's going on
        # To repro: Drag a card to the right side of the screen and click+hold it. It does a little jump :(
        # The jump happens even when the card is on the left side of the screen, it's just much smaller
        # If you change the scale tween to be more drastic, the effect is bigger
        

    # We use the release event to scale back stuff after dragging
    else:
      var tween = create_tween()
      tween.tween_property(parent, "scale", Vector2(1, 1), 0.1).set_trans(Tween.TRANS_ELASTIC)
      
      if held:  # I only care if I was the object being held.
        held = false
        released.emit(parent, initial_pos)
  # I wish we could support touchscreen, but this might get too complex.
  #elif event is InputEventScreenTouch:
    #if event.pressed and event.get_index() == 0:
      #self.position = event.get_position()
