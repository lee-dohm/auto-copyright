#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

ConfigMissingError = require './config-missing-error.coffee'

# Handles the interface between the AutoCopyright package and Atom.
class AutoCopyright
  DEFAULT_TEMPLATE = "Copyright (c) %y by %o. All Rights Reserved."

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

  # Gets the number of buffer lines to wrap the copyright text with.
  #
  # @private
  # @return [Array] Number of lines before and after the copyright text.
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

  # Gets the raw copyright text to insert.
  #
  # @private
  # @return [String] Raw copyright text.
  getCopyrightText: ->
    text = @getTemplate().replace('%y', @getYear()).replace('%o', @getOwner())
    @wrap(text, @getBuffer())

  # Gets the owner information from the configuration.
  #
  # @private
  # @return [String] Owner text.
  getOwner: ->
    owner = atom.config.get('auto-copyright.owner')
    throw new ConfigMissingError('auto-copyright.owner has not been set') unless owner?
    owner

  # Gets the copyright template from the configuration.
  #
  # If there is no template set in the configuration, then it defaults to:
  #
  # `Copyright (c) %y by %o. All Rights Reserved.\n`
  #
  # @private
  # @return [String] Copyright template text.
  getTemplate: ->
    template = atom.config.get('auto-copyright.template') ? DEFAULT_TEMPLATE
    @trim(template) + "\n"

  # Gets the current year.
  #
  # @private
  # @return [String] Current four-digit year.
  getYear: ->
    new Date().getFullYear()

  # Determines if the supplied `editor` already contains a copyright notice.
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

  # Inserts the copyright text at the top of the given `editor`.
  #
  # Creates an undo transaction so that the multiple steps it takes to
  # insert the text is one atomic undo action.
  #
  # @private
  # @param [Editor] editor Buffer in which to insert the copyright.
  insertCopyright: (editor) ->
    point = @moveToTop(editor)

    editor.transact =>
      @insertText(editor)

    @resetPosition(editor, point)

  # Inserts the copyright text at the current position in the given `editor`.
  #
  # @private
  # @param [Editor] editor Buffer in which to insert the text.
  insertText: (editor) ->
    editor.insertText(@getCopyrightText(), {'select': true})
    editor.toggleLineCommentsInSelection()

    range = editor.getSelectedBufferRange()
    editor.setCursorBufferPosition(range.end)
    editor.insertText("\n")

  # Moves the cursor to the top of the given `editor`.
  #
  # @private
  # @param [Editor] editor Buffer in which to move the cursor.
  # @return [Point] Location from where the cursor was moved.
  moveToTop: (editor) ->
    point = editor.getCursorBufferPosition()
    editor.moveCursorToTop()
    point

  # Returns the cursor to the `point` where it started in the given `editor`.
  #
  # @private
  # @param [Editor] editor Buffer in which to move the cursor.
  # @param [Point] point Location to which to move the cursor.
  resetPosition: (editor, point) ->
    editor.setCursorBufferPosition(point)

  # Trims leading and trailing whitespace from `text`.
  #
  # @return [String] Text with the leading and trailing whitespace removed.
  trim: (text) ->
    text.replace(/^\s+|\s+$/g, '')

  # Wraps `text` in some number of newlines before and after it.
  #
  # @return [String] Contains the wrapped text.
  wrap: (text, bufferCounts) ->
    [before, after] = bufferCounts
    text = "\n" + text for _ in [1..before] if before > 0
    text = text + "\n" for _ in [1..after] if after > 0
    text

module.exports = new AutoCopyright
