---
title: nodejs开发，使用ORM框架Sequelize
categories: Node
summary: nodejs开发，使用ORM框架Sequelize
tags:
  - Node
  - Sequelize
  - ORM
abbrlink: 7ce09458
date: 2020-09-06 16:32:14
img:
---


### 一、什么是ORM



对象关系映射（Object Relational Mapping，简称ORM）是通过使用描述对象和数据库之间映射的元数据，将面向对象语言程序中的对象自动持久化到关系数据库中。本质上就是将数据从一种形式转换到另外一种形式。 这也同时暗示着额外的执行开销；然而，如果ORM作为一种中间件实现，则会有很多机会做优化，而这些在手写的持久层并不存在。 更重要的是用于控制转换的元数据需要提供和管理；但是同样，这些花费要比维护手写的方案要少；而且就算是遵守ODMG规范的对象数据库依然需要类级别的元数据。

<!--more-->

ORM 技术是在对象和数据库之间提供了一条桥梁，前台的对象型数据和数据库中的关系型的数据通过这个桥梁来相互转化。



不同的编程语言，有不同的ORM框架。例如Java，它的ORM框架就有：Hibernate，Ibatis/Mybatis等等。在Node Web开发中，Sequelize 就是一款比较流行的 ORM 框架。



### 二、安装相关插件



- npm i sequelize mysql2 -d



### 三、Sequelize的使用



#### 1. 创建连接对象， 并模块化

```javascript
/* seq.js */
const Sequelize = require('sequelize')

const conf = {
    host: 'localhost',
    dialect: 'mysql'
}

const seq = new Sequelize('koa2_weibo_db', 'root', '1233456', conf)

module.exports = seq
```



#### 2. 定义数据表结构

```javascript
/* model.js */
const Sequelize = require('sequelize')
const seq = require('./seq')

// 创建 User 模型，数据表的名字是users
const User = seq.define('user', {
    // id会自动创建，并设为主键、自增
    userName: {
        type: Sequelize.STRING,  // varchar(255)
        allowNull: false
    },
    password: {
        type: Sequelize.STRING,
        allowNull: false
    },
    nickName: {
        type: Sequelize.STRING,
        comment: '昵称'  // 注释
    }
    // 会自动创建 createdAt 和 updatedAt
})

// 创建 Blog 模型
const Blog = seq.define('blog', {
    title: {
        type: Sequelize.STRING,
        allowNull: false
    },
    content: {
        type: Sequelize.STRING,
        allowNull: false
    },
    userId: {
        type: Sequelize.INTEGER,
        allowNull: false
    }
})

// 外键关联
Blog.belongsTo(User, {
    // 创建外键 Blog.userId -> User.id
    foreignKey: 'userId'
})
User.hasMany(Blog, {
    // 创建外键 Blog.userId -> User.id
    foreignKey: 'userId'
})

module.exports = {
    User,
    Blog
}
```



#### 3. 同步数据表结构

```javascript
/* sync.js */
const seq = require('./seq')
require('./model')

// 测试连接
seq.authenticate().then(() => {
    console.log('ok')
}).catch(() => {
    console.log('err')
})

// 同步表结构
seq.sync({
    force: true  // 强制同步，先删除表，然后新建
}).then(() => {
    console.log('sync ok')
    process.exit()
})
```


