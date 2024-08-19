extends Node

enum UpgradeType { CUBIE = 1, ZONE = 2, OTHER = 10 }

# Upgrade IDs are floats. The ordering of the upgrades in the shop are dependent
# on the ID. They're floats so we can arbitrarily insert between any two
# upgrades.
# The hundredths digit is the UpgradeType.
# The ones digit is the ID within that type.
# Any decimal digits are to insert between existing upgrades.
const UPGRADES: Array = [
  {
    'id': 101.0,
    'display_name': 'Buy Uncommon Cube',
    'type': UpgradeType.CUBIE,
    'rarity': 1,
    'icon': Util.TEXTURE[1],
    'unlock_at': 0,
    'initial_cost': 13,
    'cost_scaling': 1.71,
    'tooltip': 'Generates 1 cubie/s.',
  },
  {
    'id': 102.0,
    'display_name': 'Buy Rare Cube',
    'type': UpgradeType.CUBIE,
    'rarity': 2,
    'icon': Util.TEXTURE[2],
    'unlock_at': 250,
    'initial_cost': 750,
    'cost_scaling': 3.25,
    'tooltip': '2x adjacent cubie output.',
  },
  {
    'id': 103.0,
    'display_name': 'Buy Epic Cube',
    'type': UpgradeType.CUBIE,
    'rarity': 3,
    'icon': Util.TEXTURE[3],
    'unlock_at': 75e3,
    'initial_cost': 250e3,
    'cost_scaling': 5.46,
    'tooltip': '1.1x cubie output in a 3x3 radius.',
  },
  {
    'id': 104.0,
    'display_name': 'Buy Legendary Cube',
    'type': UpgradeType.CUBIE,
    'rarity': 4,
    'icon': Util.TEXTURE[4],
    'unlock_at': 500e6,
    'initial_cost': 1500e6,
    'cost_scaling': 17.09,
    'tooltip': 'Every 5 minutes, supercharges all cubes for 10 seconds.',
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
