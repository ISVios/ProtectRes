tool
extends EditorPlugin
#
var decrypt_png;
var crypt_panle;

#
func _enter_tree():
	
	add_to_group("IS.ProtectRes");
	
	print("Enable ProtectRes");
	
	decrypt_png = load("res://addons/protect_res/decrypt.gd").new();
	
	crypt_panle = load("res://addons/protect_res/CryptPanel.tscn").instance();

	crypt_panle.rect_min_size.y = 200;
	
	add_control_to_bottom_panel(crypt_panle, "ProtectRes");
	add_import_plugin(decrypt_png);
	
	
	
	
	
	
	
	
#



func _exit_tree():
	
	print("Disable ProtectRes")
	
	remove_from_group("IS.ProtectRes")
	
	remove_import_plugin(decrypt_png);
	
	remove_control_from_bottom_panel(crypt_panle);
	
	
	
	decrypt_png = null;
	

