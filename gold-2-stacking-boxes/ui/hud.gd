extends Control

@onready var height_number_label: Label = %HeightNumberLabel
@onready var total_stackables_count_label: Label = %TotalStackablesCountLabel


func update_values(height: float, stackable_count: float) -> void:
	height_number_label.text = "%.1f" % height
	total_stackables_count_label.text = "%.d" % stackable_count
