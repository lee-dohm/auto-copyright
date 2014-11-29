#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

fs = require 'fs-plus'
path = require 'path'
temp = require 'temp'
{WorkspaceView} = require 'atom'

AutoCopyright = require '../lib/auto-copyright'

describe 'AutoCopyright', ->
  [buffer, editor] = []

  beforeEach ->
    directory = temp.mkdirSync()
    atom.project.setPath(directory)
    atom.workspaceView = new WorkspaceView()
    atom.workspace = atom.workspaceView.model
    filePath = path.join(directory, 'sample.coffee')
    fs.writeFileSync(filePath, '')

    atom.config.set('auto-copyright.template', 'Copyright (c) %y by %o. All Rights Reserved.')
    atom.config.set('auto-copyright.buffer', 0)

    waitsForPromise ->
      atom.packages.activatePackage('language-coffee-script')

    waitsForPromise ->
      atom.workspace.open('sample.coffee').then (e) ->
        editor = e
        buffer = editor.getBuffer()

  describe 'inserting copyright text', ->
    beforeEach ->
      spyOn(AutoCopyright, 'getYear').andReturn('3000')

      atom.config.set('auto-copyright.owner', 'Test Owner')

    it 'inserts the copyright text', ->
      AutoCopyright.insertCopyright(editor)
      expect(editor.getText()).toBe("# Copyright (c) 3000 by Test Owner. All Rights Reserved.\n\n")

    it 'inserts the copyright text at the beginning of the file', ->
      editor.setText("foo\nbar\nbaz\nquux\n")
      editor.moveToBottom()

      AutoCopyright.insertCopyright(editor)
      expect(editor.getText()).toEqual """
      # Copyright (c) 3000 by Test Owner. All Rights Reserved.

      foo
      bar
      baz
      quux

      """

    it 'places the cursor at the same relative position after inserting', ->
      editor.setText("foo\nbar\nbaz\nquux\n")
      editor.moveToBottom()

      AutoCopyright.insertCopyright(editor)
      position = editor.getCursorBufferPosition()
      editor.moveToBottom()

      expect(position).toEqual editor.getCursorBufferPosition()

  describe 'when retrieving copyright text', ->
    it 'gets the template from the config', ->
      atom.config.set 'auto-copyright',
        template: 'template test'
        owner: 'Test Owner'
        buffer: 0

      expect(AutoCopyright.getCopyrightText()).toEqual("template test\n")

    it 'replaces %y with the current year', ->
      atom.config.set 'auto-copyright',
        template: '%y'
        owner: 'Test Owner'
        buffer: 0

      spyOn(AutoCopyright, 'getYear').andReturn('3000')
      expect(AutoCopyright.getCopyrightText()).toEqual("3000\n")

    it 'replaces %o with the owner name', ->
      atom.config.set 'auto-copyright',
        template: '%o'
        owner: 'Test Owner'
        buffer: 0

      expect(AutoCopyright.getCopyrightText()).toEqual("Test Owner\n")

    it 'wraps the text in buffer lines if configured', ->
      atom.config.set 'auto-copyright',
        template: '%o'
        owner: 'Test Owner'
        buffer: 1

      expect(AutoCopyright.getCopyrightText()).toEqual("\nTest Owner\n\n")

  describe 'when detecting if the editor already has a copyright', ->
    it 'returns false on an empty file', ->
      expect(AutoCopyright.hasCopyright(buffer)).toBeFalsy()

    it 'returns false on a file without a copyright notice', ->
      buffer.setText(
        """
        #
        # Just an opening comment without a notice
        #
        """
      )

      expect(AutoCopyright.hasCopyright(buffer)).toBeFalsy()

    it 'returns true on a file with a copyright notice', ->
      buffer.setText(
        """
        #
        # Copyright (c) 3000 by Foo Corp. All Rights Reserved.
        #
        """
      )

      expect(AutoCopyright.hasCopyright(buffer)).toBeTruthy()

    it 'returns false on a file with a copyright notice past the first ten lines', ->
      buffer.setText(
        """
        \n\n\n\n\n\n\n\n\n\n
        #
        # Copyright (c) 3000 by Foo Corp. All Rights Reserved.
        #
        """
      )

      expect(AutoCopyright.hasCopyright(buffer)).toBeFalsy()
