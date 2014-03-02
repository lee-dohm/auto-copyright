module.exports =
class ConfigMissingError extends Error
  name: 'ConfigMissingError'

  constructor: (@message) ->
