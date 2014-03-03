#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

module.exports =
class ConfigMissingError extends Error
  name: 'ConfigMissingError'

  constructor: (@message) ->
