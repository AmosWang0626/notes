- 获取浏览器语言
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
   			margin-top: 10%;
        }
    </style>
</head>
<body>
	<div id="app">
		<!-- 百分比 vw 视窗宽度; vh 视窗高度  -->
		<div style="background:#eee; margin: 10vh 30vw; padding: 20px">
	        <Card :bordered="false">
	            <p slot="title">浏览器语言</p>
	            <p v-if="seen">this browser language is {{msg}}</p>
	        </Card>
    	</div>
		<i-button type="primary" size="large" @click="getLanguage()">show language</i-button>
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

- 浏览器页面切换事件监听
```
<!DOCTYPE html>
<html lang="">
<head>
    <title>Hi</title>
    <script>
        var count = 0;
        var hiddenProperty = 'hidden' in document ? 'hidden' :
            'webkitHidden' in document ? 'webkitHidden' :
                'mozHidden' in document ? 'mozHidden' : null;
        var visibilityChangeEvent = hiddenProperty.replace(/hidden/i, 'visibilitychange');
        var onVisibilityChange = function () {
            if (document[hiddenProperty]) {
                console.log('页面非激活');
            } else {
                console.log('页面激活');
                count++;
                document.getElementById('hello').innerHTML = '页面第' + count + '次激活!'
            }
        };
        document.addEventListener(visibilityChangeEvent, onVisibilityChange);
    </script>
</head>
<body>
<div class="content">
    <h1>Hello World!</h1>
    <br/>
    <h1 id="hello"></h1>
</div>
</body>
</html>
```
