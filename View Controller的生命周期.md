# View Controller从创建到消亡

> 前言：很多东西都想写，之前很忙的时候还在想我怎么就没有四只手，l说她要八只手，可惜我们都没有。会继续学习新的，然后也会整理旧的。写的博客就从整理开始好了，在整理的过程中完善已有的，并不断补充和添加新的内容。

`View Controller`，是管理UIKit 应用程序的视图层次结构的对象，一个`View Controller`主要负责的事情有：

* 更新视图的内容，通常是响应基础数据的更改而做出对应改变。
* 响应用户与视图的交互。
* 调整视图大小并管理整个界面的布局。
* 与应用程序中的其它对象（包括其他视图控制器）进行协调。



## View Controller的生命周期

在View Controller生命周期的不同阶段，或是满足了特定条件下，对应的方法会被自动调用。

图解

* `Instantiated`实例化，通常是来自`storyboard`的对象
* `awakeFromNib()`方法，仅适用于来自`storyboard`的对象
* `Segue`准备出现，在`Controller`被创建之前，如果是以Push等方式进入`Controller`
* 然后是设置`Outlet`，通过iOS连接，eg：UIButton、Action……
* `viewDidLoad()`方法被调用。
* `viewWillAppear` ，视图控制器仍未出现在屏幕上。
* 在上一阶段的任何一个方法中，你的几何图形都可能发生改变，而几何变化会导致`ViewWillLayoutSubviews()`和`ViewDidLayoutSubviews()`方法被调用，可能在这两个方法之间发生了自动布局（`layoutSubviews()`方法的调用会导致这两个方法被自动调用）。
* `viewDidDisappear`，视图控制器已经出现在屏幕上，在这个阶段会产生几何变化，你可能会改变几何形状、或者是旋转设备
* 在使用了大量的内存时，应用程序可能会收到内存警告，进而自动调用`didReceiveMemoryWarning()`。在这个方法中，我们可以清理一些东西，例如要求控制器释放堆上可重复创建的内容。



## View Controller的加载

在View Controller显示在屏幕上之前，UIKit为了提供了几个机会来配置视图控制器和视图。

通过了解不同接口的作用，弄明白我们在`View Cntroller`生命周期的不同阶段可以做点什么。

#### 加载的大概过程

在屏幕上显示一个视图控制器前，UIKit必须首先**加载并配置**相应的视图，通过以下步骤：

* 调用视图的`init(coder:)`方法创建每个视图。
* 将视图和视图控制器中相应的`actions`和`outlets`建立**绑定**。
* 调用每个视图和视图控制器的`awakeFromNib()`方法。
* 将view hierarchy（视图层次结构）分配给视图控制器的**顶层`view`**属性。
* 调用视图控制器的`viewDidLoad()`方法。

需要注意的是，在加载时，我们做的工作应围绕**如何准备视图控制器以供使用**，执行相关的配置步骤。而不是执行每次视图控制器出现在屏幕上时必须执行的任务，例如启动动画或更新视图的值（包括几何属性）。

#### init(coder:)

当从storyboard实例化视图控制器时，UIKit使用当前方法创建对象。**注意，不要在这里做`view`相关操作，`view`在`loadView()`方法中才初始化。**

```swift
required init?(coder aDecoder: NSCoder) {
	super.init(coder: aDecoder)
  //create via InterfaceBuilder
}
```

如果你的视图控制器需要**自定义初始化**，而coder无法提供这种初始化时，可以通过UIStoryboard的`instanateinitialviewcontroller(creator:)`方法以编程方式实例化视图控制器。

#### initWithNibName

```swift
override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		//
}
```



#### awakeFromNib

严格来说`awakeFromNib()`方法并不算是视图控制器生命周期的一部分，但对于**`stroyboard`中创建的**所有视图和视图控制器，都会在很早的时候调用`awakeFromNib`方法。在初始化之后，但在设置`outlet`和被作为`Segue`的一部分准备之前。

```
override func awakeFromNib(){
	super.awakeFromNib()
	//can initialize stuff here, but it is very early.
	//it happens way before outlets are set and before you are 
}
```

这个方法主要是为需要在视图生命周期非常早的阶段执行的代码提供环境，但如果有可能，我们通常不会在在这里执行自定义的操作，建议尽量使用视图生命周期中的其它方法。

#### loadView

当视图控制器的`view`属性被访问，而`view`属性值为`nil`时，视图控制器自动调用这个方法，创建或加载视图并赋值给`view`属性。如果你是通过 `Interface Builder`（如`storyboard`）创建或实例化视图控制器，你并不需要重写这个方法。

重写这一方法的目的主要是手动创建视图控制器的视图，如果你想做更多的初始化，请把这些工作放到`viewDidload()`方法中执行。

```swift
override func loadView(){
	//Your custom implementation of this method should not call super
}
```

#### viewDidLoad()

