#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

ConfigMissingError = require './config-missing-error.coffee'

# Public: Module containing all the package methods.
class AutoCopyright
  DEFAULT_TEMPLATE = "Copyright (c) %y by %o. All Rights Reserved."

  # Public: Performs all required setup when the package is activated.
  #
  # Returns `undefined`.
  activate: ->
    atom.workspaceView.command 'auto-copyright:insert', => @insert()
    atom.workspaceView.command 'auto-copyright:update', => @update()

  # Public: Inserts the copyright text at the top of the current buffer.
  #
  # Returns `undefined`.
  insert: ->
    editor = atom.workspace.getActiveEditor()
    return unless editor?

    @insertCopyright(editor) unless @hasCopyright(editor)

  # Public: Updates the copyright year if a copyright header is found
  # that matches the copyright template.
  #
  # Returns `undefined`.
  update: ->
    undefined

  # Internal: Gets the number of buffer lines to wrap the copyright
  # text with.
  #
  # Returns an {Array} containing the number of lines before and after
  # the copyrigt text.
  getBuffer: ->
    buffer = atom.config.get('auto-copyright.buffer')
    switch
      when buffer instanceof Array
        switch buffer.length
          when 0 then [0, 0]
          when 1
            [buf] = buffer
            [buf, buf]
          else buffer
      when buffer? then [Number(buffer), Number(buffer)]
      else [0, 0]

  # Internal: Gets the raw copyright text to insert.
  #
  # Returns a {String} containing the raw copyright text.
  getCopyrightText: ->
    text = @getTemplate().replace('%y', @getYear()).replace('%o', @getOwner())
    @wrap(text, @getBuffer())

  # Internal: Gets the owner information from the configuration.
  #
  # Returns a {String} containing the owner text.
  getOwner: ->
    owner = atom.config.get('auto-copyright.owner')
    throw new ConfigMissingError('auto-copyright.owner has not been set') unless owner?
    owner

  # Internal: Gets the copyright template from the configuration.
  #
  # If there is no template set in the configuration, then it defaults to:
  #
  # `Copyright (c) %y by %o. All Rights Reserved.\n`
  #
  # Returns a {String} containing the copyright template.
  getTemplate: ->
    template = atom.config.get('auto-copyright.template') ? DEFAULT_TEMPLATE
    @trim(template) + "\n"

  # Internal: Gets the current year.
  #
  # Returns a {String} containing the current year.
  getYear: ->
    new Date().getFullYear()

  # Internal: Determines if the supplied `editor` already contains a copyright notice.
  #
  # editor - {Editor} to check for a copyright notice.
  #
  # Returns a {Boolean} indicating whether a copyright notice exists.
  hasCopyright: (editor) ->
    false

  # Internal: Inserts the copyright text at the top of the given `editor`.
  #
  # Creates an undo transaction so that the multiple steps it takes to
  # insert the text is one atomic undo action.
  #
  # editor - {Editor} in which to insert the copyright.
  #
  # Returns `undefined`.
  insertCopyright: (editor) ->
    point = @moveToTop(editor)

    editor.transact ->
      @insertText(editor)

    @resetPosition(editor, point)

  # Internal: Inserts the copyright text at the current position in the given `editor`.
  #
  # editor - {Editor} in which to insert the text.
  #
  # Returns `undefined`.
  insertText: (editor) ->
    editor.insertText(@getCopyrightText(), {'select': true})
    editor.toggleLineCommentsInSelection()

    range = editor.getSelectedBufferRange()
    editor.setCursorBufferPosition(range.end)
    editor.insertText("\n")

  # Internal: Moves the cursor to the top of the given `editor`.
  #
  # editor - {Editor} in which to move the cursor.
  #
  # Returns the {Point} where the cursor was before it was moved.
  moveToTop: (editor) ->
    point = editor.getCursorBufferPosition()
    editor.moveCursorToTop()
    point

  # Internal: Returns the cursor to the `point` where it started in the given `editor`.
  #
  # editor - {Editor} in which to move the cursor.
  # point - {Point} to move the cursor to in the editor.
  #
  # Returns `undefined`.
  resetPosition: (editor, point) ->
    editor.setCursorBufferPosition(point)

  # Internal: Trims leading and trailing whitespace from `text`.
  #
  # Returns a {String} with the leading and trailing whitespace removed.
  trim: (text) ->
    text.replace(/^\s+|\s+$/g, '')

  # Internal: Wraps `text` in some number of newlines before and after it.
  #
  # Returns a {String} containing the wrapped text.
  wrap: (text, bufferCounts) ->
    [before, after] = bufferCounts
    text = "\n" + text for _ in [1..before] if before > 0
    text = text + "\n" for _ in [1..after] if after > 0
    text

module.exports = new AutoCopyright
