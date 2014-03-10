#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

AutoCopyrightConfig = require './auto-copyright-config.coffee'
ConfigMissingError = require './config-missing-error.coffee'

# Handles the interface between the AutoCopyright package and Atom.
class AutoCopyright
  # Performs all required setup when the package is activated.
  activate: ->
    atom.workspaceView.command 'auto-copyright:insert', => @insert()
    atom.workspaceView.command 'auto-copyright:update', => @update()

  # Inserts the copyright text at the top of the current buffer.
  insert: ->
    editor = atom.workspace.getActiveEditor()
    return unless editor?

    @insertCopyright(editor) unless @hasCopyright(editor)

  # Updates the copyright year if a copyright header is found that
  # matches the copyright template.
  update: ->
    undefined

  # Gets the package configuration.
  #
  # @private
  # @return [AutoCopyrightConfig] Package configuration.
  getConfig: ->
    @config = new AutoCopyrightConfig unless @config?
    @config

  # Gets the raw copyright text to insert.
  #
  # @private
  # @return [String] Raw copyright text.
  getCopyrightText: ->
    config = @getConfig()
    text = config.getTemplate().replace('%y', @getYear()).replace('%o', config.getOwner())
    @wrap(text, config.getBufferLines())

  # Gets the current year.
  #
  # @private
  # @return [String] Current four-digit year.
  getYear: ->
    new Date().getFullYear()

  # Determines if the supplied object already contains a copyright notice.
  #
  # Only checks for a copyright notice in the first ten lines of the file.
  #
  # @private
  # @param [Editor, TextBuffer] obj Buffer to check for a copyright notice.
  # @return [Boolean] Flag indicating whether this buffer has a copyright notice.
  hasCopyright: (obj) ->
    return @hasCopyright(obj.buffer) if obj.buffer?

    @hasCopyrightInText(obj.getTextInRange([[0, 0], [10, 0]]))

  # Determines if the supplied text has a copyright notice.
  #
  # @private
  # @param [String] text Text within which to search for a copyright notice.
  # @return [Boolean] Flag indicating whether this text has a copyright notice.
  hasCopyrightInText: (text) ->
    text.match(/Copyright \(c\)/m)

  # Inserts the copyright text at the current position.
  #
  # Creates an undo transaction so that the multiple steps it takes to
  # insert the text is one atomic undo action.
  #
  # @private
  # @param [Editor] editor Buffer in which to insert the copyright.
  insertCopyright: (editor) ->
    editor.transact =>
      editor.insertText(@getCopyrightText(), {'select': true})
      editor.toggleLineCommentsInSelection()

      range = editor.getSelectedBufferRange()
      editor.setCursorBufferPosition(range.end)
      editor.insertText("\n")

  # Wraps `text` in some number of newlines before and after it.
  #
  # @return [String] Contains the wrapped text.
  wrap: (text, bufferCounts) ->
    [before, after] = bufferCounts
    text = "\n" + text for _ in [1..before] if before > 0
    text = text + "\n" for _ in [1..after] if after > 0
    text

module.exports = new AutoCopyright
