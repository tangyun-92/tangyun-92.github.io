---
title: Mongoose索引、Mongoose内置CURD方法、扩展Mongoose Model的静态方法和实例方法
categories: Mongodb
summary: Mongoose索引等
tags:
  - Mongodb
  - Mongoose
  - Node
abbrlink: c74742f2
date: 2020-08-25 18:42:14
img:
---


### 一、Mongoose索引

索引是对数据库表中一列或多列的值进行排序的一种结构，可以让我们查询数据库变得更快。MongoDB的索引几乎与传统的关系型数据库一模一样，这其中也包括一些基本的查询优化技巧。

<!--more-->

mongoose中除了以前创建索引的方式，我们也可以在定义Schema的时候指定创建索引。

```javascript
var mongoose = require('mongoose')

var UserSchema = mongoose.Schema({
    name: String,
    sn: {
        type: String,
        index: true  // 将sn作为索引
    }，
    age: Number,
    status: {
        type: Number,
        default: 1
    }
})

module.exports = mongoose.model('Users', UserSchema, 'users')
```

### 二、Mongoose内置CURD

[mongoosejs.com/docs/querie…](https://mongoosejs.com/docs/queries.html)

- Model.deleteMany()
- Model.deleteOne()

- Model.find()
- Model.findById()

- Model.findByIdAndDelete()
- Model.findByIdAndRemove()

- Model.findByIdAndUpdate()
- Model.findOne()

- Model.findOneAndDelete()
- Model.findOneAndRemove()

- Model.findOneAndUpdate()
- Model.replaceOne()

- Model.updateOne()
- Model.updateMany()

### 三、自定义封装静态方法

```javascript
/* model中的user.js */
// 静态方法
UserSchema.statics.findBySn = function(sn, cb) {
    // 通过find方法获取sn的数据，this关键字获取当前的model
    this.find({'sn':sn}, (err, docs) => {
        cb(err, docs)
    })
}

/* 根目录下的user.js */
UserModel.findBySn('123456781', (err, docs) => {
    if (err) return console.log(err)
    console.log(docs)
})
```

### 四、自定义封装实例方法

```javascript
/* model中的user.js */
// 实例方法（基本不用）
UserSchema.methods.printA = function () {
    console.log('我是一个实例方法')
    console.log(this.name)
}

/* 根目录下的user.js */
/var user = new UserModel({
    name: 'ww',
    sn: '123456782',
    age: 18
})
user.printA()  // 自定义的实例方法
```

