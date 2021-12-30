---
title: 使用AES实现密码加密（ECB和CBC两种模式）
categories: Javascript
summary: ECB和CBC
tags:
  - Javascript
  - Encrypt
  - Decode
abbrlink: 581db924
date: 2021-07-26 12:42:14
img:
---



### ECB 与 CBC 的区别

> **ECB：** 是一种基础的加密方式，密文被分割成分组长度相等的块（不足补齐），然后单独一个个加密，一个个输出组成密文。
> **CBC：** 是一种循环模式，前一个分组的密文和当前分组的明文异或或操作后再加密，这样做的目的是增强破解难度。（不容易主动攻击，安全性好于ECB，是SSL、IPSec的标准）

<!--more-->

### 实现

先安装 `crypto-js`

```bash
npm install crypto-js --save-dev
```

#### ECB 模式

```js
import CryptoJS from "crypto-js";

export default {
  // 加密
  encrypt(word, keyStr) {
    keyStr = keyStr ? keyStr : "admin888ijnmkijd";
    let key = CryptoJS.enc.Utf8.parse(keyStr);
    let srcs = CryptoJS.enc.Utf8.parse(word);
    let encrypted = CryptoJS.AES.encrypt(srcs, key, {
      mode: CryptoJS.mode.ECB,
      padding: CryptoJS.pad.Pkcs7
    });
    return encrypted.toString();
  },
  // 解密
  decrypt(word, keyStr) {
    keyStr = keyStr ? keyStr : "admin888ijnmkijd";
    var key = CryptoJS.enc.Utf8.parse(keyStr);
    var decrypt = CryptoJS.AES.decrypt(word, key, {
      mode: CryptoJS.mode.ECB,
      padding: CryptoJS.pad.Pkcs7
    });
    return CryptoJS.enc.Utf8.stringify(decrypt).toString();
  }
}
```

#### BCB 模式

```js
import CryptoJS from "crypto-js";

export default {
  // 加密
  encrypt(word, keyStr, ivStr) {
    keyStr = keyStr ? keyStr : "absoietlj32fai12";
    ivStr = ivStr ? ivStr : "absoietlj32fai12";
    let key = CryptoJS.enc.Utf8.parse(keyStr);
    let iv = CryptoJS.enc.Utf8.parse(ivStr);
    let srcs = CryptoJS.enc.Utf8.parse(word);

    let encrypted = CryptoJS.AES.encrypt(srcs, key, {
      iv,
      mode: CryptoJS.mode.CBC,
      padding: CryptoJS.pad.ZeroPadding
    });
    return encrypted.toString();
  },
  // 解密
  decrypt(word, keyStr, ivStr) {
    keyStr = keyStr ? keyStr : "absoietlj32fai12";
    ivStr = ivStr ? ivStr : "absoietlj32fai12";
    var key = CryptoJS.enc.Utf8.parse(keyStr);
    let iv = CryptoJS.enc.Utf8.parse(ivStr);

    var decrypt = CryptoJS.AES.decrypt(word, key, {
      iv,
      mode: CryptoJS.mode.CBC,
      padding: CryptoJS.pad.ZeroPadding
    });
    return decrypt.toString(CryptoJS.enc.Utf8);
  }
}
```

> 注意：以上两种模式中的 keyStr 的长度要不小于14位，否则解密时会显示空白

