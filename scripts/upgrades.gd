extends Node

const UPGRADES: Array = [
  {
    'id': 101.01,
    'display_name': 'Buy Uncommon Cube',
    'tooltip': 'Generates 1 cubie/s.',
    'icon': Util.TEXTURE[1],
    'unlock_at': 0,
    'initial_cost': 13,
    'cost_scaling': 1.71,
  },
  {
    'id': 102.01,
    'display_name': 'Buy Rare Cube',
    'tooltip': '2x adjacent cubie output.',
    'icon': Util.TEXTURE[2],
    'unlock_at': 250,
    'initial_cost': 750,
    'cost_scaling': 3.25,
  },
  {
    'id': 103.01,
    'display_name': 'Buy Epic Cube',
    'tooltip': '1.1x cubie output in a 3x3 radius.',
    'icon': Util.TEXTURE[3],
    'unlock_at': 75e3,
    'initial_cost': 250e3,
    'cost_scaling': 5.46,
  },
  {
    'id': 104.01,
    'display_name': 'Buy Legendary Cube',
    'tooltip': 'Every 5 minutes, supercharges all cubes for 10 seconds.',
    'icon': Util.TEXTURE[4],
    'unlock_at': 500e6,
    'initial_cost': 1500e6,
    'cost_scaling': 17.09,
  },
]

var UPGRADES_DICT: Dictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  for upgrade in UPGRADES:
    UPGRADES_DICT[upgrade.id] = upgrade


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
