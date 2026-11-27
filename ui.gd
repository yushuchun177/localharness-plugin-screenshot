extends VBoxContainer
## 本插件的设置界面 —— 由插件自己提供，主程序只负责挂载。
## 想改这个插件在这里长什么样、有哪些开关，改这个文件即可。

func build(plugin_id: String) -> void:
	add_theme_constant_override("separation", 10)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(PluginUI.title("截图"))
	add_child(PluginUI.hint("截取整个屏幕保存成 PNG，再把图片路径交给模型（配合识图插件就能看图）。"))
	add_child(PluginUI.section("行为"))
	add_child(PluginUI.str_field(plugin_id, "dir", "保存目录", "",
		"留空存到 user://shots；也可以填 D:/shots 这样的绝对路径"))
	add_child(PluginUI.section("能力开关"))
	add_child(PluginUI.hint("每一项都能单独关掉；关掉后模型看不到这个能力，也调用不了。"))
	for t in Plugins.tools_of(plugin_id):
		var tname := str(t.get("name", ""))
		var human := tname
		var desc := str(t.get("description", ""))
		if tname == "screenshot_capture":
			human = "截屏"
			desc = "抓一张全屏图，会读取你的屏幕内容"
		add_child(PluginUI.perm_row(tname, human, desc, bool(t.get("dangerous", false))))
	add_child(PluginUI.readme_box(plugin_id))
