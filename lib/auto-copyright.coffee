ConfigMissingError = require './config-missing-error.coffee'

# Public: Module containing all the package methods.
class AutoCopyright
  # Public: Performs all required setup when the package is activated.
  #
  # Returns `undefined`.
  activate: ->
    atom.workspaceView.command 'auto-copyright:insert', => @insert()
    atom.workspaceView.command 'auto-copyright:update', => @update()

  # Internal: Gets the raw copyright text to insert.
  #
  # Returns a {String} containing the raw copyright text.
  getCopyrightText: ->
    @getTemplate().replace('%y', @getYear()).replace('%o', @getOwner())

  # Internal: Gets the owner information from the configuration.
  #
  # Returns a {String} containing the owner text.
  getOwner: ->
    owner = atom.config.get('auto-copyright.owner')
    throw new ConfigMissingError('auto-copyright.owner has not been set') unless owner?
    owner

  # Internal: Gets the copyright template from the configuration.
  #
  # Returns a {String} containing the copyright template.
  getTemplate: ->
    template = atom.config.get('auto-copyright.template')
    throw new ConfigMissingError('auto-copyright.template has not been set') unless template?
    template

  # Internal: Gets the current year.
  #
  # Returns a {String} containing the current year.
  getYear: ->
    new Date().getFullYear()

  # Public: Inserts the copyright text at the top of the current buffer.
  #
  # Returns `undefined`.
  insert: ->
    editor = atom.workspace.activePaneItem
    pos = editor.getCursorBufferPosition()
    editor.moveCursorToTop()
    editor.insertText(@getCopyrightText())
    editor.setCursorBufferPosition(pos)

  # Public: Updates the copyright year if a copyright header is found
  # that matches the copyright template.
  #
  # Returns `undefined`.
  update: ->
    undefined

module.exports = new AutoCopyright
