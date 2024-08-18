extends Control

@export var upgrade_name: String = "Upgrade Name"
@export var upgrade_count: int = 0
@export var upgrade_icon: String
@export var tooltip: String

@onready var count_label: Label = $UpgradeContainer/NumberContainer/NumberBG/Number
@onready var number_container: MarginContainer = $UpgradeContainer/NumberContainer
@onready var button: Button = $UpgradeContainer/CenterContainer/UpgradeButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  set_values(upgrade_name, upgrade_count, upgrade_icon)
  button.tooltip_text = tooltip

func set_values(_name: String, _number: int, _icon: String) -> void:
  upgrade_name = _name
  upgrade_count = _number
  upgrade_icon = _icon
  
  if upgrade_count == 0:
    number_container.visible = false
    
  count_label.set_text(str(_number))
  button.text = _icon

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
