extends CanvasLayer

@onready var system_menu = $SystemMenu
@onready var sidebar = $SystemMenu/HBoxContainer/SideBar
@onready var tab_container = $SystemMenu/HBoxContainer/TabContainer
@onready var menu_button = $MenuButton

# 顯示/隱藏系統選單
func _input(event):
	# 切換系統選單
	if event.is_action_pressed("toggle_menu"):
		menu_button.button_pressed = !menu_button.button_pressed
		toggle_system_menu()

	# 如果選單是打開的話，切換標籤
	if system_menu.visible:
		for i in range(1, 7):
			if event.is_action_pressed("switch_tab_" + str(i)):
				change_tab(i - 1)

# 切換選單顯示 / 隱藏
func toggle_system_menu():
	system_menu.visible = !system_menu.visible
	menu_button.button_pressed = system_menu.visible

	# 開啟時切換到第一個標籤
	if system_menu.visible:
		change_tab(0)

# 切換標籤
func change_tab(index: int):
	if index < tab_container.get_child_count():
		tab_container.current_tab = index

		# 選擇對應的按鈕
		var buttons = sidebar.get_children()
		if index < buttons.size():
			buttons[index].button_pressed = true
