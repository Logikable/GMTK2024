extends PanelContainer

@export var white_cubie: Texture2D
@export var green_cubie: Texture2D
@export var blue_cubie: Texture2D
@export var purple_cubie: Texture2D
@export var orange_cubie: Texture2D
@export var red_cubie: Texture2D
var rng_speed
var rng_scale
var rng_rotation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  var cubie_textures = [white_cubie, green_cubie, blue_cubie, purple_cubie, red_cubie]
  var rng: RandomNumberGenerator = RandomNumberGenerator.new()
  var width: int = get_viewport().get_visible_rect().size[0]
  var height: int = get_viewport().get_visible_rect().size[1]
  var start_position = Vector2(185, rng.randi_range(-350, 400))
  var rng_texture_idx = rng.randi_range(0, len(cubie_textures)-1)
  $TextureRect.texture = cubie_textures[rng_texture_idx]
  
  rng_speed = rng.randi_range(300, 500)
  rng_scale = rng.randf_range(0.1, 0.3)
  rng_rotation = rng.randi_range(-100, 100)
  
  scale = Vector2(rng_scale, rng_scale)
  position = start_position
  rotation_degrees = rng_rotation

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  position += Vector2(-1.0, 0) * rng_speed * delta
  rotation_degrees += rng_rotation * delta
  #rotation_degrees += 
