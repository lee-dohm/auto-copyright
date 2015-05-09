path = require 'path'
_ = require 'underscore-plus'

defaultReplacements =
  owner: -> atom.config.get('auto-copyright.owner')
  year: -> new Date().getFullYear()

# Public: A template that replaces text in a rule-based fashion.
class Template
  # Public: Constructs a new template from the supplied text.
  #
  # * `template` {String} template containing text to be formatted.
  constructor: (@template) ->
    @template = @template.replace('%y', '{{year}}')
    @template = @template.replace('%o', '{{owner}}')

    @getReplacements()

  # Private: Gets the list of replacement rules.
  #
  # Returns an {Object} containing the names to replace and the {Function} to use to generate the
  #   replacement text.
  getReplacements: ->
    @replacements = defaultReplacements
    userReplacements = @getUserReplacements()
    _.extend(@replacements, userReplacements)

  # Private: Gets the list of user-defined replacement rules, if any.
  #
  # Returns an {Object} containing the names to replace and the {Function} to use to generate the
  #   replacement text.
  getUserReplacements: ->
    userPath = path.join(atom.getConfigDirPath(), 'user-replacements')
    if fs.existsSync("#{userPath}.coffee")
      require userPath
    else
      {}

  # Public: Formats the template by performing any replacements.
  #
  # Returns a {String} containing the formatted text.
  toString: ->
    text = @template
    text = text.replace("{{#{name}}}", func()) for name, func of @replacements
    text

module.exports = Template
