extends Control

@export var grid : Node
@export var cps_label : Label
@export var cubies_label : Label

const BASE_CPS : Dictionary = { 0: 0.0, 1: 1.0, 2: 0.0, 3: 0.0 }
const BASE_MULT : Dictionary = { 0: 0.0, 1: 1.0, 2: 2.0, 3: 1.1 }

var cubies : float = 0

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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  grid.set_grid_size(3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  var cps = cubies_per_second()
  cubies += cps * delta
  # Display CPS with 1 decimal.
  cps_label.text = str(floor(cps * 10.0) / 10.0) + ' cubies/s'
  cubies_label.text = str(floor(cubies)) + ' cubies'
