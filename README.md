[![Build Status](https://travis-ci.org/lee-dohm/auto-copyright.svg?branch=master)](https://travis-ci.org/lee-dohm/auto-copyright)

# Auto-Copyright

Inserts a copyright notice.

## Installation

This package can be installed from the Settings View by searching for `auto-copyright` or can be installed from the command line by using the command: `apm install auto-copyright`.

## Usage

### Insert

You can use the command palette, the Packages menu or the context menu in the buffer. This inserts the configured copyright text with the current year and configured owner text as a comment at the top of the file. The default copyright text looks like this:

```coffee
#
# Copyright (c) 2014 by Placeholder Corporation. All Rights Reserved.
#
```

It can be configured to say as much or as little as you want, though.

## Configuration

Auto Copyright supports the following configuration settings:

* `auto-copyright.buffer` &mdash; Number of blank commented lines before and after the copyright text. (Defaults to: `1`)
* `auto-copyright.owner` &mdash; Owner name to use when creating the copyright text.
* `auto-copyright.template` &mdash; Copyright template to follow. `%y` will be replaced with the current year. `%o` will be replaced with the owner name. (Defaults to: `Copyright (c) %y by %o. All Rights Reserved.`)

### Commands

* `auto-copyright:insert` &mdash; Inserts the copyright text at the top of the file in the active editor

### Keybindings

No keybindings are assigned by default.

## Copyright

Copyright &copy; 2014 [Lee Dohm](http://www.lee-dohm.com), [Lifted Studios](http://www.liftedstudios.com). See [LICENSE](LICENSE.md) for details.
