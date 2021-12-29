---
title: vue+axios将后端返回的图片流显示到img中
date: 2021-05-26 10:34:14
img:
categories: Vue
summary: vue执行打包时将代码同时生成一个压缩文件包
tags: 
  - Vue
  - Axios
---



```js
 axios.get("接口地址", {
   responseType: "arraybuffer",
   params: 传给后端的数据
 })
   .then(response => {
   return (
     "data:image/png;base64," +
     btoa(
       new Uint8Array(response.data).reduce(
         (data, byte) => data + String.fromCharCode(byte),
         ""
       )
     )
   )
 })
   .then(data => {
   this.imgUrl = data; //赋值给img标签的src属性
 })
```