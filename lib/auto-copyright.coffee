#
# Copyright (c) 2014-2015 by Lifted Studios. All Rights Reserved.
#

Template = require './template'
YearRange = require './year-range'

# Public: Utilities for placing and updating copyright notices.
class AutoCopyright
  # Private: Gets the raw copyright text to insert.
  #
  # Returns a {String} with the raw copyright text.
  getCopyrightText: ->
    template = new Template(atom.config.get('auto-copyright.template') + "\n")
    @wrap(template.toString(), atom.config.get('auto-copyright.buffer'))

  # Private: Gets the current year and formats as a year range.
  #
  # Returns a {YearRange} containing the current year.
  getYear: ->
    new YearRange(new Date().getFullYear())

  # Private: Determines if the supplied object already contains a copyright notice.
  #
  # Only checks for a copyright notice in the first ten lines of the file.
  #
  # * `obj` Buffer to check for a copyright notice, either a {TextEditor} or {TextBuffer}.
  #
  # Returns a {Boolean} indicating whether this buffer has a copyright notice.
  hasCopyright: (obj) ->
    return @hasCopyright(obj.buffer) if obj.buffer?

    @hasCopyrightInText(obj.getTextInRange([[0, 0], [10, 0]]))

  # Private: Determines if the supplied text has a copyright notice.
  #
  # * `text` {String} of the text within which to search for a copyright notice.
  #
  # Returns {Boolean} indicating whether this text has a copyright notice.
  hasCopyrightInText: (text) ->
    text.match(/Copyright \(c\)/m)

  # Private: Inserts the copyright text at the current position.
  #
  # * `editor` {TextEditor} in which to insert the copyright.
  insertCopyright: (editor = atom.workspace.getActiveTextEditor()) ->
    unless @hasCopyright(editor)
      @restoreCursor editor, =>
        editor.transact =>
          editor.setCursorBufferPosition([0, 0], autoscroll: false)

          editor.insertText(@getCopyrightText(), select: true)
          editor.toggleLineCommentsInSelection()

          range = editor.getSelectedBufferRange()
          editor.setCursorBufferPosition(range.end)
          editor.insertText("\n")

  # Private: Creates a string containing `text` concatenated `count` times.
  #
  # * `text` {String} of the text to repeat.
  # * `count` {Number} of times to repeat.
  #
  # Returns a {String} of the repeated text.
  multiplyText: (text, count) ->
    Array(count + 1).join(text)

  # Private: After `callback` is called, puts the cursor back where it was before.
  #
  # * `editor` {TextEditor} where the cursor is.
  # * `callback` A {Function} that manipulates the cursor position.
  restoreCursor: (editor, callback) ->
    marker = editor.markBufferPosition(editor.getCursorBufferPosition(), persistent: false)

    callback()

    editor.setCursorBufferPosition(marker.getHeadBufferPosition())
    marker.destroy()

  # Private: Updates copyright in the first ten lines.
  #
  # * `editor` {TextEditor} where the copyright should be updated.
  updateCopyright: (editor = atom.workspace.getActiveTextEditor()) ->
    if @hasCopyright(editor)
      editor.scanInBufferRange YearRange.pattern, [[0, 0], [10, 0]], ({matchText, replace}) ->
        yearRange = new YearRange(matchText)
        yearRange.addYear(new Date().getFullYear())
        replace(yearRange.toString())

  # Private: Wraps `text` in some number of newlines before and after it.
  #
  # * `text` {String} containing the text to be wrapped.
  # * `buffer` {Number} of lines to place before and after `text`.
  #
  # Returns a {String} containing the wrapped text.
  wrap: (text, buffer) ->
    prebuffer = @multiplyText("\n", buffer)
    postbuffer = @multiplyText("\n", buffer)
    prebuffer + text + postbuffer

module.exports = new AutoCopyright()
