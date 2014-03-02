AutoCopyrightView = require './auto-copyright-view'

module.exports =
  autoCopyrightView: null

  activate: (state) ->
    @autoCopyrightView = new AutoCopyrightView(state.autoCopyrightViewState)

  deactivate: ->
    @autoCopyrightView.destroy()

  serialize: ->
    autoCopyrightViewState: @autoCopyrightView.serialize()
