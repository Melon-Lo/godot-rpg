extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 1. 載入並生成地圖
	var map_scene = load("res://src/maps/forest/forest.tscn")
	var map_instance = map_scene.instantiate()
	$World/MapContainer.add_child(map_instance)

	# 2. 找到地圖裡的出生點標記
	# 注意：路徑要對應你在 forest.tscn 裡的節點層級
	var spawn_point = map_instance.get_node("EntrySpawn")

	# 3. 將玩家的位置設為出生點的位置
	if spawn_point:
		$World/Player.global_position = spawn_point.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
