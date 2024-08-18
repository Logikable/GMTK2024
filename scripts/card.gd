extends Control

@export var card_name: String = "Card Name"
@export var card_number: int = 1
@export var texture_path: String
@export var divider_color: Color

@onready var name_label: Label = $CardContents/Header/Name
@onready var number_label: Label = $CardContents/Header/HeaderPanel/NumberContainer/NumberBG/Number
@onready var texture_rect: TextureRect = $'CardContents/Body/2DCubie/TextureRect'
@onready var divider: Panel = $CardContents/Divider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  set_values("hehe", 2, "res://assets/5Ijg6wc.png", Color.html("#69FF66"))
  self.scale = Vector2(0.45, 0.45)

func set_values(_name: String, _number: int, _path: String, _tint: Color) -> void:
  card_name = _name
  card_number = _number
  texture_path = _path
  divider_color = _tint
  
  texture_rect.texture = load(_path)
  name_label.set_text(_name)
  number_label.set_text(str(_number))
  divider.get_theme_stylebox("panel").bg_color = _tint
  


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
