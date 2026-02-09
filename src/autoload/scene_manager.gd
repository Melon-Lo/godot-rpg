extends Node

var is_transitioning = false # 是否正在切換地圖

func change_map(map_path, spawn_id):
	is_transitioning = true
	await ScreenTransition.fade_out()

	# 取得容器與玩家
	var main = get_tree().root.get_node("Main")
	var container = main.get_node("World/MapContainer")
	var player = main.get_node("World/Player")

	# 移除舊地圖
	for child in container.get_children():
		child.queue_free()

	# 載入並實例化新地圖
	var map_resource = load(map_path)
	if not map_resource:
		print("[ERROR] 找不到地圖檔案: ", map_path)
		return
	var new_map = map_resource.instantiate()
	container.add_child(new_map)

	# 把 Player 移到新地圖的 Marker 位置
	var spawn_point = new_map.find_child(spawn_id)
	if spawn_point:
		player.global_position = spawn_point.global_position
	else:
		print("[ERROR] 找不到重生點: ", spawn_id)
		return

	await ScreenTransition.fade_in()
	is_transitioning = false
