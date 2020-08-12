extends Node

var table

func _ready():
	$StaticBody2D/Polygon2D.polygon = $StaticBody2D/CollisionPolygon2D.polygon	
	$Notion.get_page()
	table = $Notion.get_table('https://www.notion.so/4564a0a4d8b847919ad25ef705c097a1?v=9694b8b608634ea4bd802d83cddf0122')

func _on_Notion_block(id, block, _url):
	if id == $Notion.blocks[0]:
		var text = ''
		for piece in block.value.properties.title:
			text += piece[0]

		$UI/RichTextLabel.text = text

func _on_Notion_data(data, return_id):
	print(data)
	if table == return_id:
		print(data)
		for row in data:
			if row.Name == 'Movement speed':
				$Player.movement_speed = int(row.Value)
			if row.Name == 'Button label':
				$UI/Button.text = row.Value
			if row.Name == 'Jumping enabled':
				print(row.Value.to_lower() == 'true')
				$Player.jumping_enabled = row.Value.to_lower() == 'true'

func _on_Button_pressed():
	var url = 'https://notion.so/' + $Notion.page.replace('-', '')
	OS.shell_open(url)
