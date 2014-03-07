# Atom Auto-Copyright

Inserts and automatically updates the standard copyright notice at the top of the file.

## Installation

This package can be installed from Settings by searching for `auto-copyright` or can be installed from the command line by using the command: `apm install auto-copyright`.

## Features

* Inserts a copyright comment block at the beginning of the file
* Updates an existing copyright comment block if the year needs updating

## Use

### Insert

You can use the command palette, the Packages menu, the context menu in the buffer or the keymapping, <kbd>⌘K ⌘I</kbd>. This inserts the configured copyright text with the current year and configured owner text as a comment at the top of the file. The default copyright text looks like this:

```ruby
# Copyright (c) 2014 by Some Company. All Rights Reserved.
```

It can be configured to say as much or as little as you want, though.

### Update

You can use the command palette, the Packages menu, the context menu in the buffer or just let it update on save.

## Configuration

Auto Copyright supports the following configuration settings:

* `auto-copyright.buffer` &mdash; Number of blank lines before and after the copyright text. It can also be set to an array of `[before after]`. (Defaults to: `[0, 0]`)
* `auto-copyright.owner` &mdash; Owner name to use when creating the copyright text.
* `auto-copyright.template` &mdash; Copyright template to follow. `%y` will be replaced with the current year. `%o` will be replaced with the owner name. (Defaults to: `Copyright (c) %y by %o. All Rights Reserved.`)

## Copyright

Copyright &copy; 2014 [Lee Dohm](http://www.lee-dohm.com), [Lifted Studios](http://www.liftedstudios.com). See [LICENSE](LICENSE.md) for details.
