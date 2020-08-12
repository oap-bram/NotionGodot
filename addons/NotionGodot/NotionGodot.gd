tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("Notion", "Node", preload("Notion.gd"), preload("notion_godot_list.svg"))


func _exit_tree():
	remove_custom_type("Notion")
