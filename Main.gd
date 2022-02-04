extends MarginContainer

onready var label = $PanelContainer/VBoxContainer/Label
onready var size_edit: LineEdit = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/SizeEdit
onready var min_edit: LineEdit = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer2/MinEdit
onready var median_edit: LineEdit = $PanelContainer/VBoxContainer/HBoxContainer2/VBoxContainer/MedianEdit
onready var max_edit: LineEdit = $PanelContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/MaxEdit
onready var average_edit: LineEdit = $PanelContainer/VBoxContainer/HBoxContainer3/VBoxContainer/AverageEdit
onready var inv_nums_edit: LineEdit = $PanelContainer/VBoxContainer/HBoxContainer3/VBoxContainer2/InvNumEdit
onready var sort: MenuButton = $PanelContainer/VBoxContainer/HBoxContainer4/Sort

func _ready():
	# warning-ignore:return_value_discarded
	sort.get_popup().connect("id_pressed", self, "_on_Sort_pressed")

var prev_size_text := ""
func _on_SizeEdit_text_changed(new_text: String):
	if new_text.is_valid_integer() or new_text.empty():
		prev_size_text = new_text
	else:
		size_edit.text = prev_size_text
		size_edit.caret_position = new_text.length()

var prev_min_text := ""
func _on_MinEdit_text_changed(new_text: String):
	if new_text.is_valid_integer() or new_text.empty() or new_text == "-":
		prev_min_text = new_text
	else:
		min_edit.text = prev_min_text
		min_edit.caret_position = new_text.length()

var prev_max_text := ""
func _on_MaxEdit_text_changed(new_text: String):
	if new_text.is_valid_integer() or new_text.empty() or new_text == "-":
		prev_max_text = new_text
	else:
		max_edit.text = prev_max_text
		max_edit.caret_position = new_text.length()

var prev_med_text := ""
func _on_MedianEdit_text_changed(new_text: String):
	if new_text.is_valid_float() or new_text.empty() or new_text == "-":
		prev_med_text = new_text
	else:
		median_edit.text = prev_med_text
		median_edit.caret_position = new_text.length()

var prev_avrg_text := ""
func _on_AverageEdit_text_changed(new_text: String):
	if new_text.is_valid_float() or new_text.empty() or new_text == "-":
		prev_avrg_text = new_text
	else:
		average_edit.text = prev_avrg_text
		average_edit.caret_position = new_text.length()

var prev_inv_nums_text := ""
func _on_InvNumEdit_text_changed(new_text: String):
	var ar: PoolStringArray = new_text.split(" ")

	for string in ar:
		if not string.is_valid_integer() and not string.empty() and not string == "-":
			inv_nums_edit.text = prev_inv_nums_text
			inv_nums_edit.caret_position = new_text.length()
			return

	prev_inv_nums_text = new_text


func _on_Clear_pressed():
	for edit in [size_edit, min_edit, median_edit, max_edit, average_edit, inv_nums_edit]:
		edit.clear()
	label.text = ""
	ListGenerator.clear()

func _on_Generate_pressed():
	if size_edit.text:
		ListGenerator.size = int(size_edit.text)
	else:
		ListGenerator.size = ListGenerator.DEFAULT_SIZE

	if min_edit.text:
		ListGenerator.minimum = int(min_edit.text)
	else:
		ListGenerator.minimum = ListGenerator.DEFAULT_MIN

	if max_edit.text:
		ListGenerator.maximum = int(max_edit.text)
	else:
		ListGenerator.maximum = ListGenerator.DEFAULT_MAX

	if median_edit.text:
		ListGenerator.median = float(median_edit.text)
	else:
		ListGenerator.median = ListGenerator.DEFAULT_MEDIAN

	if average_edit.text:
		ListGenerator.average = float(average_edit.text)
	else:
		ListGenerator.average = ListGenerator.DEFAULT_AVERAGE

	if inv_nums_edit.text:
		var invalid = inv_nums_edit.text.split(" ")
		for string in invalid:
			if string.is_valid_integer():
				ListGenerator.invalid_nums.append(int(string))
	else:
		ListGenerator.invalid_nums = ListGenerator.DEFAULT_INVALID_NUMS

	ListGenerator.create_array()
	_show_array()

func _show_array() -> void:
	var arr = ListGenerator.get_all().get("array", "")
	arr = String(arr)
	arr = arr.replace("[", "")
	arr = arr.replace("]", "")
	arr = arr.replace(",", " ")

	label.text = arr


func _on_Copy_pressed():
	OS.clipboard = label.text

func _on_Sort_pressed(id: int):
	if not ListGenerator.array:
		return

	var tmp = sort.get_popup().get_item_text(id)
	match sort.get_popup().get_item_text(id):
		"Ascending":
			ListGenerator.sort_ascending()
		"Descending":
			ListGenerator.sort_descending()
		"Random":
			ListGenerator.sort_random()

	_show_array()
