extends Node


const save_path : String = 'user://cubie.save'


func save(data : Dictionary) -> void:
  var save_file = FileAccess.open(save_path, FileAccess.WRITE)
  var json_string : String = JSON.stringify(data)
  save_file.store_line(json_string)


func can_load() -> bool:
  return FileAccess.file_exists(save_path)


func load() -> Dictionary:
  assert(can_load())
  var save_file = FileAccess.open(save_path, FileAccess.READ)
  var json_string : String = save_file.get_line()

  var json = JSON.new()
  var parse_result = json.parse(json_string)
  if parse_result != OK:
    print('JSON Parse Error: ', json.get_error_message(), " in ", json_string)
    get_tree().quit()
  return json.get_data()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
