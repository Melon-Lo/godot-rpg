extends Node2D


# 預載入 icon 資源，方便切換
const ICONS = {
    "chat": preload("res://assets/images/ui/chat.png"),
    "open": preload("res://assets/images/ui/chat.png"),
    "teleport": preload("res://assets/images/ui/chat.png")
}

@onready var icon_sprite = $Icon

func _ready() -> void:
    hide()
    scale = Vector2.ZERO # 初始縮放為 0，為了彈出動畫

# 根據 action_type 決定 icon
func update_prompt(action_type: String):
    if ICONS.has(action_type):
        icon_sprite.texture = ICONS[action_type]

# 顯示提示
func show_prompt():
    show()
    var tween = create_tween()
    # 處理縮放和浮動效果
    tween.set_parallel(true)
    tween.tween_property(self, "scale", Vector2.ONE, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
    tween.tween_property(self, "position:y", 0, 0.3).from(10.0) # 從下方往上飄

# 隱藏提示
func hide_prompt():
    var tween = create_tween()
    tween.tween_property(self, "scale", Vector2.ZERO, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
    await tween.finished
    hide()

# func _process(delta: float) -> void:
#     pass
