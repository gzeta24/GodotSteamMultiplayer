extends TextureButton
class_name InventorySlot

func _ready():
	pressed.connect(_on_button_pressed)

func _on_button_pressed():
	pass
