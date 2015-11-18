* bootsect.s   ---  改变字符串，如果长要改变前面的字符长度，不然显示不全
* setup.s      ---   复制bootsect.s，做相关的改动，大概如下：
   + 地址给对（bootsect.s里面写的是BOOTSEG）
   + 通过中断取到数据，存储下来
   + 提示信息模仿`loading system`输出
   + 最后用死循环，防止持续调用已经执行完的操作
* build.c      ---   默认输出有三个参数，做改变（第三个参数为none时直接返回） 
