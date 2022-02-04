extends Node

const DEFAULT_ARRAY := Array()
const DEFAULT_SIZE := 10
const DEFAULT_MIN := 0
const DEFAULT_MAX := 10
const DEFAULT_MEDIAN := float()
const DEFAULT_AVERAGE := float()
const DEFAULT_INVALID_NUMS := Array()

var array: Array
var size: int
var median: float
var average: float
var minimum: int
var maximum: int
var invalid_nums: Array

func _ready():
	randomize()
	clear()

func clear():
	array = DEFAULT_ARRAY
	median = DEFAULT_MEDIAN
	average = DEFAULT_AVERAGE
	size = DEFAULT_SIZE
	minimum = DEFAULT_MIN
	maximum = DEFAULT_MAX
	invalid_nums = DEFAULT_INVALID_NUMS

func create_array() -> void:

	if not _is_num_possible(average) or not _is_num_possible(median):
		push_warning(
			"_create_array: No array has been created" +
			" because invalid configuration."
			)
		return

	array.clear()

	# Fills up the array to be tweaked later
	while array.size() < size:
		var val = randi() % (maximum + 1 - minimum) + minimum

		if invalid_nums.has(val):
			continue

		array.append(val)

	# Set median
	if median:
		_set_median()

	if average:
		_set_average()

## Returns true if the input can be part of the final created array.
## Otherwise returns false.
func _is_num_possible(num: float) -> bool:
	if num and num > maximum or num < minimum or invalid_nums.has(num):
		return false

	return true

func _set_average() -> void:
	var pos := 0
	var cur_avrg: float = _get_average()

	# List of possible numbers
	var possible_numbers: Array = range(minimum, maximum)
	for inv in invalid_nums:
		while possible_numbers.has(inv):
			possible_numbers.erase(inv)

	# Tweaks the array until the average is the desired average
	while cur_avrg != average:
		var cur_num = array[pos % size]
		possible_numbers.shuffle()

		# Chooses the first possible number that provides
		# an average closer to the desired average
		for pos_num in possible_numbers:
			if pos_num == cur_num:
				continue

			var new_avrg = cur_avrg - (cur_num / size) + (pos_num / size)
			if abs(average - new_avrg) <= abs(average - cur_avrg):
				array[pos % size] = pos_num
				break

		cur_avrg = _get_average()

		# Skips median values
			# If even
		# warning-ignore:integer_division
		if pos % size == size / 2 - 2 and size % 2 == 0:
			pos += 3
		# If odd
		# warning-ignore:integer_division
		elif pos % size == size / 2 - 1 and size % 2 != 0:
			pos += 2
		else:
			pos += 1
func _set_median() -> void:
	if size % 2 != 0:
		# warning-ignore:integer_division
		array[size / 2] = int(median)
	else:
		var limit: int = min(maximum - median, median - minimum)

		var val1 = randi() % (limit + 1) + median
		var val2 = median - (val1 - median)
		while invalid_nums.has(val1) or invalid_nums.has(val2):
			val1 = randi() % (limit + 1) + median
			val2 = median - (val1 - median)

		# warning-ignore:integer_division
		array[size / 2 - 1] = val2
		# warning-ignore:integer_division
		array[size / 2] = val1

#############
## GETTERS ##
#############

## Returns the median of a list
func _get_median() -> float:
	# if even
	if size % 2 == 0:
		# warning-ignore:integer_division
		# warning-ignore:integer_division
		return (array[size / 2 - 1] + array[size / 2]) / 2.0
	# if odd
	else:
		# warning-ignore:integer_division
		return float(array[size / 2])

## Returns the sum of all of the array's elements
func _get_sum() -> int:
	var sum := 0

	for num in array:
		sum += num

	return sum

## Returns the average of all of the array's elements
func _get_average() -> float:
	return float(_get_sum()) / array.size()

## Returns a dictionary of all of the array's proprieties
func get_all() -> Dictionary:
	return {
		"array": array,
		"size": array.size(),
		"min": array.min(),
		"max": array.max(),
		"median": _get_median(),
		"average": _get_average(),
	}

func sort_ascending():
	array.sort_custom(self, "_sort_asc")

func sort_descending():
	array.sort_custom(self, "_sort_asc")
	array.invert()

func sort_random():
	array.shuffle()

# Function used by sort_ascending and sort_ascending
func _sort_asc(a, b):
	if a < b:
		return true
	return false
