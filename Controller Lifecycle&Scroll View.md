### ViewController Cycle

##### 大概顺序

* 在`Controller`被创建之前，如果是以Push等方式进入`Controller`，会先准备`Segue`
* 然后是设置`Outlet`，eg：UIButton、Action……
* Appear 和Disappear，在这个阶段会产生几何变化，你可能会改变几何形状、或者是旋转设备
* 在低内存时，我们会要求控制器释放

##### `ViewController Lifecycle`的具体接口：

我们先来了解一下什么时候顶层视图（`ViewController`的顶层view）会被发送到`layoutSubview`，可能是加载或移除了`subview`、也可能是顶层视图的`bounds`发生了改变。

如果我们采用了`AutoLayout`自动布局，那我们并不需要调用`ViewWillLayoutSubviews()`和`ViewDidLayoutSubviews()`方法，因为布局上的调整已经被自动唤起的顶层视图的`LayoutSubviews()`完成。但如果我们想对我们的控制器做点布局上的改变，毫无疑问应该在上述的两个方法中实现。

需要注意的是，上述两个方法经常会被调用，即使`bounds`和子视图都没有发生变化。因为系统可能会随时调用这两个方法，例如在动画开始或结束时，或确定子视图的位置。

* `ViewDidLoad()`，视图控制器即将加载，生命周期中只会调用一次。注意不要在这里做几何变化，因为此时视图控制器的`boundary`尚未设置

* `ViewWillAppear()`，视图控制器即将出现在屏幕上，生命周期中可以调用多次。在这个阶段，你可以根据你模型的信息加载所有的视图（因为模型的信息可能发生变化，所以这里就是最开始根据信息做动态化显示的地方）。

* `ViewDidAppear()`，视图控制器已经进入屏幕后调用。这个阶段更适合开始一个动画，因为`ViewWillAppear（）`被调用时，控制器还不在屏幕上。可以开启计时器、在屏幕上执行某些操作、启动对属性或通知的监听，例如GPS位置或手机的陀螺仪位置。

  另外，我们还可以在`ViewDidAppear()`方法中开始一些开销较大的操作，例如在后台启动任务，从网络上下载一张巨大的图片，在前两个方法中启动时可能会影响`Controller`加载到显示在屏幕上所需的时间，也可能会导致界面堵塞。在`ViewDidAppear()`方法中启动这些任务时，可以通过刷新和加载动画提示用户，用户也仍可以对屏幕进行操作，甚至是取消操作，返回至上一级视图。

* `ViewWillDisappear()`，视图控制器即将移出屏幕时调用。在这个阶段，你可以暂停或取消在`ViewDidAppear()`阶段所开启的定时器或动画等。

* `ViewDidDisappear()`，视图控制器从屏幕中完全消失后调用。在这个阶段我们做的工作并不多，但你也许可以在这里清理你的MVC，eg：保存一些状态或什么其它的，但这个方法很少会用到。

* 注意：不要忘记调用对应的super方法

布局或屏幕改变时调用的接口：

* `ViewWillLayoutSubviews()`，`ViewController`的顶层view被发送到`layoutsubview()`之前调用。
* `ViewDidLayoutSubviews()`，`ViewController`的顶层view被发送到`layoutsubview()`之后调用。
* `viewWillTransition()`，在设备屏幕发生旋转前调用。在这一阶段我们可以添加一个动画闭包，然后那个动画会和系统的动画一起执行。当然，这一方法的调用也意味着`ViewController`的顶层view的`bounds`发生了变化。