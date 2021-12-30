---
title: Cent OS 系统安装 Mysql
categories: Mysql
summary: Cent OS 系统安装 Mysql
tags:
  - Mysql
  - Cent OS
abbrlink: d33be7ca
date: 2021-07-17 10:42:39
img:
---


### Linux目录结构

- bin：存放可执行的二进制程序
- dev：硬件文件

- etc：程序的配置文件
- home：用户目录

- proc：存放运行的进程
- root：root账户的用户目录

- sbin：可执行的二进制文件，只能又root账户执行
- tmp：系统的临时文件

- usr：用户安装的程序
- var：存放程序或者系统的日志文件

<!--more-->


### 新装Cent OS系统，关闭SELinux

SELinux是Linux2.6以上版本捆绑的一个安全模块，配置复杂，容易跟其他程序冲突，所以建议关闭

```bash
vi /etc/selinux/config
```

设置 SELINUX=disabled，重启系统



### 替换yum源为国内镜像

```bash
curl -o /etc/yum.repos.d/CentOS-Base.repo mirrors.163.com/.help/CentOS7-Base-163.repo

# 更新缓存
yum clean all
yum makecache
```



### 安装MySQL

下载rpm文件

```bash
yum localinstall https://repo.mysql.com//mysql80-community-release-el7-1.noarch.rpm
```

安装MySQL数据库

```bash
yum install mysql-community-server -y
```

修改/var/lib/mysql目录访问权限

```bash
chmod -R 777 /var/lib/mysql/
```

初始化数据库

```bash
mysqld --initialize
chmod -R 777 /var/lib/mysql/*
```

### 

### 启动MySQL

```bash
service mysqld start
```

查询临时登录密码

```bash
grep 'temporary password' /var/log/mysqld.log
```

### 

### 修改root密码

```bash
alter user user() identified by '密码';
```



### 允许root远程登录

```sql
use mysql;
UPDATE user SET host="%" WHERE user="root";
FLUSH PRIVILEGES;
```

在/etc/my.cnf文件增加

```plain
character_set_server = utf8  # 数据库字符集
bind-address = 0.0.0.0  # 允许任何ip地址连接
```

重启mysql

```bash
service mysqld restart
```

### 

### 系统防火墙开放3306端口

```bash
firewall-cmd --zone=public --add-port=3306/tcp --permanent
firewall-cmd --reload
```



