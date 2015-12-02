* 按照给定的模板写process.c，主要写main函数创建进程，然后在Linux-0.11上编译测试运行结果
* 在还没开始fork的时候，即进程0中进行log文件的打开，与文件描述符3相关联  --- init/main.c
   + 进程0和1的文件描述符肯定和log相关联
   + 理论上后面的进程都会继承1，但是后面会在/bin/sh重新初始化，所以只有0和1相关联
* 写log文件
   + 和printk功能类似，代码放在 kernel/printk.c
   + 代码给出
* 跟踪进程运动轨迹
   + 滴答
     - 维护全局变量jiffies --- 记录从开机到当前时间的时钟中断发生次数 kernel/sched.c
     - set_intr_gate(0x20,&timer_interrupt)  sched_init里面时间中断处理函数
     - incl jiffies            # 增加时钟中断发生次数的值---滴答数  kernel/system_call里    10ms产生一个滴答
   + 寻找状态切换点
     - sys_fork 实现了fork功能  kernel/system_call里
     - copy_process 真正意义上实现来进程的创建  kernel/fork.c里面
     - 在 copy_process 中输出新建+就绪 log
     - 记录睡眠 sleep_on() interruptible_sleep_on() kernel/sched.c
     - 一系列的记录Log
   + 编译取出Log分析
   + 修改时间片分析Log变化

