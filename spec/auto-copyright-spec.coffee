#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

TextBuffer = require 'text-buffer'

AutoCopyright = require '../lib/auto-copyright'
ConfigMissingError = require '../lib/config-missing-error'

describe 'AutoCopyright', ->
  spyOnConfig = (obj) ->
    spyOn(atom.config, 'get').andCallFake(
      (key) ->
        obj[key.replace('auto-copyright.', '')]
    )

  describe 'when retrieving copyright text', ->
    it 'gets the template from the config', ->
      spyOnConfig({'template': 'template test', 'owner': 'Test Owner'})
      expect(AutoCopyright.getCopyrightText()).toEqual("template test\n")

    it 'replaces %y with the current year', ->
      spyOnConfig({'template': '%y', 'owner': 'Test Owner'})
      spyOn(AutoCopyright, 'getYear').andReturn('3000')
      expect(AutoCopyright.getCopyrightText()).toEqual("3000\n")

    it 'replaces %o with the owner name', ->
      spyOnConfig({'template': '%o', 'owner': 'Test Owner'})
      expect(AutoCopyright.getCopyrightText()).toEqual("Test Owner\n")

    it 'has a sensible default template', ->
      spyOnConfig({'owner': 'Test Owner'})
      spyOn(AutoCopyright, 'getYear').andReturn('3000')
      expect(AutoCopyright.getCopyrightText()).
        toEqual("Copyright (c) 3000 by Test Owner. All Rights Reserved.\n")

    it 'wraps the text in buffer lines if configured', ->
      spyOnConfig({'template': '%o', 'owner': 'Test Owner', 'buffer': 1})
      expect(AutoCopyright.getCopyrightText()).toEqual("\nTest Owner\n\n")

    it 'wraps the text in unequal buffer lines if configured with an array', ->
      spyOnConfig({'template': '%o', 'owner': 'Test Owner', 'buffer': [2, 3]})
      expect(AutoCopyright.getCopyrightText()).toEqual("\n\nTest Owner\n\n\n\n")

  describe 'when detecting if the editor already has a copyright', ->
    it 'returns false on an empty file', ->
      buffer = new TextBuffer('')

      expect(AutoCopyright.hasCopyright(buffer)).toBeFalsy()

    it 'returns false on a file without a copyright notice', ->
      text = """
             #
             # Just an opening comment without a notice
             #
             """
      buffer = new TextBuffer(text)

      expect(AutoCopyright.hasCopyright(buffer)).toBeFalsy()

    it 'returns true on a file with a copyright notice', ->
      text = """
             #
             # Copyright (c) 3000 by Foo Corp. All Rights Reserved.
             #
             """
      buffer = new TextBuffer(text)

      expect(AutoCopyright.hasCopyright(buffer)).toBeTruthy()

    it 'returns false on a file with a copyright notice past the first ten lines', ->
      text = """
             \n\n\n\n\n\n\n\n\n\n
             #
             # Copyright (c) 3000 by Foo Corp. All Rights Reserved.
             #
             """
      buffer = new TextBuffer(text)

      expect(AutoCopyright.hasCopyright(buffer)).toBeFalsy()
