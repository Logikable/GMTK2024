extends Control

@export var name_label: Label
@export var texture_rect: TextureRect
@export var divider: Panel
@export var header_panel: Panel

var rarity: int = 0

func set_rarity(new_rarity: int) -> void:
  rarity = new_rarity
  texture_rect.texture = load(Util.TEXTURE[new_rarity])
  name_label.set_text(Util.NAME[new_rarity])
  divider.get_theme_stylebox("panel").bg_color = Util.COLOURS[new_rarity]
  texture_rect.get_parent().tooltip_text = ""


func _make_custom_tooltip(for_text):
  var tooltip = preload("res://scenes/tooltip.tscn").instantiate()
  tooltip.get_node("MarginContainer/BodyText").text = for_text
  return tooltip  


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  texture_rect.tooltip_text = Util.CUBIE_TOOLTIPS[rarity]
  header_panel.tooltip_text = Util.CUBIE_TOOLTIPS[rarity]
  pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
