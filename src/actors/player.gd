extends CharacterBody2D

@export var speed = 400

var inventory = ["Map", "Old Key"]

@onready var sprite = $AnimatedSprite2D
@onready var camera = $Camera2D

var last_direction = "side"

func setup_camera_limits():
	var map_container = get_node("/root/Main/World/MapContainer")

	if not map_container: return

	# 遞迴搜尋所有的 TileMapLayer
	var layers = Utils.get_all_tilemaplayers(map_container)

	if layers.is_empty():
		return

	var total_rect : Rect2i
	var max_area : int = -1
	var biggest_layer : TileMapLayer = null # 最大面積的 TileMapLayer

	for layer in layers:
		# 跳過碰撞層
		if layer.name.to_lower() == "block":
			continue

		var rect = layer.get_used_rect()
		if rect.has_area():
			# 計算當前層的面積 (寬 * 高)
			var current_area = rect.size.x * rect.size.y

			# 如果這層比之前紀錄的還要大，就更新它
			if current_area > max_area:
				max_area = current_area
				total_rect = rect
				biggest_layer = layer

	# 設定相機的邊界為最大面積的 TileMapLayer
	if biggest_layer:
		var tile_size = biggest_layer.tile_set.tile_size
		var map_scale = biggest_layer.scale
		var offset = biggest_layer.global_position

		camera.limit_left = int(offset.x + (total_rect.position.x * tile_size.x * map_scale.x))
		camera.limit_top = int(offset.y + (total_rect.position.y * tile_size.y * map_scale.y))
		camera.limit_right = int(offset.x + (total_rect.end.x * tile_size.x * map_scale.x))
		camera.limit_bottom = int(offset.y + (total_rect.end.y * tile_size.y * map_scale.y))

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

	# [DEV ONLY] 碰撞偵測
	# for i in get_slide_collision_count():
	# 	var collision = get_slide_collision(i)
	# 	var collider = collision.get_collider()

	# 	# 在輸出視窗印出撞到的對象名稱與座標
	# 	print("撞到了: ", collider.name, " 座標: ", collision.get_position())

# 提供給寶箱呼叫的函數
# func add_item(item_name):
# 	inventory.append(item_name)
# 	print("獲得了：", item_name)
# 	print("目前背包：", inventory)

func _ready():
	pass
	# setup_camera_limits()
	# setup_camera_limits.call_deferred()
