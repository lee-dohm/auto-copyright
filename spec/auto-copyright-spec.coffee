AutoCopyright = require '../lib/auto-copyright'
ConfigMissingError = require '../lib/config-missing-error'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe 'AutoCopyright', ->
  describe 'when retrieving copyright text', ->
    it 'gets the template from the config', ->
      spyOn(atom.config, 'get').andReturn('template test')
      expect(AutoCopyright.getCopyrightText()).toEqual('template test')

    it 'replaces %y with the current year', ->
      spyOn(atom.config, 'get').andReturn('%y')
      spyOn(AutoCopyright, 'getYear').andReturn('3000')
      expect(AutoCopyright.getCopyrightText()).toEqual('3000')

    it 'replaces %o with the owner name', ->
      spyOn(atom.config, 'get').andCallFake(
        (path) ->
          switch path
            when 'auto-copyright.template' then '%o'
            when 'auto-copyright.owner' then 'Test Owner'
      )
      expect(AutoCopyright.getCopyrightText()).toEqual('Test Owner')

    it 'throws an exception when there is no template set', ->
      spyOn(atom.config, 'get').andCallFake(
        (path) ->
          switch path
            when 'auto-copyright.owner' then 'Test Owner'
            else undefined
      )
      expect(AutoCopyright.getCopyrightText).toThrow()

    it 'throws an exception when there is no owner set', ->
      spyOn(atom.config, 'get').andCallFake(
        (path) ->
          switch path
            when 'auto-copyright.template' then '%o'
            else undefined
      )
      expect(AutoCopyright.getCopyrightText).toThrow()
