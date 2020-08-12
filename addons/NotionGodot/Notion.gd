tool
extends Node

signal data(data, url)
signal block(id, block, url)

const API_ENDPOINT = 'https://notion-api.splitbee.io/v1'

export(String) var page setget set_page
export(String) var table setget set_table
export(String) var token
export(Array, String) var blocks

func _ready():
	assert(token != null, 'No token given')

func get_page(id = page):
	assert(id != null, 'No page selected')
	if id.begins_with('https://'):
		id = strip_url_to_id(id)
	return do_request('/page/' + id)

func get_table(id = table):
	assert(id != null, 'No table selected')
	if id.begins_with('https://'):
		id = strip_url_to_id(id)
	return do_request('/table/' + id)

func do_request(url):
	var http = HTTPRequest.new()
	var random_id  = randi()
	add_child(http)
	http.connect('request_completed', self, '_on_request_completed', [http, random_id])
	var headers = [
		'Authorization: Bearer ' + token,
		'Pragma: no-cache',
		'Cache-Control: no-cache'
	]
	http.request(API_ENDPOINT + url, headers)
	
	return random_id
	
func id_to_dashed_id(id):
	return id.substr(0, 8) + '-' + id.substr(8, 4) + '-' + id.substr(12, 4) + '-' + id.substr(16, 4) + '-' + id.substr(20)

func strip_url_to_id(url):
	if url.find('/') != -1:
		url = url.split('/', false)[url.split('/', false).size() - 1]

	if url.find('-') != -1 and url.find('-') == url.rfind('-'):
		url = url.split('-')[1]
		
	if url.find('-') == -1:
		url = id_to_dashed_id(url)
	
	return url

func _on_request_completed(result, response_code, headers, body, http, return_id):
	remove_child(http)
	http.queue_free()

	var json_result = JSON.parse(body.get_string_from_utf8())
	if json_result.error != OK:
		printerr('Something went wrong parsing the JSON we got back from Notion')
		return

	var data = json_result.result
	emit_signal('data', data, return_id)
	
	for block in blocks:
		var id
		if block.find('#') == -1:
			id = block
		else:
			id = block.split('#')[1]

		if id.find('-') == -1:
			id = id_to_dashed_id(id)
			
		if data.has(id):
			emit_signal('block', block, data[id], return_id)

func set_page(_page):
	if _page == null or _page == '':
		page = ''
		return

	page = strip_url_to_id(_page)

func set_table(_table):
	if _table == null or _table == '':
		table = ''
		return

	table = strip_url_to_id(_table)

