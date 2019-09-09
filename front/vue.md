# Vue

## 组件传参

### 父组件向子组件传值
- 父页面
```
<page-frame :fatherData='data'></page-frame>
data: {
    name: 'xiaomi',
    users: ['amos', 'yuan']
}
```
- 子页面
```
子：
 data() {
    return {
      name: this.fatherData.name,
      users: this.fatherData.data,
    };
  },
  props: ['fatherData']
```

### 子组件向父组件传值
- 子页面
```
<button type="success" @click="onClickMe">open mouse!</button>
onClickMe: function () {
    this.$emit('childCallback', 'Hello, Frame CallBack!');
}
```
- 父页面
```
<page-frame @childCallback='toastMessage'></page-frame>
toastMessage(msg) {
    this.$Message.success(msg);
}
```

### 父组件向子组件传递数据双向绑定问题
> 注意：Vue生命周期中，data()加载比 create 早

1. 第一种方式监听(较原始底层)
    > 监听父组件传递来的数据
```
watch: {
    fatherData: {
        dep: true,
        handler(value) {
            this.fatherData = value;
        }
    }
}
```

2. 第二种方式监听
```
computed: {
    pageData() {
        return this.fatherData.pageData;
    }
}
```
