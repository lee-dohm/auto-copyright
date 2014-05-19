#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

# Public: Error that occurs when a configuration item is missing.
module.exports =
class ConfigMissingError extends Error
  # Internal: Name of the error.
  name: 'ConfigMissingError'

  # Public: Creates a new instance of the `ConfigMissingError` class.
  #
  # message - {String} message explaining the cause of the error.
  constructor: (@message) ->
