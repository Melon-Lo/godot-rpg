extends Control

@onready var item_grid = $Layout/ContentArea/ItemListScroll/ItemGrid
@onready var item_details = $Layout/ContentArea/ItemDetails

var item_slot_scene = preload("res://src/core/inventory/item_slot.tscn")
var all_items = [] # 儲存所有物品的資料

func _ready() -> void:
	load_data()
	render_items("consumable")

# 載入 JSON 資料
func load_data():
	var file = FileAccess.open("res://data/items.json", FileAccess.READ)
	var json_text = file.get_as_text()
	all_items = JSON.parse_string(json_text)

# 執行渲染
func render_items(filter_type: String):
	# 清除舊有的格子
	for child in item_grid.get_children():
		child.queue_free()

	# 根據類型過濾並產生新格子
	for item in all_items:
		if item.type == filter_type:
			var slot = item_slot_scene.instantiate()
			item_grid.add_child(slot)
			slot.setup(item)

			slot.mouse_entered.connect(_on_item_hovered.bind(item))

# hover 在格子上
func _on_item_hovered(data):
	# 更新圖示
	item_details.get_node("ItemImage").texture = load("res://assets/images/objects/" + data.icon)

	# 更新右側描述欄位
	item_details.get_node("ItemName").text = data.name

	# 判斷是否為消耗品，增加額外屬性顯示
	var effect_text = ""
	if data.has("effect") and !data.effect.is_empty():
		effect_text = "\n[color=yellow]效果: " + str(data.effect) + "[/color]"

	# 更新描述
	item_details.get_node("ItemDescription").text = data.desc + effect_text
