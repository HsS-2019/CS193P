### Introduction



#### 分类

##### UIView Animation Property

##### Dynamic Animation

看一下我们如何使用`Dynamic Animation`:

* 首先，我们创建一个动画启动器（UIDynamicAnimator实例），用来启动动画.

  ```
  var animator = UIDynamicAnimator(refrenceView: UIView)
  //UIView参数为我们提供了参考的视图（对于正在进行的动画的坐标系统），对该参考视图的唯一要求是它必须位于所有视图层次结构的顶部。需要注意的是，只要保持在所有进行动画的视图的顶部即可，这意味着位于较低位的视图也有可能符合要求。
  ```

* 其次，创建动画行为（UIDynamicBehavior实例），用来描述这个视图中的事物是如何表现的，例如引力，碰撞检测。

  动画启动器可以添加创建的行为实例，以决定稍后执行的操作。

  行为包括：`UIGravityBehavior`、`UIAttachmentBehavior`、`UICollisionBehavior`-碰撞行为、`UISnapBehavior`、`UIPushBehavior`、`UIDynamicItemBehavior`-元行为（可设置弹性、摩擦系数之类，所以可能会影响别的行为）、最后还可以继承`UIDynamicBehavior`类并自定义行为。

  行为实例还拥有`action`闭包变量，用来执行即时且单次的代码块

* 最后，给行为添加相应的作用对象Item（可以是Uiew，或其它实现了UIDynamicItem协议的任意对象）。一旦添加Item到行为实例中，Item即开始受到行为的作用，对应的，当从行为中移除Item，该Item也会立刻停止被影响。

#### 相关的思考

* 闭包的引用循环

  引用循环实例如下：

  ```
  class Zerg{
  	private var foo = {
  		self.bar()
  	}
  	private func bar(){ }
  }
  ```

  在这个例子中，Zerg的实例持有了闭包foo，而闭包foo也持有Zerg实例，导致引用循环。

  可通过声明闭包的局部变量为`weak`或`unowned`解决引用循环

  ```
  var foo = { [weak x = someInstanceOfClass, y = "hello"]  }
  var foo1 = { [unowned x = someInstanceOfClass, y = "hello"]  }
  ```

  