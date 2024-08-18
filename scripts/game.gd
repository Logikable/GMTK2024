extends Control

@export var grid : Node
@export var cps_label : Label
@export var cubies_label : Label

const BASE_CPS : Dictionary = { 0: 0.0, 1: 1.0, 2: 0.0, 3: 0.0, 4: 0.0 }
const BASE_MULT : Dictionary = { 0: 0.0, 1: 1.0, 2: 2.0, 3: 1.1, 4: 0.0 }

var cubies : float = 0
# TODO: yellow cubie supercharges the grid.
var last_supercharge : Time

func _make_custom_tooltip(for_text):
  var tooltip = preload("res://scenes/tooltip.tscn").instantiate()
  tooltip.get_node("MarginContainer/VBoxContainer/BodyText").text = for_text
  return tooltip  

func cubies_per_second() -> float:
  var width = grid.grid_size
  var cubies = len(grid.grid_cubies)
  
  var cps_per_tile : Array[float] = []
  # First, populate with base cps values.
  for idx in cubies:
    var rarity : int = grid.grid_cubies[idx]
    cps_per_tile.append(BASE_CPS[rarity])
  assert(len(cps_per_tile) == cubies)
  # Handle 2x cubies (rarity 2) and 10% cubies (rarity 3)
  for idx in cubies:
    var rarity : int = grid.grid_cubies[idx]
    var coords = Util.index_to_coords(idx, width)
    var affected_region : Array[Vector2]
    match rarity:
      2:
        affected_region = Util.touching()
      3:
        affected_region = Util.around_me(3)
      _:
        continue
    for delta : Vector2 in affected_region:
      var adj_idx = Util.coords_to_index(coords + delta, width)
      if 0 <= adj_idx and adj_idx < cubies:
        cps_per_tile[adj_idx] *= BASE_MULT[rarity]
  return Util.sum(cps_per_tile)


func save_data() -> Dictionary:
  return {
    'cubies': cubies,
    'grid_size': grid.grid_size,
    'grid_cubies': grid.grid_cubies,
  }


func load_data(data : Dictionary) -> void:
  cubies = data.cubies
  grid.set_grid_size(data.grid_size)
  grid.set_grid_cubies(data.grid_cubies)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  grid.set_grid_size(3)
  # Test data only. Use the commented out code for the actual game.
  grid.set_grid_cubies([0, 0, 2, 0, 1, 0, 3, 0, 1])
  #grid.set_grid_cubies([0, 0, 0, 0, -1, 0, 0, 0, 0])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  var cps = cubies_per_second()
  cubies += cps * delta
  # Display CPS with 1 decimal.
  cps_label.text = str(floor(cps * 10.0) / 10.0) + ' cubies/s'
  cubies_label.text = str(floor(cubies)) + ' cubies'


func _on_save_button_pressed() -> void:
  SaveFile.save(save_data())


func _on_load_button_pressed() -> void:
  if SaveFile.can_load():
    load_data(SaveFile.load())
