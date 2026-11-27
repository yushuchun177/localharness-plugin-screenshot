# 截图 / Screenshot

抓一张全屏截图存成 PNG，返回路径和分辨率（配合识图插件可以看图）。

Capture a full-screen PNG and return its path and resolution (works with the vision plugin to read it).

Local-Harness（Godot 版）的独立插件。**不随主程序发布**，由主程序「设置 → 插件管理」从 GitHub 下载并自动部署到 `user://plugins/screenshot/`。

## 工具

- `screenshot_capture` —— 截取当前整个桌面，保存为 PNG，返回文件路径。
  - `name`: string，可选，文件名前缀，默认 shot

## 安装

1. Local-Harness → 设置 → 插件管理 → 刷新列表
2. 找到「截图」点安装
3. 装完直接在对话里让模型调用（插件会出现在系统提示的工具清单里）

手动安装：把仓库解压到 `%LOCALAPPDATA%\Godot\app_userdata\Local-Harness\plugins\screenshot\`。

## 结构

```
manifest.json   清单：id / 版本 / 工具定义
main.gd         extends Node，实现 run(tool, args) -> {ok, output}
```

## 许可

GPL-3.0（与主程序一致）。完整协议文本见仓库根目录的 `LICENSE` 文件。
