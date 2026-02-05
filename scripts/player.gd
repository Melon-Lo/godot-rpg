extends CharacterBody2D

@export var speed = 400
# 4. 初始物品設定 (使用陣列)
var inventory = ["Map", "Old Key"]

@onready var sprite = $AnimatedSprite2D

func _physics_process(_delta):
	# 使用 get_vector 取得方向
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if direction != Vector2.ZERO:
		velocity = direction * speed
		sprite.play("walk")
		sprite.flip_h = direction.x < 0
	else:
		velocity = Vector2.ZERO
		sprite.play("idle")

	# 修正：使用 move_and_slide 處理碰撞，它會自動處理 delta
	move_and_slide()

	# 限制玩家不走出畫面 (選用，通常 RPG 地圖很大不需要這個)
	# position = position.clamp(Vector2.ZERO, get_viewport_rect().size)

# 提供給寶箱呼叫的函數
func add_item(item_name):
	inventory.append(item_name)
	print("獲得了：", item_name)
	print("目前背包：", inventory)
