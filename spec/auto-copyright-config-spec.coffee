#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

AutoCopyrightConfig = require '../lib/auto-copyright-config'
ConfigMissingError = require '../lib/config-missing-error'

describe 'AutoCopyrightConfig', ->
  spyOnConfig = (obj) ->
    spyOn(atom.config, 'get').andCallFake(
      (key) ->
        obj[key.replace('auto-copyright.', '')]
    )

  describe 'when getting the buffer setting', ->
    it 'returns zeros when not set', ->
      spyOnConfig({})
      config = new AutoCopyrightConfig

      expect(config.getBufferLines()).toEqual([0, 0])

    it 'returns the array when set with an array', ->
      spyOnConfig({'buffer': [1, 2, 3, 4, 5]})
      config = new AutoCopyrightConfig

      expect(config.getBufferLines()).toEqual([1, 2, 3, 4, 5])

    it 'doubles the first value if given an array with length one', ->
      spyOnConfig({'buffer': [5]})
      config = new AutoCopyrightConfig

      expect(config.getBufferLines()).toEqual([5, 5])

    it 'returns the same value for before and after if set as Number', ->
      spyOnConfig({'buffer': 5})
      config = new AutoCopyrightConfig

      expect(config.getBufferLines()).toEqual([5, 5])

  describe 'when getting the copyright template', ->
    it 'returns the default template if one is not set', ->
      spyOnConfig({})
      config = new AutoCopyrightConfig

      expect(config.getTemplate()).toEqual("Copyright (c) %y by %o. All Rights Reserved.\n")

    it 'returns whatever is set', ->
      spyOnConfig({'template': 'foo'})
      config = new AutoCopyrightConfig

      expect(config.getTemplate()).toEqual("foo\n")

  describe 'when getting the owner text', ->
    it 'throws an exception if no owner text is set', ->
      spyOnConfig({})
      config = new AutoCopyrightConfig

      expect(config.getOwner).toThrow(new ConfigMissingError('No owner text set'))

    it 'returns the owner text if it is set', ->
      spyOnConfig({'owner': 'foo'})
      config = new AutoCopyrightConfig

      expect(config.getOwner()).toEqual('foo')