extends CharacterBody2D

@export var speed = 400
# 4. 初始物品設定 (使用陣列)
var inventory = ["Map", "Old Key"]

@onready var sprite = $AnimatedSprite2D

var last_direction = "side"

func _physics_process(_delta):
	# 若正在切換地圖，禁止玩家移動
	if SceneManager.is_transitioning:
		velocity = Vector2.ZERO # 禁用玩家移動
		move_and_slide()
		return

	# 使用 get_vector 取得方向
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if direction != Vector2.ZERO:
		# --- 滑動邏輯開始 ---
		# 嘗試預判移動，如果會撞到，檢查是否可以滑向旁邊
		# var collision = move_and_collide(direction * speed * _delta, true)
		# if collision:
		# 	var normal = collision.get_normal()
		# 	# 取得垂直於碰撞面的滑動方向
        #     # 讓玩家在撞到牆角時，自動補償一個向側邊的力
		# 	direction = direction.slide(normal).normalized()
		# --- 滑動邏輯結束 ---

		velocity = direction * speed

		# 動態切換動畫
		if abs(direction.y) > abs(direction.x):
			# 垂直移動優先
			if direction.y < 0:
				sprite.play("walk_up")
				last_direction = "up"
			else:
				sprite.play("walk_down")
				last_direction = "down"
		else:
			# 水平移動
			sprite.play("walk_side")
			sprite.flip_h = direction.x < 0
			last_direction = "side"
	else:
		# 停止移動
		velocity = Vector2.ZERO

		# 動態切換動畫
		if last_direction == "up":
			sprite.play("idle_up")
		elif last_direction == "down":
			sprite.play("idle_down")
		else:
			sprite.play("idle_side")


	# 修正：使用 move_and_slide 處理碰撞，它會自動處理 delta
	move_and_slide()

	# DEV ONLY: 碰撞偵測
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		# 在輸出視窗印出撞到的對象名稱與座標
		print("撞到了: ", collider.name, " 座標: ", collision.get_position())

# 提供給寶箱呼叫的函數
func add_item(item_name):
	inventory.append(item_name)
	print("獲得了：", item_name)
	print("目前背包：", inventory)
