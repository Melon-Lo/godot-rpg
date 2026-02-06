extends Area2D

@export_file("*.tscn") var target_map_path: String # 在 Inspector 選擇要切換的地圖
@export var target_spawn_id: String               # 目標地圖的重生點名稱

var player_in_range = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"): # 記得把 Player 加入 "Player" 群組
		player_in_range = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_range = false

# func _input(event: InputEvent) -> void:
	# 判斷：玩家在範圍內 + 按下空白鍵 (ui_accept 預設含空白鍵)
	# if player_in_range and event.is_action_pressed("ui_accept"):
		# 呼叫你的 SceneManager 或 Main 來切換
		# SceneManager.change_map(target_map_path, target_spawn_id)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
