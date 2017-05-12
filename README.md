# GSMarkupParser

![build](https://travis-ci.org/geansea/GSMarkupParser.svg?branch=master)

An attributed string builder from simple markup language similar to HTML/XML

## Screen shots

![macOS]()

![iOS]()

## Document

Tag    | Attributes      | Description
------ | --------------- | ----------------------------------
font   | name, size      | Change font
b      |                 | Set font weight bold
i      |                 | Set font style italic
c      | hex             | Set text color
u      | hex             | Add text decoration underline
s      | hex             | Add text decoration strike through
shadow | hex, x, y, blur | Add text shadow
base   | move            | Move baseline
a      | link            | Add link
img    | link, w, h      | Add image

## Detail

### `<font>`

Usage: `<font name="" size="">Text</font>`

* **name** (Optional): font name used for UIFont/NSFont. If not set, use current font name
* **size** (Optional): font size used for UIFont/NSFont. If not set, use current font size

### `<b>`

Usage: `<b>Text</b>`

* If font is already bold, no effect
* If font do not have bold trait, use stroke
* For right effect, write `<b>` inside `<font>` is better

### `<i>`

Usage: `<i>Text</i>`

* If font is already italic, no effect
* If font do not have italic trait, use oblique
* For right effect, write `<i>` inside `<font>` is better