此时`View Controller`的初始化已经完成，所有`outlets`都已经被设置，对应视图`view`也已经加载到内存。如果你使用的是`AutoLayout`，我们在这一阶段设置对`view`的相关绑定，当然，也可以在`storyboard`中手动绑定。**`viewDidLoad()`方法在`Controller`的生命周期中只会被调用一次。**

```swift
override func viewDidLoad(){
	super.viewDidLoad()
	//do the primary setup of my MVC here
	//good time to update my View using my model,because my outlets are set
}
```

需要注意的是，我们不应该在这个方法中执行`view`图形几何相关的设置，例如位置和大小的设置，因为在这个阶段，视图控制器的`bounds`仍未确定。

> 我们可以发现，不同接口中都调用了对应的`super`方法，事实上我们应确保`super`方法的调用，因为`super`方法完成了一些基本的操作。



## View Controller在屏幕上的显示

在这一阶段，我们完成了对视图几何属性的设置、更新布局、根据对应数据模型刷新视图和开启开销较大的任务等工作。

#### 出现和消失的大概过程

`View Controller`完成了上述的加载工作，当即将出现在屏幕上时，`UIKit`会通知该视图控制器，并调用以下方法更新视图的布局以适应当前环境：

* 更新基于目标窗口的视图控制器的trait collection。
* 调用`viewWillAppear(_:)`，让你知道视图控制器的视图即将显示在屏幕上。
* 根据需要，更新当前的布局边距并调用`viewWillLayoutMarginsDidChange()`方法。
* 根据需要，更新`Safe area的insets`并调用`viewSafeAreaInsetsDidChange()`方法。
* 调用`viewWillLayoutSubviews()`方法。
* 更新视图层次结构的布局。
* 调用`viewDidLayoutSubviews()`方法。
* 在屏幕上显示视图。
* 调用视图控制器的`viewDidAppear(:)`方法。

从屏幕上移除`View Controller`的流程和上述流程大致相同，不同的是即将从屏幕上移除时调用的是`viewWillDisappear()`方法，而当视图从屏幕上移除后调用的是`viewDidDisappear()`方法。

排除有需要才执行对应逻辑的`viewWillLayoutMarginsDidChange()`和`viewSafeAreaInsetsDidChange()`方法，`View Controller`显示在屏幕前和从屏幕上移除前的相关流程如下图。

![image-20200524155625624](/Users/hss/Documents/Repositories/CS193P/image-viewController-appear.png)

#### viewWillAppear

此时视图控制器将要出现在屏幕前，此时视图控制器仍在屏幕外。

在这个阶段，你可以根据模型的信息加载所有的视图（因为模型的信息可能发生变化，所以这里就是最开始根据信息做动态化显示的地方）。**`viewWillAppear()`在视图的生命周期中可以被调用多次。**

```swift
override func viewWillAppear(_ animated: Bool){
	super.viewWillAppear(animated)
	//catch my View up to date with what went on while I was off-screen
}
```

事实上，我们会在上述两个方法中做一些视图加载的操作，但并不会执行相对耗时较大的任务，因为从用户的角度，我们一般想要更快地看到视图被加载出来。耗时较大的任务我们可以放在下面的方法中执行。

另外，在这一阶段，我们也不应该执行`view`图形几何相关的设置。

那么，我们会在什么阶段执行`view`几何属性的设置呢，这要说到视图控制器生命周期中的另外两个接口，即`viewWillLayoutSubviews()`和`viewDidLayoutSubviews()`。

#### viewWillLayoutSubviews和viewDidLayoutSubview

`layoutSubviews()`方法的调用会导致这两个方法被自动调用。

> 在`view Controller`视图控制器的生命周期中，当收到`view Controller`的顶层`view`的`bounds`改变的通知，视图控制器会调用`layoutSubviews()`方法（添加或移除子`view`时也会调用），并把顶层`view`发送到`layoutSubviews()`方法。

所以我们可以在`layoutSubviews()`方法被调用之前或之后实现几何变量的计算和设置，也就是在`viewWillLayoutSubviews()`方法和`viewDidLayoutSubviews()`方法中完成设置。

```swift
override func viewWillLayoutSubviews(){
	super.viewWillLayoutSubviews()
	//
}

override func viewDidLayoutSubviews(){
	super.viewDidLayoutSubviews()
	//
}
```

如果我们有几何相关的设置要做，这是个好地方（`viewDidLayoutSubviews()`也是），但其实一般来说我们都不需要继承这两个接口并做点什么，因为`AutoLayout`可以自动帮我们实现相应的效果。

还有一点，这两个接口经常会被视图控制器调用（因为`UIView`中的`layoutSubviews()`方法会经常会调用），被调用也不意味着`view`的`bounds`属性发生了改变，可能是动画或者布局的需求，所以记得不要在这两个接口中实现开销较大的操作。

