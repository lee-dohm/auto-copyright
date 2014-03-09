#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

TextBuffer = require 'text-buffer'

describe 'Discovery', ->
  describe 'TextBuffer', ->
    it 'returns as much text as possible even if the range is too big', ->
      buffer = new TextBuffer('foo')

      expect(buffer.getTextInRange([[0, 0], [100, 100]])).toEqual('foo')

    it 'maps points as [row, column]', ->
      buffer = new TextBuffer('foo')

      expect(buffer.getTextInRange([[0, 1], [0, 3]])).toEqual('oo')
