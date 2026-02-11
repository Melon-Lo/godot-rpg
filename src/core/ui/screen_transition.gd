extends CanvasLayer

@onready var anim_player = $AnimationPlayer

func _ready() -> void:
	# 遊戲開始時確保是透明的，且不會擋住點擊
	$Overlay.modulate.a = 0
	$Overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE

func fade_out():
	$Overlay.mouse_filter = Control.MOUSE_FILTER_STOP # 禁止點擊
	anim_player.play("fade_to_black")
	await anim_player.animation_finished

func fade_in():
	anim_player.play("fade_to_normal")
	await anim_player.animation_finished
	$Overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE # 恢復點擊
