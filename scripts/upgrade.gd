extends Control

@export var count_label: Label
@export var number_container: Node
@export var upgrade_icon: TextureRect
@export var button: Button

var id: float

func set_upgrade_count(upgrade_count: int) -> void:
  if upgrade_count == 0:
    number_container.visible = false
  else:
    number_container.visible = true
    count_label.set_text(str(upgrade_count))


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
