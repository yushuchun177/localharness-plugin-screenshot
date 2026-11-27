extends VBoxContainer
## 截图 —— 这个页面是插件自己提供的界面。
## 界面全部由插件自己拼，主程序只提供积木。

func build(plugin_id: String) -> void:
	add_theme_constant_override("separation", 12)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL

	add_child(PluginUI.section("截图存哪"))
	add_child(PluginUI.str_field(plugin_id, "dir", "保存目录", "",
		"留空就存在程序自己的 shots 目录；也可以填 D:/截图 这样的路径"))

	add_child(PluginUI.section("试一下"))
	add_child(PluginUI.action_row("现在截一张",
		"抓整个屏幕存成 PNG，结果里会给出文件路径", "立即截图",
		func(): return Plugins.invoke("screenshot_capture", {"name": "quick"})))
	add_child(PluginUI.overview(plugin_id))
	add_child(PluginUI.permissions_section(plugin_id))
	add_child(PluginUI.doc_section(plugin_id))
