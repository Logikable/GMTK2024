extends Control

@export var name_label: Label
@export var count_label: Label
@export var upgrade_icon: TextureRect
@export var button: Button
@export var cost_label: Label

var id: float
const DISABLED_COLOUR = Color(107, 113, 126)
const ENABLED_COLOUR = Color(52, 56, 64)

signal toggled

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

# When the button is disabled we need to change the label colors
func _on_toggle(enabled: bool) -> void:
  var colour: Color = ENABLED_COLOUR if enabled else DISABLED_COLOUR
  name_label.set('theme_override_colors/font_color', colour)
  count_label.set('theme_override_colors/font_color', colour)
  cost_label.set('theme_override_colors/font_color', colour)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
