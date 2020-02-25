### Introduction

本节课主要介绍多MVC如何通信和工作，并讨论`Timer`和`Animation`的理论部分。

### Mutiple MVC

多MVC基于MVC实现，在第二课讨论的MVC的基础上，把另一个MVC中的C作为当前MVC的V，从而完成不同MVC之间的通信。

#### 常见的MVC 

iOS常见的MVC主要是以下三类：`UITabBarController`、`UISplitViewController`、`UINavigationController`。

三种Root Controller都具有不同的表现形式，开发者可根据自身需求和业务场景灵活选择。

##### UITabBarController

提供一系列选项卡，选择不同的选项意味着我们跳转到了不同的子MVC。如果存在很多选项卡，`UITabBarController`会自动适应大小并隐藏部分选项到一个单选卡中。

#####UISplitViewController

`UISplitViewController`可通过左右滑动隐藏或显示侧边栏，通常用于iPad或者IPhone Plus，其它iPhone的屏幕太小而不适合展示。

##### UINavigationController

`UINavigationController`是iOS中最常用的MVC，通过堆栈管理其它MVC，当进入新的MVC时，会创建对应的对象并添加到堆栈中，而离开时从堆栈中移除对应的MVC。

#### MVC之间的跳转

1. 通过Pop和Push方法离开和进入

2. 通过Segue方法（Segue方法总是创建一个新的MVC）

   `Segue`方法可以选择不同的转场效果，例如`show`、`Detail`、`Modal`和`Popover`...

   `Segue`的使用步骤：

   * 在`Storyboard`上手动拖动以构建`Segue`，并填写`identifier`标记当前`Segue`

   * 在`Controller`的`prepare`方法中根据不同的`Segue`准备数据并构建对应视图

     PS：在准备阶段，即`prepare`方法中，不应该操作即将跳转的视图的`IBOutlet`实例，否则会导致程序出现crash，因为此时`IBOutlet`实例可能还没有被创建出来。如此设计的原因可能是Apple认为`prepare`方法中的准备工作只是收集数据，然后在即将显示的`Controller`视图的`viewDidLoad`方法中加载。

   * PS

3. 