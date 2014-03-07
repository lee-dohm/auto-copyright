#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

# Error that occurs when a configuration item is missing.
class ConfigMissingError extends Error
  name: 'ConfigMissingError'

  constructor: (@message) ->

module.exports = ConfigMissingError
