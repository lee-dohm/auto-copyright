#
# Copyright (c) 2014-2015 by Lifted Studios. All Rights Reserved.
#

AutoCopyright = require '../lib/auto-copyright'

describe 'AutoCopyright', ->
  [editor] = []

  beforeEach ->
    atom.config.set('auto-copyright.template', 'Copyright (c) %y by %o. All Rights Reserved.')
    atom.config.set('auto-copyright.buffer', 0)

    spyOn(Date.prototype, 'getFullYear').andReturn 3000

    waitsForPromise -> atom.packages.activatePackage('language-coffee-script')
    waitsForPromise -> atom.workspace.open('sample.coffee').then (e) -> editor = e

  describe 'inserting copyright text', ->
    beforeEach ->
      atom.config.set('auto-copyright.owner', 'Test Owner')

    it 'inserts the copyright text', ->
      AutoCopyright.insertCopyright(editor)
      expect(editor.getText()).toBe("# Copyright (c) 3000 by Test Owner. All Rights Reserved.\n\n")

    it 'inserts the copyright text at the beginning of the file', ->
      editor.setText("foo\nbar\nbaz\nquux\n")
      editor.moveToBottom()

      AutoCopyright.insert()
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

      AutoCopyright.insert()
      position = editor.getCursorBufferPosition()
      editor.moveToBottom()

      expect(position).toEqual editor.getCursorBufferPosition()

    it 'can handle multiple line templates', ->
      editor.setText('')
      atom.config.set 'auto-copyright.template',
        """
        Test %y %o

        Testy
        test
        """

      AutoCopyright.insert()
      expect(editor.getText()).toEqual """
        # Test 3000 Test Owner
        #\u0020
        # Testy
        # test


        """

  describe 'updating copyright text', ->
    beforeEach ->
      atom.config.set('auto-copyright.owner', 'Test Owner')
      atom.config.set('auto-copyright.template', 'Copyright (c) %y by %o. All Rights Reserved.')

    it 'does not update comments that have no copyright', ->
      editor.setText """
      #
      # Foo bar baz
      #
      """

      AutoCopyright.update()

      expect(editor.getText()).toEqual """
      #
      # Foo bar baz
      #
      """

    it 'updates copyrights that match the pattern', ->
      year = new Date().getFullYear() - 1

      editor.setText """
      #
      # Copyright (c) #{year} by Test Owner. All Rights Reserved.
      #
      """

      AutoCopyright.update()

      expect(editor.getText()).toEqual """
      #
      # Copyright (c) #{year}-#{year+1} by Test Owner. All Rights Reserved.
      #
      """

  describe 'when retrieving copyright text', ->
    it 'gets the template from the config', ->
      atom.config.set 'auto-copyright',
        template: 'template test'
        owner: 'Test Owner'
        buffer: 0

      expect(AutoCopyright.getCopyrightText()).toEqual "template test\n"

    it 'replaces %y with the current year', ->
      atom.config.set 'auto-copyright',
        template: '%y'
        owner: 'Test Owner'
        buffer: 0

      expect(AutoCopyright.getCopyrightText()).toEqual "3000\n"

    it 'replaces %o with the owner name', ->
      atom.config.set 'auto-copyright',
        template: '%o'
        owner: 'Test Owner'
        buffer: 0

      expect(AutoCopyright.getCopyrightText()).toEqual "Test Owner\n"

    it 'wraps the text in buffer lines if configured', ->
      atom.config.set 'auto-copyright',
        template: '%o'
        owner: 'Test Owner'
        buffer: 1

      expect(AutoCopyright.getCopyrightText()).toEqual("\nTest Owner\n\n")

  describe 'when detecting if the editor already has a copyright', ->
    it 'returns false on an empty file', ->
      expect(AutoCopyright.hasCopyright(editor)).toBeFalsy()

    it 'returns false on a file without a copyright notice', ->
      editor.setText(
        """
        #
        # Just an opening comment without a notice
        #
        """
      )

      expect(AutoCopyright.hasCopyright(editor)).toBeFalsy()

    it 'returns true on a file with a copyright notice', ->
      editor.setText(
        """
        #
        # Copyright (c) 3000 by Foo Corp. All Rights Reserved.
        #
        """
      )

      expect(AutoCopyright.hasCopyright(editor)).toBeTruthy()

    it 'returns false on a file with a copyright notice past the first ten lines', ->
      editor.setText(
        """
        \n\n\n\n\n\n\n\n\n\n
        #
        # Copyright (c) 3000 by Foo Corp. All Rights Reserved.
        #
        """
      )

      expect(AutoCopyright.hasCopyright(editor)).toBeFalsy()
