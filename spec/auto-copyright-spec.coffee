#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

{WorkspaceView} = require 'atom'
TextBuffer = require 'text-buffer'

AutoCopyright = require '../lib/auto-copyright'
ConfigMissingError = require '../lib/config-missing-error'

describe 'AutoCopyright', ->
  describe 'inserting copyright text', ->
    [buffer, editor] = []

    beforeEach ->
      atom.workspaceView = new WorkspaceView()
      atom.workspace = atom.workspaceView.model

      spyOn(AutoCopyright, 'getYear').andReturn('3000')

      atom.config.set 'auto-copyright',
        owner: 'Test Owner'

      waitsForPromise ->
        atom.packages.activatePackage('language-coffee-script')

      waitsForPromise ->
        atom.workspace.open('sample.coffee').then (e) ->
          editor = e

    it 'inserts the copyright text', ->
      AutoCopyright.insertCopyright(editor)
      expect(editor.getText()).toBe("# Copyright (c) 3000 by Test Owner. All Rights Reserved.\n\n")

  describe 'when retrieving copyright text', ->
    it 'gets the template from the config', ->
      atom.config.set 'auto-copyright',
        template: 'template test'
        owner: 'Test Owner'

      expect(AutoCopyright.getCopyrightText()).toEqual("template test\n")

    it 'replaces %y with the current year', ->
      atom.config.set 'auto-copyright',
        template: '%y'
        owner: 'Test Owner'

      spyOn(AutoCopyright, 'getYear').andReturn('3000')
      expect(AutoCopyright.getCopyrightText()).toEqual("3000\n")

    it 'replaces %o with the owner name', ->
      atom.config.set 'auto-copyright',
        template: '%o'
        owner: 'Test Owner'

      expect(AutoCopyright.getCopyrightText()).toEqual("Test Owner\n")

    it 'has a sensible default template', ->
      atom.config.set 'auto-copyright',
        owner: 'Test Owner'

      spyOn(AutoCopyright, 'getYear').andReturn('3000')
      expect(AutoCopyright.getCopyrightText()).
        toEqual("Copyright (c) 3000 by Test Owner. All Rights Reserved.\n")

    it 'wraps the text in buffer lines if configured', ->
      atom.config.set 'auto-copyright',
        template: '%o'
        owner: 'Test Owner'
        buffer: 1

      expect(AutoCopyright.getCopyrightText()).toEqual("\nTest Owner\n\n")

    it 'wraps the text in unequal buffer lines if configured with an array', ->
      atom.config.set 'auto-copyright',
        template: '%o'
        owner: 'Test Owner'
        buffer: [2, 3]

      expect(AutoCopyright.getCopyrightText()).toEqual("\n\nTest Owner\n\n\n\n")

  describe 'when detecting if the editor already has a copyright', ->
    it 'returns false on an empty file', ->
      buffer = new TextBuffer('')

      expect(AutoCopyright.hasCopyright(buffer)).toBeFalsy()

    it 'returns false on a file without a copyright notice', ->
      buffer = new TextBuffer(
        """
        #
        # Just an opening comment without a notice
        #
        """
      )

      expect(AutoCopyright.hasCopyright(buffer)).toBeFalsy()

    it 'returns true on a file with a copyright notice', ->
      buffer = new TextBuffer(
        """
        #
        # Copyright (c) 3000 by Foo Corp. All Rights Reserved.
        #
        """
      )

      expect(AutoCopyright.hasCopyright(buffer)).toBeTruthy()

    it 'returns false on a file with a copyright notice past the first ten lines', ->
      buffer = new TextBuffer(
        """
        \n\n\n\n\n\n\n\n\n\n
        #
        # Copyright (c) 3000 by Foo Corp. All Rights Reserved.
        #
        """
      )

      expect(AutoCopyright.hasCopyright(buffer)).toBeFalsy()

  describe 'getConfig', ->
    it 'gets the configuration when called the first time', ->
      expect(AutoCopyright.getConfig()).toBeDefined()

    it 'gets the configuration when called the second time', ->
      AutoCopyright.getConfig()
      expect(AutoCopyright.getConfig()).toBeDefined()

    it 'returns the same config object both times', ->
      expect(AutoCopyright.getConfig()).toBe(AutoCopyright.getConfig())
