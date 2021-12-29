---
title: 配置nginx反向代理-解决前后端跨域问题
date: 2021-01-06 15:42:14
img:
categories: Nginx
summary: 配置nginx反向代理
tags: 
  - Nginx
  - 跨域
---


#### 1.首先电脑中安装nginx

官方网站下载地址： https://nginx.org/en/download.html



#### 2.解压下载后的文件，目录如下

<!-- ![img](/images/posts/2020-01-06-nginx.png)  -->
![img](https://github.com/tangyun-92/tangyun-92.github.io/blob/master/themes/hexo-theme-matery-master/source/medias/images/posts/2020-01-06-nginx.png?raw=true)



#### 3.打开conf文件夹下的nginx.conf

找到如下代码注释

```xml
#location / {
#    root   html;
#    index  index.html index.htm;
#}
```

找到如下代码修改

```xml
    server {
        listen       8080;
        server_name  localhost;
```

接着新增

```xml
location / {
    proxy_pass http://localhost:8001;
}

location /api/ {
    proxy_pass http://localhost:8000;
    proxy_set_header Host $host;
}
```

其中：

- proxy_pass http://localhost:8001; 表示前端被代理的域名与端口
- proxy_pass http://localhost:8000; 表示后端api接口的地址



#### 4.点击nginx.exe文件启动nginx

现在访问localhost:8080就不会出现跨域的问题了

