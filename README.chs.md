# GSMarkupParser

![build](https://travis-ci.org/geansea/GSMarkupParser.svg?branch=master)

将类 HTML/XML 标记文本解析为 NSAttributedString

语言: ![English][https://github.com/geansea/GSMarkupParser/blob/master/README.md] ![简体中文][https://github.com/geansea/GSMarkupParser/blob/master/README.chs.md]

## 效果截图

![macOS](https://raw.githubusercontent.com/geansea/GSMarkupParser/master/Screenshots/macOS.png)

## 文档

标签       | 属性            | 描述
---------- | --------------- | ----------------------------------
**font**   | name, size      | 修改字体
**b**      |                 | 加粗
**i**      |                 | 斜体
**c**      | hex             | 设置文字颜色
**u**      | hex             | 添加下划线
**s**      | hex             | 添加删除线
**shadow** | hex, x, y, blur | 添加文字阴影
**base**   | move            | 基线移动
**a**      | link            | 添加链接
**img**    | link, w, h      | 插入图片

## 详细说明

### `<font>`

用法: `<font name="" size="">Text</font>`

* **name** (可选): UIFont/NSFont 使用的字体名。如果未设置，使用当前字体名
* **size** (可选): UIFont/NSFont 使用的字号。如果未设置，使用当前字号

### `<b>`

用法: `<b>Text</b>`

* 如果当前字体已经是粗体，则不改变
* 如果当前字体没有粗体，使用**描边**效果
* 为确保效果正确，尽可能先设置 `<font>` 再设置 `<b>`

### `<i>`

用法: `<i>Text</i>`

* 如果当前字体已经是斜体，则不改变
* 如果当前字体没有斜体，使用**倾斜**效果
* 为确保效果正确，尽可能先设置 `<font>` 再设置 `<i>`

### `<c>`

用法: `<c hex="864">Text</i>`

* **hex** (必选): 描述颜色的 16 进制字串。支持 RGB / ARGB / RRGGBB / AARRGGBB 几种形式

### `<u>`

用法: `<u hex="864">Text</u>`

* **hex** (可选): 描述颜色的 16 进制字串。如果未设置，使用当前文字颜色

### `<s>`

用法: `<s hex="864">Text</s>`

* **hex** (可选): 描述颜色的 16 进制字串。如果未设置，使用当前文字颜色

### `<shadow>`

用法: `<shadow hex="864">Text</shadow>`

* **hex** (可选): 描述颜色的 16 进制字串。如果未设置，使用当前文字颜色，不透明度 1/3
* **x** (可选): 阴影横向偏移。如果未设置，为 0
* **y** (可选): 阴影纵向偏移。如果未设置，为 0
* **blur** (可选): 阴影模糊半径。如果未设置，为 0

### `<base>`

用法: `<base move="-2">Text</base>`

* **move** (必选): 基线移动距离

### `<a>`

用法: `<a link="https://github.com">Text</a>`

* **link** (必选): 链接地址

### `<img>`

用法: `<img link="@icon" w="16" h="16" />`

* **link** (必选): 图片链接。如果以 `@` 开头，从附带资源加载
* **w** (必选): 图片宽度
* **h** (必选): 图片高度

## TODO

* 添加一个简单的网络图片的支持
* 支持更多标签
