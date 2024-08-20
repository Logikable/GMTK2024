extends PanelContainer

@export var text_node: Node


func set_text(text: String) -> void:
  text_node.text = text


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
