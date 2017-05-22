---
title: 高性能集群搭建指南（一） - CentOS安装
date: 2017-05-15 22:05:49
tags:
categories:
- Linux
---

## 写在前面

从参加超算竞赛起才接触到linux的世界，走了不少弯路，把一些小白学习时的心得记录下来，希望能对大家会有一些帮助。
因为出发点是详细地说明，所以篇幅会比较长。其实集群的搭建工作中涉及到的东西也很有限，不过在学习完这些以后，大概就会有一种稍微入门的感觉了。

一些建议

- 多探索，勤google，不明白的地方随手看看 man。
- 学习时最好能明白其中的机制，不要觉得能用了就ok了。如果似懂非懂的话，在平时的使用过程中会重新出现很多问题，解决起来费时费力；在比赛中这个问题会更加严重，千里之堤，溃于蚁穴。（我觉得我这方面没有做好 QAQ ）
- 数据做好备份，系统内重要文件在修改前务必先备份，修改的地方加上注释便于他人查看。

推荐的文档

   - `man`   `man -k <command>` 
   - [鸟哥的Linux私房菜：](http://cn.linux.vbird.org/)http://cn.linux.vbird.org/<br>
   - [RedHat的相关文档:](https://access.redhat.com/documentation/zh_cn/red-hat-enterprise-linux/?version=7/)https://access.redhat.com/documentation/zh_cn/red-hat-enterprise-linux/?version=7/
 

---
## 测试环境

---
## 准备工作

### 1. 制作U盘启动盘

#### 1.1 下载 ISO 文件

推荐[清华的镜像站:](https://mirrors.tuna.tsinghua.edu.cn/)速度较快http://mirrors.tuna.tsinghua.edu.cn/centos/7/isos/x86_64/CentOS-7-x86_64-Everything-1611.iso 

#### 1.2 dd 命令

在Windows下也可以通过一些工具制作U盘启动盘。如 `rufus-2.12` ， `UltraISO` 。


在linux下可以直接通过 `dd` 命令来实现，dd 的作用是用指定大小的块拷贝一个文件，和 `cp` 以字节方式读取的方式相比， `dd` 则是以扇区方式来读取，拷贝后的数据的排列方式保持不变。

```
$ dd if=CentOS-7-x86_64-Everything-1611.iso of=/dev/sdb1 bs=4M
```

---
## BIOS 介绍

ASC比赛官方制定服务器一般是浪潮NF系列的机架式服务器，以下简单介绍一下 `BIOS` 中需要注意和修改的地方。

服务器一般会进入两次开机界面，在第二次开机界面时，按照提示，按 `F11` 可以选择启动方式；  `Del` 可以进入 `BIOS` 设置菜单。

进入 `BIOS` 后界面如下：

![](picture/bios/setup.png)

在BIOS中需要改动的地方不多，主要是涉及到服务器性能的一些选项，

在 `chipset` 菜单中，选择 `Processor Configuration`

![](picture/bios/chipset.png)

将 `Hyper Threading Technology` 和 `VMX` 修改为Disable

![](picture/bios/chipset-1.png)

在 `chipset` 菜单中，选择 `Processor Configuration`
将 `Power Technology` 置于 `Performance` 模式下。
![](picture/bios/chipset-2.png)


在 `boot` 菜单中，修改启动顺序，优先启动U盘；也可以在开机界面选择启动方式。

最后保存并退出 `Save Changes and Exit` 。
![](picture/bios/save.png)

---

## CentOS 安装

在系统进入U盘启动后，选择 `Install CentOS Linux 7`
![](picture/centos/1.png)

之后进入语言选择界面，选择默认的英文。
>语言的话比较推荐英文。由于笔者英文很渣，初学的时候用装的是中文，后来在写expect脚本的时候，发现装中文确实不合适。

![](picture/centos/2.png) 

在安装选项中，我们需要设置 `SOFTWARE SELECTION`， `INSTALLATION DESTINATION`， `KDUMP`， `NETWORK & HOST NAME`；以下一一介绍说明。

- SOFRWARE SELECTION

![](picture/centos/3.png) 

这一部分是安装系统的时候同时会安装的软件，以下是王鹿鸣学长推荐的额外需要的软件清单。


1. Compatibility Libraries  
2. Development Tools  
3. FTP Server  
4. File an Storage Server  
5. Hardware Monitoring Utilities
6. Infiniband Support  
7. Network File System Client

![](picture/centos/3-1.png) 

![](picture/centos/3-2.png)

![](picture/centos/3-3.png)


- INSTALLATION DESTINATION

![](picture/centos/4.png)

选择系统安装的位置，选择一块磁盘。（注意那个只有 16G的是U盘，可别选上了， 如果配了多块硬盘，那就都选上吧）

然后选择自定义分区。（如果是让系统自己分区的话，发现分的结果并不理想，它会把 `/home` 目录独立分区）

自定义分区时，选择标准分区。 `swap` 的大小一般和内存大小保持一致；剩下的空间全部分给 `/` 目录； 如果之前U盘启动选择了 UEFI方式，在这里需要分配200M空间给 `/boot`。
![](picture/centos/4-1.png)

![](picture/centos/4-2.png)

![](picture/centos/4-3.png)

![](picture/centos/4-4.png)

- NETWORK & HOST NAME

![](picture/centos/5.png)

如果已经插上网线的话，我们可以启动该网口,这里它会以 `DHCP` 的方式自动配置网络。之后在系统配置时，我们还需要进一步配置静态IP。在这里启动该网口后，该网口的配置文件中的 `onboot` 选项会置于 yes，后面就不需要改动这个选项了。

`Host name` 修改后需要 `Apply` 才会生效。

![](picture/centos/5-1.png)

- KDUMP

kdump是在系统崩溃、死锁或者死机的时候用来转储内存运行参数的一个工具和服务，在这里选择关闭。

![](picture/centos/6.png)

![](picture/centos/6-1.png)

之后选择 `Begin Installation`

![](picture/centos/7.png)

设置 root 和 管理员用户密码

![](picture/centos/8.png)

![](picture/centos/9.png)


之后系统会进入安装过程，在其他的教程里面，大家会说这时候你可以去喝一杯咖啡了；你以为真的可以去和咖啡啦？在进行这一步的时候我们需要去装下一台服务器了 o_O

![](picture/centos/10.png)

<br>

装完之后它是这个样子，需要重启一下

![](picture/centos/11.png)

重启过后接受许可证，系统安装部分就OK了。

![](picture/centos/12.png)

![](picture/centos/13.png)

我们按 `Ctrl` + `Alt` + `F2` 进入字符界面，然后就可以开心地进行下一步的系统配置工作啦 `ˋ(′～｀")ˊ `