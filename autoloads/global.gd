extends Node


const SAVE_FILE := "user://savefile.dat"


var zip_files := [false, false, false, false, false]   #defaults
var data := {}
var in_combat = 0


func _ready() -> void:
	load_data()
	print(zip_files)


func save_data():
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	data = {
			"file1" = zip_files[0],
			"file2" = zip_files[1],
			"file3" = zip_files[2],
			"file4" = zip_files[3],
			"file5" = zip_files[4]
	}
	file.store_var(data)
	file = null


func load_data():
	if not FileAccess.file_exists(SAVE_FILE):
		data = {
				"file1" = false,
				"file2" = false,
				"file3" = false,
				"file4" = false,
				"file5" = false
		}
		save_data()
	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	data = file.get_var()
	
	var i = 0
	for key in data:
		zip_files[i] = data[key]
		i += 1
	file = null


func add_zip_file(index):
	if index >= 1 and index <= 5: 
		zip_files[index-1] = true
		print(zip_files[index-1])
		save_data()
