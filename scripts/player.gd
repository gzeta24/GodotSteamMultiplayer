extends CharacterBody2D
class_name Player

const SPEED = 100

@onready var anims: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var chat_salida: Label = $Label
@onready var chat_entrada: LineEdit = $CanvasLayer/Control/LineEdit
@onready var chat_text_timer: Timer = $CanvasLayer/Control/LineEdit/Timer

func _enter_tree():
	set_multiplayer_authority(name.to_int())

func _ready():
	if !is_multiplayer_authority():
		chat_entrada.hide()

func _physics_process(delta):
	if !is_multiplayer_authority(): return
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction.normalized() * SPEED
	move_and_slide()

func _process(delta):
	if !is_multiplayer_authority(): return
	if velocity != Vector2.ZERO:
		anims.play("walk")
	else:
		anims.play("idle")
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true

func _on_line_edit_text_submitted(new_text):
	rpc("_set_chat_salida_text", new_text)
	chat_entrada.release_focus()
	chat_entrada.text = ""
	chat_text_timer.start(3)

@rpc("authority", "call_local")
func _set_chat_salida_text(text: String):
	chat_salida.text = text

func _on_timer_timeout():
	rpc("_set_chat_salida_text", "")
