#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

# Error that occurs when a configuration item is missing.
module.exports =
class ConfigMissingError extends Error
  name: 'ConfigMissingError'

  # Creates a new instance of the `ConfigMissingError` class.
  #
  # @param [String] message Message explaining the cause of the error.
  constructor: (@message) ->
