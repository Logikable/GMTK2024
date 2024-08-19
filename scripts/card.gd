extends Control

@export var name_label: Label
@export var number_label: Label
@export var texture_rect: TextureRect
@export var divider: Panel

var rarity: int = 0
  
  
func set_rarity(new_rarity: int) -> void:
  rarity = new_rarity
  
  texture_rect.texture = load(Util.TEXTURE[new_rarity])
  name_label.set_text(Util.NAME[new_rarity])
  #  Commenting this out because we removed alchemy stacks
  #number_label.set_text(str(2))
  divider.get_theme_stylebox("panel").bg_color = Util.COLOURS[new_rarity]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
