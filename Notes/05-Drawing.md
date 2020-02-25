### 先修知识

1. UIView、UIWindow、UIViewController的概念
2. 视图层次的概念：`superview`和`subviews`...
3. 视图加载方式：从代码构建和从`interface-builder`构建...
4. UIColor、UIFont、CGRect、CGSize、CGPoint...的概念

### 自定义绘制

一般而言，在Swift中，我们只能通过重载`draw`方法实现自定义绘制视图的需求。需要注意的是，`draw`方法是不允许调用的，当手动刷新视图，我们可以调用`setNeedDisplay`/`setNeedDisplay(at: Rect)`，根据需求刷新全部视图或只刷新对应区域的视图。

使用`Core Graphics`的步骤如下：

* 获取上下文，可通过`UIGraphicsGetCurrentContext()`等类似方法获取
* 创建路径，可使用`UIBezierPath`等类，绘制对应的图形路径
* 设置绘制的属性，如颜色、字体、纹理、线宽等等
* 设置以上属性在已经设置好的路径中，以`stroke`还是`fill`形式绘制

#### Drawing Text

日常开发中我们借助`UILabel`实现绘制文本的需求，`UILabel`拥有几乎是所有的中心文本对齐量，唯一需要的是`UILabel`在`superview`中的位置。

这里展开讨论的是另一种绘制文本的方式，在`draw`方法中绘制，使用`NSAttributedString`：

* 我们可以对`NSAttributedString`的某一段文字单独设置属性，但需要注意`String.Index`到`NSRange`的转换。

#### 相关的思考

* 当视图重叠且有透明度时会发生什么？

  `subviews`的排列顺序（倒序）对应了视图从顶层到底层的顺序，透明度的设置开销不小，因为涉及到视图的合成。

* 如何把视图完全隐藏，但不把视图从视图层次中移除？

  通过`var isHidden: Bool`属性实现，该属性设置为true的视图不会在屏幕中绘制，也不会响应对应事件。

* 如何在视图的`bounds`变化时（例如屏幕旋转）重绘视图？

  默认情况下不会重绘，但我们可以通过`UIView`的`contentMode`属性控制

* 如何在bounds发生变化时重新布局？

  1. 通过`Autolayout constraints`重置`subviews`的位置
  2. 重载`layoutSubviews()`方法，适用于没有适用`Autolayout`的视图

* 视图绘制时，clear和see-through的区别？

### 扩展阅读

##### UIColor

##### UIFont

##### UIImageView

设置文本的字体时，可以根据该文本的性质选择不同的`preferred font`（首选字体，例如正文字体）。需要注意的是，只有设置首选字体后，才会对通过设置调整字体大小的操作做出对应响应。

`system font`一般使用于UIButton、标题等，对于用户的context，应使用`preferred font`

