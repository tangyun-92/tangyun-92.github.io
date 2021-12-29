---
title: mysql基本语句
date: 2021-07-01 11:22:39
img:
categories: Mysql
summary: mysql增删改查基本语句
tags: 
  - Mysql
  - Sql
---


```sql
-- 查看所有数据库
show databases;

-- 创建数据库
create database 数据库名 charset=utf-8;

-- 使用数据库
use 数据库名;

-- 显示所有的表
show tables;

-- 删除数据库
drop database 数据库名;

-- 创建students数据表
create table students(
  id int unsigned not null auto_increment primary key,
  name varchar(50) not null default "张三",
  age tinyint unsigned not null default 18,
  high decimal(5,2) not null,
  gender enum("男", "女", "保密")default "保密",
  cls_id int unsigned not null
);
```

### 

### 1.增



```sql
use myblog;

show tables;

insert into users(username, `password`, realname) values ('zhangsan', '123', '张三');
```



### 2.查



```sql
use myblogs;
show tables;

select * from users;  --查询所有
select id,username form users;  --查询id和username
select * from users where username='zhangsan';  --条件查询
select * from users where username='zhangsan' and `password`='123'; --并且
select * from users where username='zhangsan' or `password`='123'; --或者
select * from users where username like '%zhang%';  --模糊查询
select * from users where password like '%1%' order by id desc;  --desc表示倒序，不加默认正序
select * form users where state <> '0'; -- <>表示不等于0
select count(id) as `count` from blogs;  -- 查询总数
select * from blogs order by id desc limit 2;  -- 查询第一页的两条数据
select * from blogs order by id desc limit 2 offset 2;  -- 查询第二页的两条数据
```



### 3.改（更新）



如果遇到update users set realname...报错的话，先执行 SET SQL_SAFE_UPDATES = 0; 然后删掉再执行更新操作



```sql
update users set realname='李四2' where username='lisi';
```



### 4.删



```sql
delete from users where username='lisi';

-- 日常开发中我们通常是采用软删除
update users set state='0' where username='lisi';
```



### 5. 多表联查



```sql
select blogs.*, users.username, users.nickname
from blogs inner join users on users.id = blogs.userid
where users.username = 'lisi'
```

