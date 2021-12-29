---
title: vscode实现快速移动光标
date: 2020-09-24 15:42:14
img:
categories: VsCode
summary: vscode实现快速移动光标（alt+jkli实现上下左右）
tags: 
  - VsCode
---


通过 shift+ctrl+p 打开 keybindings.json，如果是 mac 电脑，把 alt 改为 command 即可，这样就能 alt+jkli 实现上下左右了。

以下是代码：

```json
// 将键绑定放在此文件中以覆盖默认值auto[]
[
    {
        "key": "ctrl+shift+oem_2",
        "command": "editor.action.blockComment",
        "when": "editorTextFocus && !editorReadonly"
    },
    {
        "key": "shift+alt+a",
        "command": "-editor.action.blockComment",
        "when": "editorTextFocus && !editorReadonly"
    },
    {
        "key": "alt+l",
        "command": "cursorRight",
        "when": "textInputFocus"
    },
    {
        "key": "right",
        "command": "cursorRight",
        "when": "textInputFocus"
    },
    {
        "key": "alt+i",
        "command": "cursorUp",
        "when": "textInputFocus"
    },
    {
        "key": "up",
        "command": "cursorUp",
        "when": "textInputFocus"
    },
    {
        "key": "alt+j",
        "command": "cursorLeft",
        "when": "textInputFocus"
    },
    {
        "key": "left",
        "command": "cursorLeft",
        "when": "textInputFocus"
    },
    {
        "key": "alt+k",
        "command": "cursorDown",
        "when": "textInputFocus"
    },
    {
        "key": "down",
        "command": "cursorDown",
        "when": "textInputFocus"
    },
    {
        "key": "down",
        "command": "list.focusDown",
        "when": "listFocus && !inputFocus"
    },
    {
        "key": "down",
        "command": "selectNextSuggestion",
        "when": "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus"
    },
    {
        "key": "alt+k",
        "command": "selectNextSuggestion",
        "when": "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus"
    },
    {
        "key": "up",
        "command": "selectPrevSuggestion",
        "when": "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus"
    },
    {
        "key": "alt+i",
        "command": "selectPrevSuggestion",
        "when": "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus"
    },
]
```
