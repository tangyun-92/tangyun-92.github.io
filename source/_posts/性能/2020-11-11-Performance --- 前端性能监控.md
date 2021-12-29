---
title: Performance前端性能监控
date: 2020-11-11 12:22:39
img:
categories: 性能优化
summary: Performance前端性能监控
tags: 
  - 性能优化
  - Performance
---

### 什么是performance

performance可以获取到当前页面中与性能相关的信息，可以检测到白屏时间、首屏时间、用户可操作的时间节点、页面总下载的时间、DNS查询的时间、TCP链接的时间等。

### 前端性能主要测试点

- **白屏时间**：从打开网站到有内容渲染出来的时间点
- **首屏时间**：首屏内容渲染完毕的时间节点

- **用户可操作时间节点**：domready触发节点
- **总下载时间**：window.onload的触发节点

新建个demo.html

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>performance演示</title>
</head>
<body>
  <script>
    var performance = window.performance || window.msPerformance || window.webkitPerformance
    if (performance) {
      console.log(performance)
    }
  </script>
</body>
</html>
```

此时在控制台打印出如下信息：
<!-- ![array.png](/images/posts/performance-2020.png) -->
![img](https://github.com/tangyun-92/tangyun-92.github.io/blob/master/themes/hexo-theme-matery-master/source/medias/images/posts/performance-2020.png?raw=true)


其中 memory 是和内存相关的，navigation 是指来源相关的，timing是关键点时间。

- **performance.memory** 含义是显示此刻内存占用的情况

- - **jsHeapSizeLimit** 表示内存大小的限制
  - **totalJSHeapSize** 表示总内存的大小

- - **usedJSHeapSize** 表示可使用的内存大小
  - 如果 usedJSHeadSize 大于 totalJSHeadSize 的话，那么会出现内存泄露的问题，因此不允许出现这种情况

- **performance.navigation** 含义是页面的来源信息

- - **redirectCount** 如果有重定向，页面通过几次重定向跳转而来，默认为0
  - **type** 表示页面打开方式，默认为0，可取值为0、1、2、255

- - - **0** (TYPE_NAVIGATE) 表示正常进入该页面（非刷新、非重定向）
    - **1** (TYPE_RELOAD) 表示通过window.location.reload刷新的页面

- - - **2** (TYPE_BACK_FORWARD) 表示通过浏览器的前进、后退按钮进入的页面
    - **255** (TYPE_RESERVED) 表示非以上方式进入页面

- **performance.onresourcetimingbufferfull** 一个回调函数，会在浏览器的资源时间性能缓冲区满了的时候执行
- **performance.timeOrigin** 是一系列时间点的基准点，精确到万分之一毫秒，动态的，刷新页面会改变

- **performance.timing** 是一系列关键时间点，包含网络、解析等一系列时间数据

- - **navigationStart** 同一个浏览器上一个页面卸载结束时的时间戳。如果没有上一个页面，那么该值会和fetchStart的值相同
  - **redirectStart** 第一个http重定向开始的时间戳，如果没有重定向，或重定向到同一个不同的源，那么返回0

- - **redirectEnd** 最后一个http重定向完成时的时间戳。如果没有重定向，或重定向到一个不同的源，那么返回为0
  - **fetchStart** 浏览器准备好使用http请求抓取文档的时间（发生在检查本地缓存之前）

- - **domainLookupStart** DNS域名查询开始时间，如果使用了本地缓存或持久链接，该值则与fetchStart相同
  - **domainLookupEnd** DNS域名查询结束时间，如果使用了本地缓存或持久链接，该值则与fetchStart相同

- - **connectStart** http开始建立连接的时间，如果是持久链接的话，该值和fetchStart值相同，如果再在传输层发生了错误且需要重新建立链接的话，那么在这里显示的是新建立的链接开始时间
  - **secureConnectionStart** https链接开始的时间，如果不是安全链接，则值为0

- - **connectEnd** http完成建立链接的时间（完成握手），如果是持久链接的话，该值和fetchStart值相同，如果再在传输层发生了错误且需要重新建立链接的话，那么在这里显示的是新建立的链接开始时间
  - **requestStart** http请求读取真实文档开始的时间，包括从本地读取缓存，链接错误重连时

- - **responseStart** 开始接收到响应的时间（获取到第一个字节的时候），包括从本地读取缓存
  - **responseEnd** http响应全部接收完成时的时间（获取到最后一个字节）包括从本地读取缓存

- - **unloadEventStart** 前一个网页（和当前页面同域）unload的时间戳，如果没有前一个网页或前一个网页是不同的域的话，那么该值为0
  - **unloadEventEnd** 与unloadEventStart对应，返回是前一个网页unload事件绑定的回调函数执行完毕时间戳

- - **domLoading** 开始解析渲染DOM树的时间
  - **domInteractive** 完成解析DOM树的时间（只是DOM树解析完成，但是并没有开始加载网页的资源）

- - **domContentLoadedEventStart** DOM解析完成后，网页内资源加载开始的时间
  - **domContentLoadedEventEnd** DOM解析完成后，网页内资源加载完成的时间

- - **domComplete** DOM树解析完成，且资源也准备就绪的时间。Document.readyState变为complete，并将抛出readystatechange相关事件
  - **loadEventStart** load事件发送给文档。也即load回调函数开始执行的时间，如果没有绑定load事件，则该值为0

- - **loadEventEnd** load事件的回调函数执行完毕时间，如果没有绑定load事件，该值为0

### 测试点代码

```js
重定向耗时 = redirectEnd - redirectStart
DNS查询耗时 = domainLookupEnd - domainLookupStart
TCP链接耗时 = connectEnd - connectStart
HTTP请求耗时 = responseEnd - responseStart
解析dom树耗时 = domComplete - domInteractive
白屏时间 = responseStart - navigationStart
DOMready时间 = domContentLoadedEventEnd - navigationStart
onload时间 = loadEventEnd - navigationStart
```

#### 封装计算方式

```js
function getPerformanceTiming() {
	var performance = window.performance
  if (!performance) {
  	console.log('你的浏览器不支持performance属性')
    return
  }
  var t = performance.timing
  var obj = {
  	timing: performance.timing
  }
  // 重定向耗时
  obj.redirectTime = t.redirectEnd - t.redirectStart
  
  // DNS查询耗时
  obj.lookupDomainTime = t.domainLookupEnd - t.domainLookupStart
  
  // TCP链接耗时
  obj.connectTime = t.connectEnd - t.connectStart
  
  // HTTP请求耗时
  obj.requestTime = t.responseEnd - t.responseStart
  
  // 解析dom树耗时
  obj.domReadyTime = t.domComplete - t.domInteractive
  
  // 白屏时间耗时
  obj.whiteTime = t.responseStart - t.navigationStart
  
  // DOMready时间
  obj.domLoadTime = t.domContentLoadedEventEnd - t.navigationStart
  
  // 页面加载完成的时间：即onload时间
  obj.loadTime = t.loadEventEnd - t.navigationStart
  
  return obj
}

var obj = getPerformanceTiming()
console.log(obj)
```

