# View Controller的生命周期



### View Controller的相关接口

通过了解不同接口的作用，弄明白我们在`View Cntroller`生命周期的不同阶段可以做点什么。

#### viewDidLoad()

此时你的所有`outlets`都已经被设置，对应视图`view`已经加载到内存，所以我们在这一阶段完成对`view`的`setup`。**`viewDidLoad()`方法在`Controller`的生命周期中只会被调用一次。**

```swift
override func viewDidLoad(){
	super.viewDidLoad()
	//do the primary setup of my MVC here
	//good time to update my View using my model,because my outlets are set
}
```

需要注意的是，我们不应该在这个方法中执行`view`图形几何相关的设置，例如位置和大小的设置，因为在这个阶段，视图控制器的`bounds`仍未确定。

> 我们可以发现，不同接口中都调用了对应的super方法，事实上我们应确保super方法的调用，因为super方法完成了一些必要的基本操作。

#### viewWillAppear

正如方法名的意思：视图控制器将要出现在屏幕前，此时视图控制器仍在屏幕外。

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

在`view Controller`视图控制器的生命周期中，当收到`view Controller`的顶层`view`的`bounds`改变的通知，视图控制器会调用`layoutSubviews()`方法（添加移除子`view`也会调用），并把顶层`view`发送到`layoutSubviews()`方法。

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

### 扩展接口

`view Controller`的生命周期中，在某些情况下，还会自动调用一些其它的接口，这里会介绍一些开发过程中比较常见的接口。

#### viewWillTransition

屏幕即将发生旋转时调用，在这里我们可以对视图进行重新布局，并做一些对应的事情。

```swift
override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator){
	super.viewWillTransition(to size, with coordinator)
	//judge direction and do something
}
```

另外，对于屏幕旋转，视图控制器提供了动画，节省了开发者的很多工作量。但如果你想实现一些特殊的效果，也可以在`coordinator`的方法中提供自定义的`animation block`，这样自定义的动画将和系统的动画在旋转的过程中一起执行。



### 视图控制器生命周期的完整过程

* `Instantiated`实例化，通常是来自`storyboard`的对象
* `awakeFromNib()`方法，仅适用于来自`storyboard`的对象
* `Segue`准备发生，在`Controller`被创建之前，如果是以Push等方式进入`Controller`
* 然后是设置`Outlet`，通过iOS连接，eg：UIButton、Action……
* `viewDidLoad()`方法被调用。
* `Appear` 和`Disappear`，在这个阶段会产生几何变化，你可能会改变几何形状、或者是旋转设备
* 在上一阶段的任何一个方法中，你的几何图形都可能发生改变，而几何变化会导致`ViewWillLayoutSubviews()`和`ViewDidLayoutSubviews()`方法被调用，可能在这两个方法之间发生了自动布局（`layoutSubviews()`方法调用）。
* 在使用了大量的内存时，应用程序可能会收到内存警告，进而自动调用`didReceiveMemoryWarning()`，在这个方法中，我们可以清理一些东西，例如要求控制器释放堆上可重复创建的内容。