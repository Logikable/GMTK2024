extends Control

@export var button: Button
@export var cost_label: Label
@export var count_label: Label
@export var name_label: Label
@export var upgrade_icon: TextureRect

signal button_disabled

var DISABLED_COLOUR = Color.html('#6b717e')
var ENABLED_COLOUR = Color.html('#343840')

var id: float


func set_tooltip(tooltip: String, count: int) -> void:
  button.tooltip_text = tooltip + '\n\n' + 'Click to buy'


func set_label_name(name: String) -> void:
  name_label.text = name
  

func set_cost(cost: int) -> void:
  cost_label.text = str(cost)


func set_upgrade_count(upgrade_count: int) -> void:
  count_label.set_text("| " + str(upgrade_count) + " ")


func set_button_disabled(disabled: bool) -> void:
  button.disabled = disabled
  # Update the theme.
  var colour: Color = DISABLED_COLOUR if disabled else ENABLED_COLOUR
  name_label.set('theme_override_colors/font_color', colour)
  count_label.set('theme_override_colors/font_color', colour)
  cost_label.set('theme_override_colors/font_color', colour)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
