extends Control

@export var count_label: Label
@export var number_container: Node
@export var upgrade_icon: TextureRect
@export var button: Button

var upgrade_name: String = 'Upgrade Name'
var upgrade_count: int = 0
var tooltip: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  if upgrade_count == 0:
    number_container.visible = false
  else:
    number_container.visible = true
    count_label.set_text(str(upgrade_count))
  button.tooltip_text = tooltip


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