#### viewDidAppear

视图控制器进入屏幕后调用，此时用户已经可以看到加载出来的视图了，所以在这个阶段，我们并不适合做一些类似根据`model`更新`view`的操作。**`viewDidAppear()`在视图的生命周期中可以被调用多次。**

```swift
override func viewDidAppear(_ animated: Bool){
	super.viewDidAppear(animated)
	//maybe start a timer or an animation or start observing something(e.g. GPS position)?
}
```

在这个阶段，你还可以做一些时间/内存/电量消耗较大的任务，不在`viewDidLoad()`阶段做的原因在上面有说。如果在视图未出现在屏幕前做消耗较大的任务，可能出现在界面跳转时，卡顿许久才出现下一个界面的场景，就用户体验而言这无异于是灾难。

> 消耗较大的任务可能是网络请求，从硬件磁盘中读取文件，进行量级较大的数值计算等。需要注意的是，为了不让这些任务阻塞主线程（这会导致用户无法与界面交互），我们通常把这些任务放到后台的子线程里执行。

所以，我们需要实现的是这样一种效果，当耗时较大的任务在后台执行时，前台的视图仍能和用户完成正常的交互，即使后台任务可能执行失败。

#### viewWillDisappear

视图控制器将要离开屏幕前调用，此时视图控制器仍在屏幕上。

在这个阶段，我们可以取消之前在`viewDidAppear()`阶段开启的一些任务，例如计时器或者对GPS位置的观察。**`viewWillDisappear()`在视图的生命周期中可以被调用多次。**

```swift
override func viewWillDisappear(_ animated: Bool){
	super.viewWillDisappear(animated)
  //often you undo what you did in viewDidAppear
  //for example, stop a timer that you started there or stop observing something
}
```

#### viewDidDisappear

视图控制器完全离开屏幕后调用，通常我们在这一阶段做的工作不多，可能是清理你的MVC或保存一些状态之类的。**`viewDidDisappear()`在视图的生命周期中可以被调用多次。**

```swift
override func viewDidDisappear(_ animated: Bool){
	super.viewDidDisappear(animated)
	//clean up MVC
}
```

#### viewWillTransition

屏幕即将发生旋转时调用，在这里我们可以对视图进行重新布局，并做一些对应的事情。

```swift
override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator){
	super.viewWillTransition(to size, with coordinator)
	//judge direction and do something
}
```

另外，对于屏幕旋转，视图控制器提供了动画，节省了开发者的很多工作量。但如果你想实现一些特殊的效果，也可以在`coordinator`的方法中提供自定义的`animation block`，这样自定义的动画将和系统的动画在旋转的过程中一起执行。

## View Controller的扩展接口

`view Controller`的生命周期中，在某些情况下，还会自动调用一些其它的接口，这里会介绍一些开发过程中比较常见的接口。

#### didReceiveMemoryWarnning

> 由于手机不像电脑一样采用页置换的方式获取请求内存，因此只能通过移除应用程序中的强引用来释放内存资源。

当收到来自iOS系统的内存不足的警告消息，当前的视图控制器会调用`didReceiveMemoryWarning()`方法，并释放一些当前不在屏幕上显示的对象引用。我们也可以重写该方法并手动释放部分当前不需要的内存，以缓解内存压力。

```swift
override func didReceiveMemoryWarning(){
	super.didReceiveMemoryWarning()
  //stop pointing to any large-memory things(i.e. let them form my heap)
  //that I am not currently using(e.g. displaying on screen or processing somehow)
  //and that I can recreate as needed(by refetching from network, for example)
}

```

当手机内存不足时，iOS系统会发出内存警告，并将该消息警告分发给所有正在运行中的应用程序，我们可以在应用程序代理的`applicationDidReceiveMemoryWarning()`方法以及视图控制器的``didReceiveMemoryWarning()`方法手动完成对象内存的释放，以防止应用程序被系统直接终止。

## 一些问题

* 视图和应用程序的生命周期。可以引申到视图层次结构、响应链、App的启动优化分析。
* 视图的渲染机制。不同机制之间的比较，自定义视图的封装，绘制过程的内存优化。
* 不同的转场方式和转场动画。例如通过push和present都可以跳转到下一个界面，但是两者的区别是什么。
* 怎么保证用户的体验。例如视图控制器进到屏幕后，怎么在开启耗时任务（发起请求和进行大量计算）的同时，确保用户的交互不受干扰。
* 视图控制器之间如何进行通信。闭包、通知、代理模式、KVO。
* 怎么添加适当的动画，让界面交互更人性化。动画的封装。



## 总结

在观看视频和查阅资料之后，尝试总结了`View Controller`的生命周期与一些相关的扩展接口。



## 参考资料

[Apple技术文档](https://developer.apple.com/documentation/uikit/uiviewcontroller )

[斯坦福大学CS193P课程-2017版]()

