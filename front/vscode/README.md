---
title: 前端相关 VS Code配置
date: 2019-01-01
categories: 前端相关
hide: true
tags:
- VS Code配置
---

# VS Code 配置

## 默认保存，并格式化代码
```json
{
  "editor.wordWrap": "on",
  "editor.formatOnSave": true,

  "editor.suggestSelection": "first",
  "vsintellicode.modify.editor.suggestSelection": "automaticallyOverrodeDefaultValue",
  "workbench.tree.indent": 24,
  "vetur.format.options.tabSize": 2,
  "workbench.iconTheme": "material-icon-theme",
  "workbench.startupEditor": "newUntitledFile",

  "files.exclude": {
    "**/.git": true,
    "**/.svn": true,
    "**/.hg": true,
    "**/CVS": true,
    "**/.DS_Store": true
  },
  "files.associations": {
    "*.wxml": "xml",
    "*.wxss": "css",
    "*.sass": "css",
    "*.wpy": "vue",
    "*.vue": "vue"
  },

  "emmet.includeLanguages": {
    "vue-html": "html",
    "javascript": "javascriptreact",
    "postcss": "css"
  },
  "emmet.triggerExpansionOnTab": true,
  "emmet.showSuggestionsAsSnippets": true,
  "vetur.validation.template": false,
  "vetur.format.defaultFormatterOptions": {
    "js-beautify-html": {
      "wrap_attributes": "force-expand-multiline"
    },
    "prettyhtml": {
      "printWidth": 100,
      "singleQuote": false,
      "wrapAttributes": false,
      "sortAttributes": false
    },
    "prettier": {
      "semi": false,
      "singleQuote": true
    }
  },

  "eslint.enable": true,
  "eslint.autoFixOnSave": true,
  "eslint.validate": [
    { "language": "html", "autoFix": true },
    { "language": "javascript", "autoFix": true },
    { "language": "javascriptreact", "autoFix": true },
    { "language": "vue", "autoFix": true }
  ],
  "prettier.singleQuote": true,
  "prettier.semi": false,
  "prettier.disableLanguages": ["markdown"],

  "extensions.autoUpdate": false,
  "breadcrumbs.enabled": true,
  "window.zoomLevel": 0,
  "javascript.updateImportsOnFileMove.enabled": "always",
  "terminal.integrated.shell.windows": "C:\\WINDOWS\\System32\\cmd.exe",
  "[vue]": {
    "editor.defaultFormatter": "octref.vetur"
  },
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[json]": {
    "editor.defaultFormatter": "vscode.json-language-features"
  },
  "explorer.confirmDelete": false,
  "[jsonc]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "editor.tabSize": 2,
  "git.autofetch": true,
  "git.confirmSync": false,
  "diffEditor.ignoreTrimWhitespace": false,
  "window.restoreWindows": "all",
  "terminal.integrated.rendererType": "dom"
 }
```