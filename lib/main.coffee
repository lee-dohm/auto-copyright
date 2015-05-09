#
# Copyright (c) 2015 by Lifted Studios. All Rights Reserved.
#

header = require './auto-copyright'

module.exports =
  # Private: Package configuration metadata.
  config:
    buffer:
      type: 'integer'
      default: 1
      minimum: 0
      maximum: 5
    owner:
      type: 'string'
      default: 'Placeholder Corporation'
    template:
      type: 'string'
      default: 'Copyright (c) %y by %o. All Rights Reserved.'

  # Public: Sets up the package.
  activate: ->
    @disposable = atom.commands.add 'atom-workspace',
      'auto-copyright:insert': => @insert()
      'auto-copyright:update': => @update()

  # Public: Tears down the package.
  deactivate: ->
    @disposable?.dispose()
    @disposable = null

  # Public: Inserts the copyright text at the current position in the buffer.
  insert: ->
    return unless editor = atom.workspace.getActiveTextEditor()

    header.insertCopyright(editor)

  # Public: Updates the copyright year range.
  update: ->
    return unless editor = atom.workspace.getActiveTextEditor()

    header.updateCopyright(editor)
