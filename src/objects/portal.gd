extends Area2D

@export_file("*.tscn") var target_map_path: String # 在 Inspector 選擇要切換的地圖
@export var target_spawn_id: String               # 目標地圖的重生點名稱
@export var require_input: bool = false            # 是否需要按下空白鍵切換地圖

var player_in_range = false
var is_teleporting = false

func teleport() -> void:
	if is_teleporting:
		return

	if target_map_path != "":
		player_in_range = false
		is_teleporting = true
		SceneManager.call_deferred("change_map", target_map_path, target_spawn_id)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"): # 記得把 Player 加入 "Player" 群組
		player_in_range = true

		# 如果不需要按按鍵，則直接傳送
		if not require_input:
			teleport()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_range = false

func _input(event: InputEvent) -> void:
	# 判斷：如果需要按鍵 + 玩家在範圍內 + 按下空白鍵
	# ui_accept 預設含空白鍵
	if require_input and player_in_range and event.is_action_pressed("ui_accept"):
		teleport()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta: float) -> void:
# 	pass
