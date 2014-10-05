#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

AutoCopyrightConfig = require './auto-copyright-config'
ConfigMissingError = require './config-missing-error'
YearRange = require './year-range'

# Public: Handles the interface between the AutoCopyright package and Atom.
class AutoCopyright
  # Public: Performs all required setup when the package is activated.
  activate: ->
    atom.workspaceView.command 'auto-copyright:insert', => @insert()
    # atom.workspaceView.command 'auto-copyright:update', => @update()

  # Public: Inserts the copyright text at the current position in the buffer.
  insert: ->
    editor = atom.workspace.getActiveEditor()
    return unless editor?

    @insertCopyright(editor)

  # Public: Updates the copyright year if a copyright header is found that matches the copyright
  # template.
  update: ->
    undefined

  # Private: Gets the package configuration.
  #
  # Returns the package configuration in an {AutoCopyrightConfig}.
  getConfig: ->
    @config ?= new AutoCopyrightConfig()

  # Private: Gets the raw copyright text to insert.
  #
  # Returns a {String} with the raw copyright text.
  getCopyrightText: ->
    config = @getConfig()
    text = config.getTemplate().replace('%y', @getYear()).replace('%o', config.getOwner())
    @wrap(text, config.getBufferLines())

  # Private: Gets the current year and formats as a year range.
  #
  # Returns a {YearRange} containing the current year.
  getYear: ->
    new YearRange(new Date().getFullYear())

  # Private: Determines if the supplied object already contains a copyright notice.
  #
  # Only checks for a copyright notice in the first ten lines of the file.
  #
  # obj - Buffer to check for a copyright notice, either an {Editor} or {TextBuffer}
  #
  # Returns a {Boolean} indicating whether this buffer has a copyright notice.
  hasCopyright: (obj) ->
    return @hasCopyright(obj.buffer) if obj.buffer?

    @hasCopyrightInText(obj.getTextInRange([[0, 0], [10, 0]]))

  # Private: Determines if the supplied text has a copyright notice.
  #
  # text - A {String} of the text within which to search for a copyright notice.
  #
  # Returns {Boolean} indicating whether this text has a copyright notice.
  hasCopyrightInText: (text) ->
    text.match(/Copyright \(c\)/m)

  # Private: Inserts the copyright text at the current position.
  #
  # Creates an undo transaction so that the multiple steps it takes to insert the text is one atomic
  # undo action.
  #
  # editor - {Editor} in which to insert the copyright.
  insertCopyright: (editor) ->
    if !@hasCopyright(editor)
      editor.transact =>
        editor.insertText(@getCopyrightText(), select: true)
        editor.toggleLineCommentsInSelection()

        range = editor.getSelectedBufferRange()
        editor.setCursorBufferPosition(range.end)
        editor.insertText("\n")

  # Private: Creates a string containing `text` concatenated `count` times.
  #
  # text - {String} of the text to repeat.
  # count - {Number} of times to repeat.
  #
  # Returns a {String} of the repeated text.
  multiplyText: (text, count) ->
    Array(count + 1).join(text)

  # Private: Wraps `text` in some number of newlines before and after it.
  #
  # Returns a {String} containing the wrapped text.
  wrap: (text, bufferCounts) ->
    [before, after] = bufferCounts
    prebuffer = @multiplyText("\n", before)
    postbuffer = @multiplyText("\n", after)
    prebuffer + text + postbuffer

module.exports = new AutoCopyright()
