#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

AutoCopyright = require '../lib/auto-copyright'
ConfigMissingError = require '../lib/config-missing-error'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

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

    it 'throws an exception when there is no owner set', ->
      spyOnConfig({'template': '%o'})
      expect(AutoCopyright.getCopyrightText).toThrow()

    it 'wraps the text in buffer lines if configured', ->
      spyOnConfig({'template': '%o', 'owner': 'Test Owner', 'buffer': 1})
      expect(AutoCopyright.getCopyrightText()).toEqual("\nTest Owner\n\n")

    it 'wraps the text in unequal buffer lines if configured with an array', ->
      spyOnConfig({'template': '%o', 'owner': 'Test Owner', 'buffer': [2, 3]})
      expect(AutoCopyright.getCopyrightText()).toEqual("\n\nTest Owner\n\n\n\n")

  describe 'when getting the buffer configuration', ->
    it 'returns zeros when not set', ->
      spyOnConfig({})
      expect(AutoCopyright.getBuffer()).toEqual([0, 0])

    it 'returns the array when set with an array', ->
      spyOnConfig({'buffer': [1, 2, 3, 4, 5]})
      expect(AutoCopyright.getBuffer()).toEqual([1, 2, 3, 4, 5])

    it 'doubles the first value if given an array with length one', ->
      spyOnConfig({'buffer': [5]})
      expect(AutoCopyright.getBuffer()).toEqual([5, 5])

    it 'returns the same value for before and after if set as Number', ->
      spyOnConfig({'buffer': 5})
      expect(AutoCopyright.getBuffer()).toEqual([5, 5])
