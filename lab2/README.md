* include/linux/sys.h 仿照添加  两处
* include/unistd.h    添加系统调用号
* kernel/system_call.s 改变系统调用总数
* kernel/who.c         写要实现的系统调用函数   需要include/asm/segment.h 帮助调用输入输出
* kernel/Makefile      修改，让who.c和其他代码编译在一起
