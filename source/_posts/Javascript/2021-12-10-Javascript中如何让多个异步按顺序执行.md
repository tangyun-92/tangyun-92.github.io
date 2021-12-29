---
title: Javascript中如何让多个异步按顺序执行
date: 2021-12-10 15:42:14
img:
categories: Javascript
summary: Javascript中如何让多个异步按顺序执行
tags: 
  - Javascript
  - Promise
  - Generator
---


# 直接调用（异步调异步）



```javascript
function fn1() {
	setTimeout(() => {
		console.log('fn1执行')
		fn2('fn1传递过去的参数')
	}, 1000)
}

function fn2(data) {
	setTimeout(() => {
		console.log('fn2执行', data)
		fn3('fn2传递过去的参数')
	}, 1000)
}

function fn3(data) {
	setTimeout(() => {
		console.log('fn3执行', data)
	}, 1000)
}
fn1()
```



执行结果如下：
![img](/images/posts/2021-12-10-async-01.png)



我们发现这种方式虽然能实现，但是代码量一旦变多，可读性就降低了。



# Promise的方式



```javascript
function fn1() {
	return new Promise((resolve, reject) => {
		console.log('fn1执行')
		setTimeout(() => {
			console.log('fn1结束')
			resolve('fn1传递过去的参数')
		}, 1000)
	})
}

function fn2(data) {
	return new Promise((resolve, reject) => {
		console.log('fn2执行，接收的参数', data)
		setTimeout(() => {
			resolve('fn2传递过去的参数')
		}, 1000)
	})
}

function fn3(data) {
	return new Promise((resolve, reject) => {
		console.log('fn3执行，接收的参数', data)
		setTimeout(() => {
			resolve('fn3传递过去的参数')
		}, 1000)
	})
}

fn1().then(fn2).then(fn3).then(res => {
	console.log('最后一个', res)
})
```



执行结果如下：
![img](/images/posts/2021-12-10-async-02.png)



# 生成器的方式



生成器就是能返回一个迭代器的函数，它也是一个函数，对比普通的函数，多了一个`*`，在它的函数体内可以使用`yield`关键字,函数会在每个`yield`后暂停，等待，直到这个生成的对象，调用下一个`next()`,每调用一次`next`会往下执行一次`yieId`，然后暂停。



```javascript
function* main() {
	const res1 = yield fn1('开始')
	const res2 = yield fn2(res1)
	const res3 = yield fn3(res2)
	console.log(res3, '全部执行完毕')
}

const task = main()
task.next()

function fn1(data) {
	setTimeout(() => {
		console.log('fn1执行', data)
		task.next('fn1执行完毕')
	}, 1000)
}

function fn2(data) {
	setTimeout(() => {
		console.log('fn2执行', data)
		task.next('fn2执行完毕')
	}, 1000)
}

function fn3(data) {
	setTimeout(() => {
		console.log('fn3执行', data)
		task.next('fn3执行完毕')
	}, 1000)
}

console.log('我是最开始同步执行的')
```



执行结果如下：
![img](/images/posts/2021-12-10-async-03.png)

