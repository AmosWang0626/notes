# iView学习

## 组件
### 父组件向子组件传值
```xml
父：
<page-frame :fatherData='pageFrameData'></page-frame>
pageFrameData: {
    activeName: '3-1',
    openNames: ['3']
}
```
---
```xml
子：
 data() {
    return {
      // 左侧选项卡
      activeName: this.fatherData.activeName,
      openNames: this.fatherData.openNames,
    };
  },
  // 父---子] 传递数据
  props: ['fatherData']
```
---
### 子组件向父组件传值
```xml
子：
<Button type="success" @click="onClickMe">open mouse!</Button>
// 点击该模块响应
onClickMe: function () {
    /* [子---父] 回传数据 */
    this.$emit('frameCallback', 'Hello, Frame CallBack!');
}
```
```xml
父：
<page-frame @frameCallback='listenToFrame'></page-frame>
// [子---父] 回传数据Log
listenToFrame(msg) {
    this.$Message.success(msg);
}
```
---
### 父组件向子组件传递数据双向绑定问题

注意：声明周期问题
data() 加载比 create 早

1.第一种方式监听(较原始底层)
// 监听父组件传递来的数据
watch: {
    fatherData: {
        dep: true,
        handler(value) {
            this.fatherData = value;
        }
    }
}
// 第二种方式监听
computed: {
    pageData() {
        return this.fatherData.pageData;
    }
}
