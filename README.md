# GSMarkupParser

![build](https://travis-ci.org/geansea/GSMarkupParser.svg?branch=master)

An attributed string builder from simple markup language similar to HTML/XML

Language: ![English][https://github.com/geansea/GSMarkupParser/blob/master/README.md] ![简体中文][https://github.com/geansea/GSMarkupParser/blob/master/README.chs.md]

## Screenshot

![macOS](https://raw.githubusercontent.com/geansea/GSMarkupParser/master/Screenshots/macOS.png)

## Document

Tag        | Attributes      | Description
---------- | --------------- | ----------------------------------
**font**   | name, size      | Change font
**b**      |                 | Set font weight bold
**i**      |                 | Set font style italic
**c**      | hex             | Set text color
**u**      | hex             | Add text decoration underline
**s**      | hex             | Add text decoration strike through
**shadow** | hex, x, y, blur | Add text shadow
**base**   | move            | Move baseline
**a**      | link            | Add link
**img**    | link, w, h      | Add image

## Detail

### `<font>`

Usage: `<font name="" size="">Text</font>`

* **name** (Optional): font name used for UIFont/NSFont. If not set, use current font name
* **size** (Optional): font size used for UIFont/NSFont. If not set, use current font size

### `<b>`

Usage: `<b>Text</b>`

* If font is already bold, no effect
* If font do not have bold trait, use **stroke**
* For right effect, write `<b>` inside `<font>` is better

### `<i>`

Usage: `<i>Text</i>`

* If font is already italic, no effect
* If font do not have italic trait, use **oblique**
* For right effect, write `<i>` inside `<font>` is better

### `<c>`

Usage: `<c hex="864">Text</i>`

* **hex** (Required): hex string for color. Support RGB / ARGB / RRGGBB / AARRGGBB format

### `<u>`

Usage: `<u hex="864">Text</u>`

* **hex** (Optional): hex string for line color. If not set, use current color

### `<s>`

Usage: `<s hex="864">Text</s>`

* **hex** (Optional): hex string for line color. If not set, use current color

### `<shadow>`

Usage: `<shadow hex="864">Text</shadow>`

* **hex** (Optional): hex string for shadow color. If not set, use current color with alpha 1／3
* **x** (Optional): shadow offset x. If not set, use 0
* **y** (Optional): shadow offset y. If not set, use 0
* **blur** (Optional): shadow blur radius. If not set, use 0

### `<base>`

Usage: `<base move="-2">Text</base>`

* **move** (Required): move distance

### `<a>`

Usage: `<a link="https://github.com">Text</a>`

* **link** (Required): link address

### `<img>`

Usage: `<img link="@icon" w="16" h="16" />`

* **link** (Required): image link address. If begin with `@`, load image from bundle
* **w** (Required): image width
* **h** (Required): image height

## TODO

* Give a simple support for image from web
* Support more tags
