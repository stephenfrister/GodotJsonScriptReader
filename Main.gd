extends Node2D


var json_path = "res://JsonFilesHere/"

var json_files = [] 
var json_selected = ""

var dialogue_data = []
var dialogue_entry = 0
var dialogue_alt = false


func _ready():
	pass

#func _process(delta):
	#pass

func _on_load_pressed():
	#print_debug("_on_load_pressed...")
	
	# reset things to default values...
	reset_dialogue()
	
	json_files = []  
	json_selected = ""
	
	dialogue_data = []
	
	# do the stuff...
	
	dir_contents( json_path )
	make_files_clickable()
	
	pass

#https://forum.godotengine.org/t/how-i-read-and-show-a-content-of-a-json-file-in-godot-4/2986/2
func _on_select_pressed():
	#print_debug("_on_select_pressed...")
	
	reset_dialogue()
	
	var jfile = json_path + json_selected
	
	var json_as_text = FileAccess.get_file_as_string(jfile)
	dialogue_data = JSON.parse_string(json_as_text)
	
	enable_dialog_controls()
	
	#var json_as_dict = JSON.parse_string(json_as_text)
	
	#if json_as_text:
		#print("json_as_text: ")
		#print(json_as_text)
		
	#if json_as_dict:
		#print("json_as_dict: ")
		#print(json_as_dict)
	
	#print( json_as_dict.size() )
	#print( json_as_dict[0] )
	
	pass

func _on_next_pressed():
	print_debug("_on_next_pressed...")
	
	if dialogue_entry < dialogue_data.size(): 
		dialogue_entry += 1
	
	update_dialogue()
	check_next_and_last()
	
	pass

func _on_last_pressed():
	print_debug("_on_last_pressed...")
	
	dialogue_alt = !dialogue_alt
	
	if dialogue_entry > 0: 
		dialogue_entry -= 1
	
	update_dialogue()
	check_next_and_last()
	
	pass

func _on_json_file_clicked( json_name ): 
	#print_debug("_on_json_file_clicked...")
	
	json_selected = json_name
	$Buttons/Select.disabled = false
	
	pass

func enable_dialog_controls():
	print_debug("enable_dialog_controls...")
	
	$Buttons/Next.disabled = false
	$Info/Data.text = dialogue_data[0]["blockType"]
	$Info/Item.text = "Item[" + str(0) + "]:"
	
	update_dialogue()
	
	pass

func check_next_and_last(): 
	
	if dialogue_entry == 0: 
		$Buttons/Last.disabled = true
	
	if dialogue_entry > 0: 
		$Buttons/Last.disabled = false
	
	if dialogue_entry == dialogue_data.size() - 1: 
		$Buttons/Next.disabled = true
	
	else: 
		$Buttons/Next.disabled = false
	
	pass

func update_dialogue(): 
	print_debug("update_dialog...")
	
	$Info/Data.text = dialogue_data[ dialogue_entry ]["blockType"]
	$Info/Item.text = "Item[" + str(dialogue_entry) + "]:"
	
	if dialogue_data[ dialogue_entry ]["blockType"] == "dialogue":
		return
	
	$Indicate/Arrow1.visible = false
	$Indicate/Arrow2.visible = false
	$Indicate/Arrow3.visible = false
	
	$Dialog/TextBox1.text = "..."
	$Dialog/TextBox2.text = "..."
	var dialogue_next = "..."
	
	if dialogue_data[ dialogue_entry ]["blockType"] == "sceneHeading": 
		$Info/Header.text = dialogue_data[ dialogue_entry ]["text"]
		$Indicate/Arrow1.visible = true
	
	if dialogue_data[ dialogue_entry ]["blockType"] == "character": 
		
		if dialogue_entry+1 < dialogue_data.size(): 
			if dialogue_data[ dialogue_entry+1 ]["blockType"] == "dialogue":
				dialogue_next = dialogue_data[ dialogue_entry+1 ]["text"]
		
		if !dialogue_alt: 
			$Dialog/Name1.text = dialogue_data[ dialogue_entry ]["text"]
			$Dialog/TextBox1.text = dialogue_next
			$Indicate/Arrow2.visible = true
		
		if dialogue_alt: 
			$Dialog/Name2.text = dialogue_data[ dialogue_entry ]["text"]
			$Dialog/TextBox2.text = dialogue_next
			$Indicate/Arrow3.visible = true
		
		dialogue_alt = !dialogue_alt
	
	pass

func reset_dialogue():
	
	dialogue_entry = 0
	
	$Buttons/Select.disabled = true
	$Buttons/Next.disabled = true
	$Buttons/Last.disabled = true
	
	$Indicate/Arrow1.visible = false
	$Indicate/Arrow2.visible = false
	$Indicate/Arrow3.visible = false
	
	$Info/Item.text = "Item[...]:"
	$Info/Data.text = "..."
	$Info/Header.text = "..."
	$Dialog/Name1.text = "..."
	$Dialog/Name2.text = "..."
	$Dialog/TextBox1.text = "..."
	$Dialog/TextBox2.text = "..."
	
	pass

func make_files_clickable(): 
	#print_debug("make_files_clickable...")
	
	# remove any objects previously added to the container 
	for old in $Files/ScrollContainer/MarginContainer/VBoxContainer.get_children(): 
		old.queue_free()
	
	for jf in json_files: 
		
		var new_button = Button.new()
		new_button.text = jf
		new_button.position = Vector2(5,5)
		#new_button.focus_mode = 0
		
		#new_button.connect( "pressed", _on_json_file_clicked, new_button.text )
		new_button.connect( "pressed", _on_json_file_clicked.bind(new_button.text) )
		
		#$Files/ScrollContainer/VBoxContainer.add_child( new_button )
		$Files/ScrollContainer/MarginContainer/VBoxContainer.add_child( new_button )
		
		pass
	
	pass

# https://docs.godotengine.org/en/stable/classes/class_diraccess.html
func dir_contents( path ):
	
	var dir = DirAccess.open( path )
	
	if dir:
		dir.list_dir_begin()
		
		var file_name = dir.get_next()
		
		while file_name != "":
			
			if dir.current_is_dir():
				#print("Found directory: " + file_name)
				
				pass
			
			else:
				#print("Found file: " + file_name)
				json_files.append( file_name )
				
				pass
			
			file_name = dir.get_next()
	
	#else:
		#print("An error occurred when trying to access the path.")
	
	pass











