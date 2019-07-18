# epoll

## 基本概念

* 进程控制块 (PCB)：用来记录进程的外部特征，描述进程的运动变化过程。系统利用PCB来控制和管理进程。PCB是系统感知进程的唯一标志。
  进程和PCB是一一对应的。在Linux中体现为`task_struct`数据结构。
  
  * 进程标识符name
  * 进程当前状态status
  * 程序和数据地址
  * 资源清单，列出除CPU外的资源记录，如拥有的I/O设备、打开的文件列表等。
  * 进程优先级priority
  * CPU现场保护区cpustatus
  * 进程同步与通信机制

...

## 两种模式

* 水平触发模式 (Level-triggered, LT)
  同时支持blocking, non-blocking。内核告诉你一个fd已经就绪。如果你不做任何操作，内核还是会继续通知你。
* 边缘触发模式 (Edge-triggered, ET)
  只支持non-blocking。内核告诉你一个fd已经就绪，你必须做一些操作导致那个fd不再为就绪状态，否则内核不会再通知你。

## epoll和select、poll的区别

* select指定三个位图：`readfds`, `writefds`, `exceptfds`（类型均为`fd_set`），当select返回时，需要遍历这些`fd_set`。
  select存在单个进程最大fd限制，默认为1024。
* poll指定`pollfd`数组，其中包含`fd`, `events`（需要监视的事件）和`revents`（返回的事件）。poll返回时需要遍历`pollfd`数组。
* epoll的工作模式是需要调用`epoll_create`创建epoll handle，然后调用`epoll_ctrl`添加、删除或修改，最后调用`epoll_wait`，它会返回`epoll_event`数组，无须遍历整个被监听的fd列表。
