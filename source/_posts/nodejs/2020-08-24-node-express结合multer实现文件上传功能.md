---
title: express结合multer实现文件上传功能
categories: Express
summary: express结合multer实现文件上传功能
tags:
  - Express
  - Node
  - multer
abbrlink: 2a655ab9
date: 2020-08-24 15:42:14
img:
---


#### 单文件上传

```html
<!--add.ejs-->
<form action="/admin/nav/doAdd" method="post" enctype="multipart/form-data">
    标题：<input type="text" name="title" id="title"><br><br>
    图片：<input type="file" name="pic" id="pic"><br><br>
    描述：<textarea name="desc" id="desc" cols="30" rows="10"></textarea><br><br>
    <input type="submit" value="提交">
</form>
```

<!--more-->

```javascript
// nav.js文件中
const express = require('express')
const tools = require('../../model/tools')

router.post('/doAdd', tools.multer().single('pic'), (req, res) => {
    // 获取表单传过来的数据
    res.send({
        body: req.body,
        file: req.file
    })
})
// tools.js工具
const multer = require('multer')
const path = require('path')
const sd = require('silly-datetime')
const mkdirp = require('mkdirp')

let tools = {
    /* 封装图片上传 */
    multer() {
        var storage = multer.diskStorage({
            // 配置上传的目录
            destination: async (req, file, cb) => {
                // 1. 获取当前日期 20200703
                let day = sd.format(new Date(), 'YYYYMMDD')
                // static/upload/20200703
                let dir = path.join('static/upload', day)

                // 2. 按照日期生成图片存储目录
                await mkdirp(dir)  // mkdirp是一个异步方法

                cb(null, dir)
            },
            // 修改上传后的文件名
            filename: function (req, file, cb) {
                // 获取上传文件的后缀名
                let extname = path.extname(file.originalname)
                cb(null, Date.now() + extname)
            }
        })
        var upload = multer({ storage: storage })
        return upload
    },
    md5() { }
}

module.exports = tools
```

#### 多文件上传

```javascript
// user.js多文件上传
const express = require('express')
const tools = require('../../model/tools')

var router = express.Router()

router.get('/', (req, res) => {
    res.send('用户列表')
})
router.get('/add', (req, res) => {
    res.render('admin/user/add')
})

// 多文件上传
let cpUpload = tools.multer().fields([{ name: 'pic1', maxCount: 1 }, { name: 'pic2', maxCount: 1 }])

router.post('/doAdd', cpUpload, (req, res) => {
    res.send({
        body: req.body,
        files: req.files
    })
})

module.exports = router
```

