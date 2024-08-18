extends Node

func global_scale(node: Node) -> Vector2:
  var scale = 1.0
  while node and node.has_method('get_parent'):
    if node.has_method('get_scale'):
      scale *= node.get_scale()
    node = node.get_parent()
  return scale

func global_rect(node: Node) -> Rect2:
  var global_scale = global_scale(node)
  var global_rect = Rect2(node.global_position, node.size * global_scale)
  return global_rect

func delete_node(node: Node) -> void:
  # Godot's version of deleting a node.
  if not node:
    return
  if node.has_method('get_parent') and node.get_parent():
    node.get_parent().remove_child(node)
  node.queue_free()
