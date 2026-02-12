extends Area2D

@export_file("*.tscn") var target_map_path: String # 在 Inspector 選擇要切換的地圖
@export var target_spawn_id: String               # 目標地圖的重生點名稱
@export var require_input: bool = false            # 是否需要按下空白鍵切換地圖

@onready var prompt = $InteractionPrompt

var is_player_in_range = false
var is_teleporting = false

func _teleport() -> void:
	if is_teleporting:
		return

	if target_map_path != "":
		is_player_in_range = false
		is_teleporting = true
		SceneManager.call_deferred("change_map", target_map_path, target_spawn_id)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"): # 記得把 Player 加入 "Player" 群組
		is_player_in_range = true

		if require_input:
			# 如果需要按鍵，顯示提示
			prompt.show_prompt()
		else:
			# 如果不需要按按鍵，則直接傳送
			_teleport()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_player_in_range = false

		if require_input:
			# 如果需要按鍵，隱藏提示
			prompt.hide_prompt()

func _input(event: InputEvent) -> void:
	# 鍵盤互動邏輯
	if require_input and is_player_in_range and event.is_action_pressed("ui_accept"):
		if _is_player_facing_portal():
			_teleport()

# 滑鼠互動邏輯（點擊 portal 時觸發）
func _on_portal_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	# 判斷是否為滑鼠左鍵點擊
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if is_player_in_range:
			_teleport()

# 是否面對傳送門
func _is_player_facing_portal() -> bool:
	var player = get_tree().get_first_node_in_group("Player")
	if not player: return false

	# 取得玩家的面對方向
	var face_dir = Vector2.ZERO
	if player.last_direction == "up":
		face_dir = Vector2.UP
	elif player.last_direction == "down":
		face_dir = Vector2.DOWN
	elif player.last_direction == "side":
		if player.sprite.flip_h:
			face_dir = Vector2.LEFT
		else:
			face_dir = Vector2.RIGHT

	# 計算玩家到傳送門的方向
	var dir_to_portal = player.global_position.direction_to(global_position)

	# 如果面向與傳送門方向的夾角太大，則不觸發傳送
	return face_dir.dot(dir_to_portal) >= 0.3


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	# 初始化提示內容
	prompt.update_prompt("teleport")

# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta: float) -> void:
# 	pass
