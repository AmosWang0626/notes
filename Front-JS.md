## 获取浏览器语言
> 核心:navigator.language
> 其他是vue.js + iView模板

```
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Hello</title>
    <link rel="stylesheet" type="text/css" href="http://unpkg.com/iview/dist/styles/iview.css">
    <script type="text/javascript" src="http://vuejs.org/js/vue.min.js"></script>
    <script type="text/javascript" src="http://unpkg.com/iview/dist/iview.min.js"></script>
    <style>
    	body {
    		margin: 0;
    		padding: 0;
    		text-align: center;
       	}
    	#app {
   			margin-top: 25%;
        }
    </style>
</head>
<body>
	<div id="app">
		<i-button type="primary" @click="getLanguage()">show language</i-button>
		<br>
		<h3 v-if="seen">this browser language is {{msg}}</h3>
 	</div>
	<script>
		new Vue({
	        el: '#app',
	        data: {
	            msg: '',
	            seen: false
	        },
	        methods: {
	            getLanguage: function () {
	                this.$Message.info(navigator.language);
	                this.msg = navigator.language;
	                this.seen = true;
	            }
        	}
    	})		 
	</script>
</body>
</html>
```
