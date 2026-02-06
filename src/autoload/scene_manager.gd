extends Node

func transition_to_map(map_path, spawn_id):
    # 1. 播放黑屏動畫 (可選)

    # 2. 移除 MapContainer 裡的舊地圖
    var container = get_tree().root.get_node("Main/World/MapContainer")
    for child in container.get_children():
        child.queue_free()

    # 3. 載入並實例化新地圖
    var new_map = load(map_path).instantiate()
    container.add_child(new_map)

    # 4. 把 Player 移到新地圖的 Marker 位置
    var player = get_tree().root.get_node("Main/World/Player")
    var spawn_point = new_map.get_node("Markers/" + spawn_id)
    player.global_position = spawn_point.global_position
