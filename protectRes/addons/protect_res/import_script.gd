tool
extends EditorImportPlugin

enum Presets { PRESET_DEFAULT }

func get_importer_name():
	return "demos.sillymaterial"

func get_visible_name():
	return "SaveRes"

func get_recognized_extensions():
	return ["gnp"]

func get_save_extension():
	return "res"

func get_resource_type():
	return "Texture"

func get_preset_count():
	return 1

func get_preset_name(preset):
	match preset:
		PRESET_DEFAULT: return "Default"
		_ : return "Unknown"

func get_import_options(preset):
	match preset:
		PRESET_DEFAULT:
			return [{
					"name": "password",
					"default_value": ""
					}]
		_: return []

func get_option_visibility(option, options):
	return true

func import(source_file, save_path, options, r_platform_variants, r_gen_files):
	
	print("a")
	var file = File.new()
	var err = file.open(source_file, File.READ)
	print(err)
	if err != OK:
		return err
	
	var data = [];
	while(!file.eof_reached()):
		
		data.append(file.get_8()-1);
		
		
	print("b")
	

	file.close()

	var img = Image.new();
	print(img.load_png_from_buffer(PoolByteArray(data)));
	var tex= Texture.new();
	tex

	return ResourceSaver.save("%s.%s" % [save_path, get_save_extension()], img)
