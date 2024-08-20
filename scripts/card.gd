extends Control

@export var cubie: Node
@export var divider: Panel
@export var header_panel: Panel
@export var name_label: Label
@export var texture_rect: TextureRect
@export var Tooltip: PackedScene

var rarity: int = 0


func set_rarity(new_rarity: int) -> void:
  rarity = new_rarity
  texture_rect.texture = load(Util.CUBIE_TEXTURE[new_rarity])
  name_label.set_text(Util.NAME[new_rarity])
  divider.get_theme_stylebox("panel").bg_color = Util.COLOURS[new_rarity]


func _make_custom_tooltip(for_text: String) -> Node:
  var tooltip = Tooltip.instantiate()
  tooltip.set_text(for_text)
  return tooltip


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  texture_rect.tooltip_text = Util.CUBIE_TOOLTIPS[rarity]
  header_panel.tooltip_text = Util.CUBIE_TOOLTIPS[rarity]
  cubie.tooltip_text = ""


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
