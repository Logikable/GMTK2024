extends PanelContainer

@export var texture_rect: Node
@export var white_cubie: Texture2D
@export var green_cubie: Texture2D
@export var blue_cubie: Texture2D
@export var purple_cubie: Texture2D
@export var orange_cubie: Texture2D
@export var red_cubie: Texture2D

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var speed: float
var rotation_speed: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  # Give it a colour :)
  var TEXTURES: Array = [white_cubie, green_cubie, blue_cubie, purple_cubie, red_cubie]
  var rng_texture_idx: int = rng.randi_range(0, len(TEXTURES) - 1)
  texture_rect.texture = TEXTURES[rng_texture_idx]

  # Set motion.
  speed = rng.randi_range(300, 500)
  rotation_speed = rng.randi_range(-100, 100)

  var rng_scale: float = rng.randf_range(0.1, 0.3)
  self.scale = Vector2(rng_scale, rng_scale)
  self.position = Vector2(185, rng.randf_range(-350, 400))
  self.rotation_degrees = rotation_speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  self.position += Vector2(-1.0, 0) * speed * delta
  self.rotation_degrees += rotation_speed * delta

  # Delete nodes once they're no longer visible
  if self.position[0] < -410:
    Util.delete_node(self)

  #rotation_degrees += 
