### ViewController Cycle

##### 大概顺序

* `Instantiated`实例化，通常是来自`storyboard`的对象
* `awakeFromNib()`方法，仅适用于来自`storyboard`的对象
* `Segue`准备发生，在`Controller`被创建之前，如果是以Push等方式进入`Controller`
* 然后是设置`Outlet`，通过iOS连接，eg：UIButton、Action……
* `viewDidLoad()`方法被调用
* `Appear` 和`Disappear`，在这个阶段会产生几何变化，你可能会改变几何形状、或者是旋转设备
* 在上一阶段的任何一个方法中，你的几何图形都可能发生改变，而几何变化会导致`ViewWillLayoutSubviews()`和`ViewDidLayoutSubviews()`方法被调用，可能在这两个方法之间发生了自动布局（`layoutSubviews()`方法调用）。
* 在使用了大量的内存时，应用程序可能会收到内存警告，进而自动调用`didReceiveMemoryWarning()`，在这个方法中，我们可以清理一些东西，例如要求控制器释放堆上可重复创建的内容。

##### `ViewController Lifecycle`的具体接口：

我们先来了解一下什么时候顶层视图（`ViewController`的顶层view）会被发送到`layoutSubview`，可能是加载或移除了`subview`、也可能是顶层视图的`bounds`发生了改变。

如果我们采用了`AutoLayout`自动布局，那我们并不需要调用`ViewWillLayoutSubviews()`和`ViewDidLayoutSubviews()`方法，因为布局上的调整已经被自动唤起的顶层视图的`LayoutSubviews()`完成。但如果我们想对我们的控制器做点布局上的改变，毫无疑问应该在上述的两个方法中实现。

需要注意的是，上述两个方法经常会被调用，即使`bounds`和子视图都没有发生变化。因为系统可能会随时调用这两个方法，例如在动画开始或结束时，或确定子视图的位置。

* `awakeFromNib()`: 严格意义上来说，这并不算是`ViewCtroller`生命周期的一部分。但仍放在这里是 因为，所有在`storyboard`中创建的对象，例如`UIView`、`UIViewCtroller`，在准备阶段之前就会发送`awakeFromNib()`方法

* `ViewDidLoad()`，视图控制器即将加载，生命周期中只会调用一次。注意不要在这里做几何变化，因为此时视图控制器的`bounds`尚未设置

* `ViewWillAppear()`，视图控制器即将出现在屏幕上，生命周期中可以调用多次。在这个阶段，你可以根据你模型的信息加载所有的视图（因为模型的信息可能发生变化，所以这里就是最开始根据信息做动态化显示的地方）。

* `ViewDidAppear()`，视图控制器已经进入屏幕后调用。这个阶段更适合开始一个动画，因为`ViewWillAppear（）`被调用时，控制器还不在屏幕上。可以开启计时器、在屏幕上执行某些操作、启动对属性或通知的监听，例如GPS位置或手机的陀螺仪位置。

  另外，我们还可以在`ViewDidAppear()`方法中开始一些开销较大的操作，例如在后台启动任务，从网络上下载一张巨大的图片，在前两个方法中启动时可能会影响`Controller`加载到显示在屏幕上所需的时间，也可能会导致界面堵塞。在`ViewDidAppear()`方法中启动这些任务时，可以通过刷新和加载动画提示用户，用户也仍可以对屏幕进行操作，甚至是取消操作，返回至上一级视图。

* `ViewWillDisappear()`，视图控制器即将移出屏幕时调用。在这个阶段，你可以暂停或取消在`ViewDidAppear()`阶段所开启的定时器或动画等。

* `ViewDidDisappear()`，视图控制器从屏幕中完全消失后调用。在这个阶段我们做的工作并不多，但你也许可以在这里清理你的MVC，eg：保存一些状态或什么其它的，但这个方法很少会用到。

* `didReceiveMemoryWraning()`，当应用程序收到内存警告时调用，从堆中释放可重新创建的内容。除非你的程序正在对很多大照片进行操作，或者是巨大音视频文件，否则一般不会触发这个方法。当然，还有另一种可能是你的应用程序内存泄漏了。

* 注意：不要忘记调用对应的super方法

布局或屏幕改变时调用的接口：

* `ViewWillLayoutSubviews()`，`ViewController`的顶层view被发送到`layoutsubview()`之前调用。
* `ViewDidLayoutSubviews()`，`ViewController`的顶层view被发送到`layoutsubview()`之后调用。
* `viewWillTransition()`，在设备屏幕发生旋转前调用。在这一阶段我们可以添加一个动画闭包，然后那个动画会和系统的动画一起执行。当然，这一方法的调用也意味着`ViewController`的顶层view的`bounds`发生了变化。

### UIScrollView

* `contentSize`，`UIScrollView`通过设置`ContentSize`来指定内部空间的大小，当大于`UIScrollView`的`frame`时，`UIScrollView`内部可滚动。需要注意的是，如果你只是添加`subview`到`UIScrollView`中，可能不会在`UIScrollView`中显示，直到你设置了`contentSize`；同样的，当你的内容大于显示区域，但无法平移或缩放，应该考虑`contentSize`是否未设置。
* `contentOffset`，`UIScrollView`内容区域的偏移
* `zooming`，`UIScrollView`内容区域缩放的比例，会影响内容区域的大小，值为1时代表着不缩放。当你想要缩放时：
  1. 需要设置`minimumZoomScale`和`maximumZoomScale`属性，它们的默认值都是1.0，所以如果不重新设置，可能会导致无法缩放。
  2. 通过`viewForZooming(in scrollView: UIScrollView) -> UIView`方法，指定缩放的视图。如果你只是想缩放`UIScrollView`中的某一个子视图，可以返回该子视图。如果想缩放多个
  3. `scrollViewDidEndZooming(UIScrollView, with view: UIView, atScale: CGFloat)`，当缩放完成后，可能导致原先绘制的内容在缩放变得锯齿或模糊，可能的补救措施是：在这个方法中将`transform`属性设置为`identity`，并重新执行绘制（绘制一个更大的矩形），这是一种以更高分辨率绘制的好方法。

