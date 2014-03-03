#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

ConfigMissingError = require './config-missing-error.coffee'

# Public: Module containing all the package methods.
class AutoCopyright
  # Public: Performs all required setup when the package is activated.
  #
  # Returns `undefined`.
  activate: ->
    atom.workspaceView.command 'auto-copyright:insert', => @insert()
    atom.workspaceView.command 'auto-copyright:update', => @update()

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
      when buffer instanceof Number then [buffer, buffer]
      when buffer instanceof String then [Number(buffer), Number(buffer)]
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
    template = atom.config.get('auto-copyright.template') ?
      "Copyright (c) %y by %o. All Rights Reserved."
    @trim(template) + "\n"

  # Internal: Gets the current year.
  #
  # Returns a {String} containing the current year.
  getYear: ->
    new Date().getFullYear()

  # Public: Inserts the copyright text at the top of the current buffer.
  #
  # Returns `undefined`.
  insert: ->
    editor = atom.workspace.getActiveEditor()
    return unless editor?

    pos = editor.getCursorBufferPosition()

    editor.moveCursorToTop()

    editor.insertText(@getCopyrightText(), {'select': true})
    editor.toggleLineCommentsInSelection()

    editor.setCursorBufferPosition(pos)

  # Internal: Trims leading and trailing whitespace from `text`.
  #
  # Returns a {String} with the leading and trailing whitespace removed.
  trim: (text) ->
    text.replace(/^\s+|\s+$/g, '')

  # Public: Updates the copyright year if a copyright header is found
  # that matches the copyright template.
  #
  # Returns `undefined`.
  update: ->
    undefined

  wrap: (text, bufferCounts) ->
    [before, after] = bufferCounts
    text = "\n" + text for _ in [1..before] if before > 0
    text = text + "\n" for _ in [1..after] if after > 0
    text

module.exports = new AutoCopyright
