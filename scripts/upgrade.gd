extends Control

@export var name_label: Label
@export var count_label: Label
@export var upgrade_icon: TextureRect
@export var button: Button
@export var cost_label: Label

var id: float
var DISABLED_COLOUR = Color.html('#6b717e')
var ENABLED_COLOUR = Color.html('#343840')

func set_tooltip(tooltip: String, count: int) -> void:
  button.tooltip_text = tooltip + '\n\n' + 'Click to buy'

func set_values(name: String, cost: int) -> void:
  name_label.text = name
  cost_label.text = str(cost)

func set_upgrade_count(upgrade_count: int) -> void:
    count_label.set_text("| " + str(upgrade_count) + " ")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  var colour: Color = DISABLED_COLOUR if button.disabled else ENABLED_COLOUR
  name_label.set('theme_override_colors/font_color', colour)
  count_label.set('theme_override_colors/font_color', colour)
  cost_label.set('theme_override_colors/font_color', colour)
