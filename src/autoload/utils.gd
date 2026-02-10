extends Node

# 印出目標節點的所有子節點
func debug_print_children(node: Node, depth: int) -> void:
	var indent = ""
	for i in range(depth): indent += "  "
	print(indent, "- ", node.name, " (類型: ", node.get_class(), ")")
	for child in node.get_children():
		debug_print_children(child, depth + 1)

# 取得目標節點的所有 TileMapLayer
func get_all_tilemaplayers(node) -> Array:
	var result = []
	for child in node.get_children():
		if child is TileMapLayer:
			result.append(child)
		result.append_array(get_all_tilemaplayers(child))
	return result
