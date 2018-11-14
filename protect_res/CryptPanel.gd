tool
extends Panel
#
signal select_file(file);
#
var egineplugin;
var pngs = [];
var found = 0;
var crypt = 0;
var thread_load;
var thread_crypt;
var scan = 0;
#




func _enter_tree():
	
	name = "Protect Res"
	
	$HBoxContainer/VBoxContainer/btn_scan_png.connect("pressed", self, "_scan", ["res://", true, "png"]);
	$HBoxContainer/VBoxContainer/btn_scan_gnp.connect("pressed", self, "_scan", ["res://", true, "gnp"]);
	$HBoxContainer/VBoxContainer/btn_crypt_current.connect("pressed", self, "_current_crypt");
	
	
	
#

func _current_crypt():
	
	print("select file")
	
	var fileview = FileDialog.new();
	
	
	egineplugin.add_child(fileview);
	fileview.rect_size = Vector2(600,400);
	
	fileview.show_modal();
	
	
	
	

func _process(delta):
	
	$HBoxContainer/VBoxContainer/HBoxContainer/lbl_found.text = str($HBoxContainer/ScrollContainer/VBoxContainer.get_child_count());
	
	
	if(thread_load != null):
		$HBoxContainer/VBoxContainer/btn_scan_gnp.disabled =  scan;
		$HBoxContainer/VBoxContainer/btn_scan_png.disabled =  scan
#	

func _scan(path, root ,type):
	
	for e in $HBoxContainer/ScrollContainer/VBoxContainer.get_children():
		
		e.disconnect("pressed", self,"_crypt");
		e.queue_free();
		
	
	scan = 1;
	
	print("ProtectRes:Scan");
	found = 0;
	pngs = [];
	
	thread_load = null;
	thread_load = Thread.new();
	thread_load.start(self, "thr_scan", [path, root, type]);
	
#

func thr_scan(vars):
	
	var dir = Directory.new();
	
	
	dir.open(vars[0]);
	
	dir.list_dir_begin(true, true);
	
	while(true):
		
		var file = dir.get_next();
		
		if(file == ""):
			break;
		
		elif(dir.dir_exists(vars[0] + file)):
			
			thr_scan([vars[0] + file + "/",false, vars[2]]);
			
		elif(file.ends_with("."+vars[2])):
			
			pngs.append(vars[0] + file);
			#found +=1;
			
			var lbl = Button.new();
			lbl.text = vars[0] + file;
			lbl.connect("pressed", self,"_crypt", [vars[0] + file, lbl, vars[2] == "png"]);
			$HBoxContainer/ScrollContainer/VBoxContainer.call_deferred("add_child", lbl);
			
		
		
	
	dir.list_dir_end();
	
	if(vars[1]):
		scan = 0;
		
		if($HBoxContainer/ScrollContainer/VBoxContainer.get_child_count() > 0):
			
			pass
			
		else:
			
			$HBoxContainer/VBoxContainer/btn_crypt.hide();
			$HBoxContainer/VBoxContainer/btn_de_crypt.hide();
			
		
	

func _crypt(path, this, crypt):
	
	if(crypt):
		var in_file = File.new();
		var out_file = File.new();
		
		in_file.open(path, File.READ);
		out_file.open(path.get_basename() + ".gnp", File.WRITE);
		
		var data  = in_file.get_buffer(in_file.get_len());
		data.invert();
		
		out_file.store_buffer(data);
		
		in_file.close();
		out_file.close();
		
		this.disconnect("pressed", self,"_crypt");
		this.get_parent().call_deferred("remove_child", this);
		
		var dir = Directory.new();
		
		if(!dir.dir_exists("res://.protectres" + path.get_base_dir().replace("res:/", ""))):
			
			dir.make_dir_recursive("res://.protectres" + path.get_base_dir().replace("res:/", ""));
			
		
		dir.copy(path, "res://.protectres" + path.replace("res:/", ""));
		
		dir.remove(path);
		
	else:
		
		this.disconnect("pressed", self,"_crypt");
		this.get_parent().call_deferred("remove_child", this);
		
		var dir = Directory.new();
		dir.copy("res://.protectres" + path.get_basename().replace("res:/", "")+".png", path.get_basename() + ".png");
		dir.remove(path);
		
	
	var engine = get_tree().get_nodes_in_group("IS.ProtectRes")[0];
	
	engine.get_editor_interface().get_resource_filesystem().scan();
	

func _exit_tree():
	
	
	
	$HBoxContainer/VBoxContainer/btn_scan_png.disconnect("pressed", self, "_scan");
	$HBoxContainer/VBoxContainer/btn_scan_gnp.disconnect("pressed", self, "_scan");
	#$VBoxContainer/btn_crypt.disconnect("pressed", self, "_crypt");
	$HBoxContainer/VBoxContainer/btn_crypt_current.disconnect("pressed", self, "_current_crypt");