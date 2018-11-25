tool
extends EditorImportPlugin

enum Presets { PRESET_DEFAULT }

func get_importer_name():
	return "saveres.decrypt"

func get_visible_name():
	return "SaveRes"

func get_recognized_extensions():
	return ["gnp"]

func get_save_extension():
	return "res"

func get_resource_type():
	return "ImageTexture"

func get_preset_count():
	return 1

func get_preset_name(preset):
	match preset:
		0: return "Default"
		_ : return "Unknown"

func get_import_options(preset):
	match preset:
		_: return []

func get_option_visibility(option, options):
	return true

func import(source_file, save_path, options, r_platform_variants, r_gen_files):
	
	var file = File.new()
	var err = file.open(source_file, File.READ)
	if err != OK:
		return err
	
	var data  = file.get_buffer(file.get_len());
	data.invert();
	
	file.close()
	
	var img = Image.new();
	
	if(img.load_png_from_buffer(data) == OK):
		print("ProtectRes: import " + source_file.get_file() + " -> OK")
	
	var t = ImageTexture.new();
	
	t.set_data(img);
	t.create_from_image(img);
	
	
	
	return ResourceSaver.save("%s.%s" % [save_path, get_save_extension()], t)
