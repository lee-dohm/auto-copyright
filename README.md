# Auto-Copyright [![Build Status](https://travis-ci.org/lee-dohm/auto-copyright.svg?branch=master)](https://travis-ci.org/lee-dohm/auto-copyright) [![Dependency Status](https://david-dm.org/lee-dohm/auto-copyright.svg)](https://david-dm.org/lee-dohm/auto-copyright)

Inserts or updates a customizable header in the current file.

## Usage

### Insert

The `auto-copyright:insert` command adds the configured header text with replaceable fields as a comment at the top of the file. The default header text looks like this:

```coffee
#
# Copyright (c) 2015 by Placeholder Corporation. All Rights Reserved.
#
```

It can be configured to say as much or as little as you want, though.

### Update

When you execute the `auto-copyright:update` command, it updates the header text in a standard format by adding the current year to the list of years and compacting it in the following ways:

* Disjoint years are separated by commas: 2000, 2005 and 2010 are represented as `2000, 2005, 2010`
* Years in a series are represented by the start and end years separated by a hyphen: 2001, 2002 and 2003 are represented as `2001-2003`
* Mixing and matching works too: 2001, 2002, 2003, 2005 and 2010 are represented as `2001-2003, 2005, 2010`

## Configuration

Auto Copyright supports the following configuration settings:

* `auto-copyright.buffer` &mdash; Number of blank commented lines before and after the copyright text. (Defaults to: `1`)
* `auto-copyright.owner` &mdash; Owner name to use when creating the copyright text.
* `auto-copyright.template` &mdash; Header template to follow. Defaults to: `Copyright (c) {{year}} by {{owner}}. All Rights Reserved.`

The Auto Copyright template supports "fields". A field is specified in the template by surrounding a field name with two sets of braces: `{{fieldName}}`. Auto Copyright supports the following field names:

* `file` &mdash; Replaced with the current file name
* `path` &mdash; Replaced with the project-relative path of the current file
* `owner` &mdash; Replaced with the text in the `auto-copyright.owner` configuration setting
* `year` &mdash; Replaced with the current four-digit year

Multi-line templates *are* supported. At the time of this writing, Atom's Settings View does not support editing multiline configuration attributes. In order to have a multi-line template, you must manually edit your `config.cson` using the CoffeeScript multi-line string format. For example:

```coffee
'*':
  'auto-copyright':
    'template': """
      Copyright (c) {{year}} by {{owner}}. All Rights Reserved.

      Some standard boilerplate license text.
    """
```

### Commands

* `auto-copyright:insert` &mdash; Inserts the header text at the top of the file in the active editor
* `auto-copyright:update` &mdash; Updates the fields of the header text at the top of the file, if it exists

### Keybindings

No keybindings are assigned by default.

## Copyright

Copyright &copy; 2014-2015 [Lee Dohm](http://www.lee-dohm.com), [Lifted Studios](http://www.liftedstudios.com). See [LICENSE](https://github.com/lee-dohm/auto-copyright/blob/master/LICENSE.md) for details.
