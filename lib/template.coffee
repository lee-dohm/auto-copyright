_ = require 'underscore-plus'

defaultReplacements =
  owner: -> atom.config.get('auto-copyright.owner')
  year: -> new Date().getFullYear()

class Template
  constructor: (@template) ->
    @template = @template.replace('%y', '{{year}}')
    @template = @template.replace('%o', '{{owner}}')
    @getReplacements()

  getReplacements: ->
    @replacements = defaultReplacements
    userReplacements = require path.join(atom.getConfigDirPath(), 'user-replacements')
    _.extend(@replacements, userReplacements)

  toString: ->
    text = @template
    text = text.replace("{{#{name}}}", func()) for name, func of @replacements
    text

module.exports = Template
