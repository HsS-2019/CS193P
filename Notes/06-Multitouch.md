### Introduction

使用枚举构建扑克游戏，通过重载`UIView`的`draw`函数实现扑克的自定义显示。

### 一些实践

对于结构中常量的设置，可通过扩展实现。或者为代码更清洁而扩展的一些方法和计算属性。



### Multiltitouch

* 获取对应事件的通知，或者响应确切的action

* Gestures识别UIGestureRecognizer的实例

* 添加手势分两部分

  1. 添加一个手势识别器到UIView上

  2. 提供一个方法去处理这个手势

* 通常第一部分由Controller完成

* 而第二部分由UIView或Controller提供

  如果手势影响模型，则由COntroller处理，否则由UIView处理

* 通常在IBOutlet的didSet中添加手势（当iOS连接IBOutlet时，会调用didSet方法）

* 手势的处理器需要能识别对应手势的信息

### 相关的思考

* 视图绘制时，`clear`和`see-through`的区别？
* 通过`context`和`UIBezierPath`绘制的区别?
* `roundedRect`的`addClip()`方法的作用？
* setNeedsDisplay和setNeedsLayout的区别？