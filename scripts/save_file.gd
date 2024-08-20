extends Node

const save_path: String = 'user://cubie.save'

var game: Node


func fix_numerical_json_keys(json_obj: Variant) -> Variant:
  if json_obj is Dictionary:
    for key in json_obj:
      json_obj[key] = fix_numerical_json_keys(json_obj[key])
      if key is String:
        if key.is_valid_float():
          json_obj[float(key)] = json_obj[key]
          json_obj.erase(key)
  elif json_obj is Array:
    var new_array: Array = []
    for entry in json_obj:
      new_array.append(fix_numerical_json_keys(entry))
    json_obj = new_array
  return json_obj


func save_to_disk(data: Dictionary) -> void:
  var save_file = FileAccess.open(save_path, FileAccess.WRITE)
  var json_string: String = JSON.stringify(data)
  save_file.store_line(json_string)


func can_load() -> bool:
  if not FileAccess.file_exists(save_path):
    return false
  if load_from_disk().version != game.VERSION:
    return false
  return true


func load_from_disk() -> Dictionary:
  var save_file = FileAccess.open(save_path, FileAccess.READ)
  var json_string: String = save_file.get_line()

  var json = JSON.new()
  var parse_result = json.parse(json_string)
  if parse_result != OK:
    print('JSON Parse Error: ', json.get_error_message(), " in ", json_string)
    get_tree().quit()
  
  var json_dict: Dictionary = json.get_data()
  return fix_numerical_json_keys(json_dict)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  game = get_tree().get_first_node_in_group('game')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
