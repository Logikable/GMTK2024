extends Panel

@export var Tooltip: PackedScene

var rarity: int


func set_colour(new_rarity: int) -> void:
  rarity = new_rarity
  var stylebox = self.get_theme_stylebox('panel').duplicate()
  stylebox.bg_color = Util.COLOURS[new_rarity]
  self.add_theme_stylebox_override('panel', stylebox)


func _make_custom_tooltip(for_text: String) -> Node:
  var tooltip = Tooltip.instantiate()
  tooltip.set_text(for_text)
  return tooltip


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  self.tooltip_text = Util.CUBIE_TOOLTIPS[rarity]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
