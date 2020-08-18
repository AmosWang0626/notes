---
title: JS 表格自动添加行
date: 2018-01-01
categories: 前端相关
hide: true
---


## 一、Demo 表格数据

```javascript
// 定位到table上
var parNode = document.getElementById("tab_content"); 
var print = "";
for (var i = 1; i < parNode.rows.length; i++) {
	print += "第" + i + "行：";
	var con = parNode.rows[i].cells[1];
	print += con.innerHTML;
} 
if ("" == print) {
	alert("您还没添加内容");
} else {
	alert(print);
}
```

## 二、Demo 表格数据

```javascript
<script>
	// 动态向表格插入一行数据
	function insertTableRow() {
		// 先去除内容两端空格
		var val = $('#content').val().replace(/(^\s*)|(\s*$)/g, "");
		if (val == null || "" == val) {
			alert("请输入内容");
		} else {
			var parNode = document.getElementById("tab_content"); //定位到table上
			var tr = parNode.insertRow(parNode.rowIndex);
			tr.insertCell().innerHTML = tr.rowIndex;
			tr.insertCell().innerHTML = '<input type="text" name="contents" value='+val+' readonly="readonly" />';
			tr.insertCell().innerHTML = '<a href=javascript:void(0) onclick=deleteTableRow(this)><span style="font-size:16px">删除</span></a>';
			$('#content').val("");
		}
	}

	function deleteTableRow(a) {
		var row_index = a.parentNode.parentNode.rowIndex;
		document.getElementById("tab_content").deleteRow(row_index);

		refreshNumber();
	}

	function getTableRow() {
		var print = "";
		var contents = document.getElementsByName("contents"); //定位到table上
		for (var i = 0; i < contents.length; i++) {
			print += "第" + i + "行：";
			print += contents[i].value;
		}
		if ("" == print) {
			alert("您还没添加内容");
		} else {
			alert(print);
		}
	}

	function refreshNumber() {
		var parNode = document.getElementById("tab_content"); //定位到table上
		for (var i = 1; i < parNode.rows.length; i++) {
			parNode.rows[i].cells[0].innerHTML = i;
		}
	}

	// 提交数据到服务器
	function submitData() {
		var contents = document.getElementsByName("contents"); //定位到table上
		var command = $('#command').val().replace(/(^\s*)|(\s*$)/g, ""); //定位到指令上
		var description = $('#description').val().replace(/(^\s*)|(\s*$)/g, ""); //定位到描述上
		if ("" == command) {
			alert("指令名称不能为空");
		} else if ("" == description) {
			alert("指令描述不能为空");
		} else if (!contents.length > 0) {
			alert("内容列表不能为空");
		} else {
			// alert(command + description);
			$("#addForm").submit();
		}
	}
</script>
```
