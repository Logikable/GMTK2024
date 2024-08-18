extends Control

@export var grid: Node
@export var cps_label: Label
@export var cubies_label: Label

const BASE_INITIAL_CUBIE_CLICK = 1.0
const BASE_CPS: Dictionary = { -1: 0.0, 0: 0.0, 1: 1.0, 2: 0.0, 3: 0.0, 4: 0.0 }
const BASE_MULT: Dictionary = { -1: 0.0, 0: 0.0, 1: 1.0, 2: 2.0, 3: 1.1, 4: 0.0 }
const SUPERCHARGE_COOLDOWN: float = 5 * 60.0
const SUPERCHARGE_DURATION: float = 10.0

var cubies: float
var supercharge_cooldown_remaining: float
var supercharge_duration_remaining: float

func _make_custom_tooltip(for_text):
  var tooltip = preload("res://scenes/tooltip.tscn").instantiate()
  tooltip.get_node("MarginContainer/VBoxContainer/BodyText").text = for_text
  return tooltip


# The handling of supercharge is everywhere. It's not pretty.
func maybe_supercharge(v: float) -> float:
  var supercharge_multiplier = 2.0 if (supercharge_duration_remaining > 0.0) else 1.0
  return v * supercharge_multiplier


func initial_cubie_click() -> void:
  var width = grid.grid_size
  var area = len(grid.grid_cubies)

  var cubies_generated = BASE_INITIAL_CUBIE_CLICK
  for idx in area:
    var rarity: int = grid.grid_cubies[idx]
    var affected_region: Array[Vector2] = Util.affected_region(rarity)
    var coords = Util.index_to_coords(idx, width)
    for delta: Vector2 in affected_region:
      var affected_idx = Util.coords_to_index(coords + delta, width)
      if affected_idx == grid.initial_cubie_idx:
        cubies_generated *= maybe_supercharge(BASE_MULT[rarity])
  cubies += floori(cubies_generated)


func cubies_per_second() -> float:
  var width = grid.grid_size
  var area = len(grid.grid_cubies)
  
  var cps_per_tile: Array[float] = []
  # First, populate with base cps values.
  for idx in area:
    var rarity: int = grid.grid_cubies[idx]
    var cps: int = maybe_supercharge(BASE_CPS[rarity])
    cps_per_tile.append(cps)
  assert(len(cps_per_tile) == area)

  # Find and handle multiplicative cubies (rarity 2 and 3).
  for idx in area:
    var rarity: int = grid.grid_cubies[idx]
    var affected_region: Array[Vector2] = Util.affected_region(rarity)
    var coords = Util.index_to_coords(idx, width)
    for delta: Vector2 in affected_region:
      var affected_idx = Util.coords_to_index(coords + delta, width)
      if 0 <= affected_idx and affected_idx < area:
        cps_per_tile[affected_idx] *= maybe_supercharge(BASE_MULT[rarity])
  return Util.sum(cps_per_tile)


func save_data() -> Dictionary:
  return {
    'cubies': cubies,
    'grid_size': grid.grid_size,
    'grid_cubies': grid.grid_cubies,
    'supercharge_cooldown_remaining': supercharge_cooldown_remaining,
    'supercharge_duration_remaining': supercharge_duration_remaining,
  }


func load_data(data: Dictionary) -> void:
  cubies = data.cubies
  grid.set_grid_size(data.grid_size)
  grid.set_grid_cubies(data.grid_cubies)
  supercharge_cooldown_remaining = data.supercharge_cooldown_remaining
  supercharge_duration_remaining = data.supercharge_duration_remaining


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  cubies = 0
  grid.set_grid_size(3)
  # Test data only. Use the commented out code for the actual game.
  grid.set_grid_cubies([0, 2, 4, 2, -1, 3, 0, 0, 0])
  #grid.set_grid_cubies([0, 0, 0, 0, -1, 0, 0, 0, 0])
  supercharge_cooldown_remaining = 0.0
  supercharge_duration_remaining = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  # Update CPS and Cubies counter.
  var cps = cubies_per_second()
  cubies += cps * delta
  # Display CPS with 1 decimal.
  cps_label.text = str(floori(cps * 10.0) / 10.0) + ' cubies/s'
  cubies_label.text = str(floori(cubies)) + ' cubies'
  
  # Handle rarity=4 cubies doing supercharge.
  supercharge_cooldown_remaining = max(0.0, supercharge_cooldown_remaining - delta)
  supercharge_duration_remaining = max(0.0, supercharge_duration_remaining - delta)
  
  if supercharge_cooldown_remaining == 0.0 and grid.grid_cubies.has(4):
    supercharge_cooldown_remaining = SUPERCHARGE_COOLDOWN
    supercharge_duration_remaining = SUPERCHARGE_DURATION


func _on_save_button_pressed() -> void:
  SaveFile.save(save_data())


func _on_load_button_pressed() -> void:
  if SaveFile.can_load():
    load_data(SaveFile.load())
