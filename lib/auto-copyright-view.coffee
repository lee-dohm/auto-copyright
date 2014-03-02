{View} = require 'atom'

module.exports =
class AutoCopyrightView extends View
  @content: ->
    @div class: 'auto-copyright overlay from-top', =>
      @div "The AutoCopyright package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "auto-copyright:toggle", => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    console.log "AutoCopyrightView was toggled!"
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
