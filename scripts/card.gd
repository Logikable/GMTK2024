extends Control

@export var name_label: Label
@export var number_label: Label
@export var texture_rect: TextureRect
@export var divider: Panel

const NAME: Dictionary = {
  0: 'Unknown',
  1: 'Uncommon Cube',
  2: 'Rare Cube',
  3: 'Epic Cube',
  4: 'Legendary Cube',
}
const TEXTURE: Dictionary = {
  0: 'Unknown',
  1: "res://assets/5Ijg6wc.png",
  2: "res://assets/AGiIs44.png",
  3: "res://assets/A4hYt9F.png",
  4: "res://assets/2jAEXOC.png",
}

var rarity: int = 0
  
  
func set_rarity(new_rarity: int) -> void:
  rarity = new_rarity
  
  texture_rect.texture = load(TEXTURE[new_rarity])
  name_label.set_text(NAME[new_rarity])
  number_label.set_text(str(2))
  divider.get_theme_stylebox("panel").bg_color = Util.COLOURS[new_rarity]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
