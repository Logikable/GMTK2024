extends TabContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.

var rng = RandomNumberGenerator.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  if self.get_current_tab() == 0:
    var new_stylebox_tab_selected = self.get_theme_stylebox("tab_selected").duplicate()
    var new_stylebox_panel = self.get_theme_stylebox("panel").duplicate()
    new_stylebox_panel.bg_color = Color.html("fffae0")
    new_stylebox_tab_selected.bg_color = Color.html("fffae0")
    new_stylebox_panel.border_color = Color.html("ffee93")
    new_stylebox_tab_selected.border_color = Color.html("ffee93")
    add_theme_stylebox_override("panel", new_stylebox_panel)
    add_theme_stylebox_override("tab_selected", new_stylebox_tab_selected)
    
  elif self.get_current_tab() == 1:
    var new_stylebox_tab_selected = self.get_theme_stylebox("tab_selected").duplicate()
    var new_stylebox_panel = self.get_theme_stylebox("panel").duplicate()
    new_stylebox_panel.bg_color = Color.html("F4E9FF")
    new_stylebox_tab_selected.bg_color = Color.html("F4E9FF")
    new_stylebox_panel.border_color = Color.html("CB93FF")
    new_stylebox_tab_selected.border_color = Color.html("CB93FF")
    add_theme_stylebox_override("panel", new_stylebox_panel)
    add_theme_stylebox_override("tab_selected", new_stylebox_tab_selected)
  pass
