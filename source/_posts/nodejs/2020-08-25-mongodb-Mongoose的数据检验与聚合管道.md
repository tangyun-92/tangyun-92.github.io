---
title: Mongoose的数据检验与聚合管道
date: 2020-08-25 16:42:14
img:
categories: Mongodb
summary: Mongoose的数据检验与聚合管道
tags: 
  - Mongodb
  - Mongoose
  - Node
---

### 一、什么是mongoose的数据检验

用户通过mongoose给mongodb数据库增加数据的时候，对数据的合法性进行的验证

### 二、mongoose校验参数

- required：表示这个数据必须传入
- max：用于Number类型， 最大值

- min：用于Number类型， 最小值
- enum：枚举类型，要求数据必须满足枚举值enum:['0', '1', '2']

- match：增加的数据必须符合match（正则）的规则
- maxlength：最大长度

- minlength：最小长度

```javascript
var mongoose = require('mongoose')

var UserSchema = mongoose.Schema({
    name: {
        type: String,  // 指定类型
        trim: true,  // 修饰符，去除左右空格
        required: true,  // 表示必须传入
        validate(name) {  // 自定义校验器
            return name.length >= 2
        }
    },
    sn: {
        type: String,
        index: true,  // 索引
        set(val) {  // 自定义修饰符
            return val
        },
        minlength: 10,  // 最小长度
        maxlength: 30,  // 最大长度
        match: /^sn(.*)i/  // 正则：要求必须以sn开头，忽略大小写
    },
    age: {
        type: Number,
        min: 0,  // 最小值
        max: 150, // 最大值
    },
    status: {
        type: Number,
        default: 1,  // 默认值
        enum: [0, 1, 2, 3]  // status的值必须在枚举的数组中
    }
})

module.exports = mongoose.model('Users', UserSchema, 'users')
```

### 三、mongoose的聚合管道

#### 1.order表关联order_item

```javascript
var OrderModel = require('./model/order')

// 查询order表中每个订单的商品
OrderModel.aggregate([
    {
        $lookup: {
            from: 'order_item',  // 表示被关联的表
            localField: 'order_id',  // 关联条件
            foreignField: 'order_id',
            as: 'items'  // 将查询到的数据放入items
        }, {
            $match: { 'all_price': { $gte: 90 } }  // 表示条件为all_price>=90
        }
    }
]， (err, docs) => {
    if (err) return console.log(err)
    console.log(JSON.stringify(docs))
})
```

#### 2.order_item关联order

```javascript
/* 查询order_item找出商品名称是酸奶的商品，对应的订单的订单号，以及订单的总价 */
var OrderItemModel = require('./model/order_item')
var OrderModel = require('./model/order')
var mongoose = require('mongoose')

// 方法一：
OrderItemModel.find({'_id': '5eff4d743dd01fc7bce3b2bb'}, (err, docs) => {
    console.log(docs)
    
    var order_item = JSON.parse(JSON.stringify(docs))
    var order_id = docs[0].order_id
    
    OrderModel.find({'order_id': order_id}, (err, docs) => {
        order_itme[0].order_info = docs[0]
        console.log(order_item)
    })
}) 

// 方法二：
// mongoose中获取ObjectId:mongoose.Types.ObjectId
OrderItemModel.aggregate([
    {
        $lookup: {
            from: 'order',  // 表示被关联的表
            localField: 'order_id',  // 关联条件
            foreignField: 'order_id',
            as: 'order_info',  // 将查询到的数据放入order_info
        }
    }, {
        $match: {_id: mongoose.Types.ObjectId('5eff4d743dd01fc7bce3b2bb')}
    }
], (err, docs) => {
    console.log(JSON.stringify(docs))
})
```

#### 3.多表关联

```javascript
var ArticleModel = require('./model/article')

/* 查询文章信息，并显示文章的分类以及文章的作者的信息 */
ArticleModel.aggregate([
    {
        $lookup: {
            from: 'articlecate',
            localField: 'cid',
            foreignField: '_id',
            as: 'cate'
        }
    }, {
        $lookup: {
            from: 'user',
            localField: 'author_id',
            foreignField: '_id',
            as: 'user'
        }
    }
], (err, docs) => {
    console.log(JSON.stringify(docs))
})
```
