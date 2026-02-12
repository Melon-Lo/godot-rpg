extends CharacterBody2D

@export var speed = 400
@onready var sprite = $AnimatedSprite2D
@onready var camera = $Camera2D
@onready var menu_button = get_node("/root/Main/UIManager/MenuButton")

var target_position = Vector2.ZERO
var is_mouse_moving = false
var last_direction = "side"
var inventory = ["Map", "Old Key"]

# 設定相機的限制
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

# 提供給寶箱呼叫的函數
# func add_item(item_name):
# 	inventory.append(item_name)
# 	print("獲得了：", item_name)
# 	print("目前背包：", inventory)

func _ready():
    # 初始化時，目標就是當前位置，避免角色一開場就亂跑
    target_position = position

func _physics_process(_delta):
    # 若正在切換地圖，禁止玩家移動
    if SceneManager.is_transitioning:
        velocity = Vector2.ZERO # 禁用玩家移動
        move_and_slide()
        return

    # 若正在開啟選單，禁止玩家移動
    var is_menu_pressed = menu_button.button_pressed
    if (is_menu_pressed): return

    # 取得鍵盤輸入
    var keyboard_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

    # 取得滑鼠輸入
    var mouse_direction = Vector2.ZERO

    # 這裡使用 Input.is_mouse_button_pressed 來偵測即時狀態
    # 如果滑鼠 hover 在按鈕上，則不觸發移動
    if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not menu_button.is_hovered():
        var mouse_pos = get_global_mouse_position()
        var distance = global_position.distance_to(mouse_pos)

        if distance > 10: # 稍微提高緩衝距離，避免在游標處反覆抖動
            mouse_direction = (mouse_pos - global_position).normalized()
            is_mouse_moving = true
        else:
            is_mouse_moving = false
    else:
        is_mouse_moving = false

    # 決定最終方向
    var final_direction = Vector2.ZERO

    if keyboard_direction != Vector2.ZERO:
        final_direction = keyboard_direction
    elif is_mouse_moving:
        final_direction = mouse_direction

    if final_direction != Vector2.ZERO:
        # _apply_walk_slide(final_direction, _delta)

        velocity = final_direction * speed

        # 動態切換動畫
        _play_walk(final_direction)

    else:
        # 停止移動
        velocity = Vector2.ZERO

        # 動態切換動畫
        _play_idle()


    # 執行移動
    move_and_slide()

    # [DEV ONLY] 碰撞偵測
    # for i in get_slide_collision_count():
    # 	var collision = get_slide_collision(i)
    # 	var collider = collision.get_collider()

    # 	# 在輸出視窗印出撞到的對象名稱與座標
    # 	print("撞到了: ", collider.name, " 座標: ", collision.get_position())

func _apply_walk_slide(direction: Vector2, delta: float) -> Vector2:
    # 嘗試預判移動，如果會撞到，檢查是否可以滑向旁邊
    var collision = move_and_collide(direction * speed * delta, true)

    if collision:
        var normal = collision.get_normal()
        # 計算滑動後的方向
        var slide_direction = direction.slide(normal).normalized()
        return slide_direction

    return direction # 若沒撞到，維持原方向

# 走路動畫
func _play_walk(dir):
    if abs(dir.y) > abs(dir.x):
        if dir.y < 0:
            sprite.play("walk_up")
            last_direction = "up"
        else:
            sprite.play("walk_down")
            last_direction = "down"
    else:
        sprite.play("walk_side")
        sprite.flip_h = dir.x < 0
        last_direction = "side"

# 待機動畫
func _play_idle():
    if last_direction == "up":
        sprite.play("idle_up")
    elif last_direction == "down":
        sprite.play("idle_down")
    else:
        sprite.play("idle_side")