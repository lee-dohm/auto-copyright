#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

YearRange = require './year-range'

# Public: Handles the interface between the AutoCopyright package and Atom.
class AutoCopyright
  config:
    buffer:
      type: 'integer'
      default: 1
      minimum: 0
      maximum: 5
    owner:
      type: 'string'
    template:
      type: 'string'
      default: 'Copyright (c) %y by %o. All Rights Reserved.'

  # Public: Performs all required setup when the package is activated.
  activate: ->
    atom.workspaceView.command 'auto-copyright:insert', => @insert()

  # Public: Inserts the copyright text at the current position in the buffer.
  insert: ->
    editor = atom.workspace.getActiveEditor()
    return unless editor?

    @insertCopyright(editor)

  # Private: Gets the raw copyright text to insert.
  #
  # Returns a {String} with the raw copyright text.
  getCopyrightText: ->
    text = (atom.config.get('auto-copyright.template') + "\n")
                       .replace('%y', @getYear())
                       .replace('%o', atom.config.get('auto-copyright.owner'))

    @wrap(text, atom.config.get('auto-copyright.buffer'))

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
  wrap: (text, buffer) ->
    prebuffer = @multiplyText("\n", buffer)
    postbuffer = @multiplyText("\n", buffer)
    prebuffer + text + postbuffer

module.exports = new AutoCopyright()
