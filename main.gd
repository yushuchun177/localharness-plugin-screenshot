extends Node
## 截图插件 · local-harness
## 工具：screenshot_capture(name?)
##
## 用 PowerShell + System.Drawing 抓整个虚拟桌面（多显示器也算在内），
## 存到 用户目录/Local-Harness/shots/ 下，返回路径给模型。
## 只截屏、不上传；要"看懂"截图需要装识图插件。

const SHOT_DIR := "user://shots"



func _pref(key: String, def_value):
	var ml := Engine.get_main_loop()
	var prefs = ml.root.get_node_or_null("/root/PluginPrefs") if ml != null else null
	if prefs == null:
		return def_value
	return prefs.get_value("screenshot", key, def_value)

func run(tool: String, args: Dictionary) -> Dictionary:
	if tool != "screenshot_capture":
		return {"ok": false, "output": "未知工具：%s" % tool}
	var prefix := str(args.get("name", "shot"))
	if prefix.strip_edges() == "":
		prefix = "shot"
	prefix = prefix.validate_filename()
	if prefix.length() > 40:
		prefix = prefix.substr(0, 40)

	var base_dir := str(_pref("dir", "")).strip_edges()
	if base_dir == "":
		base_dir = SHOT_DIR
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(base_dir))
	var stamp := Time.get_datetime_string_from_system().replace(":", "-").replace(" ", "_")
	var rel := base_dir.path_join("%s_%s.png" % [prefix, stamp])
	var abs_path := ProjectSettings.globalize_path(rel)
	if FileAccess.file_exists(rel):
		DirAccess.remove_absolute(abs_path)

	var script := _ps_script(abs_path)
	var out: Array = []
	var code := OS.execute("powershell.exe",
		PackedStringArray(["-NoProfile", "-NonInteractive", "-ExecutionPolicy", "Bypass", "-Command", script]), out, true)
	if code != 0 or not FileAccess.file_exists(rel):
		var msg := "截图失败（PowerShell 退出码 %d）" % code
		if out.size() > 0 and str(out[0]).strip_edges() != "":
			msg += "：" + str(out[0]).strip_edges().substr(0, 300)
		return {"ok": false, "output": msg}

	var size := 0
	var f := FileAccess.open(rel, FileAccess.READ)
	if f:
		size = f.get_length()
	var img := Image.new()
	var dims := ""
	if img.load(abs_path) == OK:
		dims = "%d×%d" % [img.get_width(), img.get_height()]
	return {"ok": true, "output": "已截图 %s（%s，%.0f KB）\n路径：%s" % [
		dims, stamp, size / 1024.0, abs_path]}


func _ps_script(path: String) -> String:
	var p := path.replace("'", "''")
	return (
		"Add-Type -AssemblyName System.Windows.Forms,System.Drawing;" +
		"$vs=[System.Windows.Forms.SystemInformation]::VirtualScreen;" +
		"$b=New-Object System.Drawing.Bitmap($vs.Width,$vs.Height);" +
		"$g=[System.Drawing.Graphics]::FromImage($b);" +
		"$g.CopyFromScreen($vs.X,$vs.Y,0,0,$b.Size);" +
		"$b.Save('" + p + "',[System.Drawing.Imaging.ImageFormat]::Png);" +
		"$g.Dispose();$b.Dispose();" +
		"Write-Output 'ok'"
	)

