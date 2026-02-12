extends Button

var item_data  # 儲存該格子的物品資料

func setup(data):
	item_data = data
	$Icon.texture = load("res://assets/images/objects/" + data.icon)
	$Name.text = data.name
	$Amount.text = str(data.amount)
