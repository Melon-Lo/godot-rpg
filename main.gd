extends Node2D

func _ready() -> void:
	# 載入並生成地圖
	var map_scene = load("res://src/maps/forest/forest.tscn")
	var map_instance = map_scene.instantiate()
	$World/MapContainer.add_child(map_instance)

	# 找到地圖裡的出生點標記
	# 路徑對應 forest.tscn 裡的節點層級
	var spawn_point = map_instance.get_node("EntrySpawn")

	# 將玩家的位置設為出生點的位置
	if spawn_point:
		$World/Player.global_position = spawn_point.global_position

	# 設定 Camera
	$World/Player.setup_camera_limits()

# func _process(delta: float) -> void:
# 	pass
