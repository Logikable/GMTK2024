extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass


func _input(event) -> void:
  if event is InputEventMouseMotion:
    text = str(event.position)
