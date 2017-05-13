# GSMarkupParser

![build](https://travis-ci.org/geansea/GSMarkupParser.svg?branch=master)

将类 HTML/XML 标记文本解析为 NSAttributedString

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

* **name** (可选): font name used for UIFont/NSFont. If not set, use current font name
* **size** (可选): font size used for UIFont/NSFont. If not set, use current font size

### `<b>`

用法: `<b>Text</b>`

* If font is already bold, no effect
* If font do not have bold trait, use stroke
* For right effect, write `<b>` inside `<font>` is better

### `<i>`

用法: `<i>Text</i>`

* If font is already italic, no effect
* If font do not have italic trait, use oblique
* For right effect, write `<i>` inside `<font>` is better

### `<c>`

用法: `<c hex="864">Text</i>`

* **hex** (必选): hex string for color. Support RGB / ARGB / RRGGBB / AARRGGBB

### `<u>`

用法: `<u hex="864">Text</u>`

* **hex** (可选): hex string for line color. If not set, use current color

### `<s>`

用法: `<s hex="864">Text</s>`

* **hex** (可选): hex string for line color. If not set, use current color

### `<shadow>`

用法: `<shadow hex="864">Text</shadow>`

* **hex** (可选): hex string for shadow color. If not set, use current color with alpha 0.33
* **x** (可选): shadow offset x. If not set, use 0
* **y** (可选): shadow offset x. If not set, use 0
* **blur** (可选): shadow blur radius. If not set, use 0

### `<base>`

用法: `<base move="-2">Text</base>`

* **move** (必选): move distance

### `<a>`

用法: `<a link="https://github.com">Text</a>`

* **link** (必选): link address

### `<img>`

用法: `<img link="@icon" w="16" h="16" />`

* **link** (必选): image link address. If begin with `@`, load image from bundle
* **w** (必选): image width
* **h** (必选): image height

## TODO

* 添加一个简单的网络图片的支持
* 支持更多标签
