#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

ConfigMissingError = require './config-missing-error'

# Represents the package configuration information.
class AutoCopyrightConfig
  # Gets the number of buffer lines to place before and after the
  # copyright notice.
  #
  # @return [Array] Array containing the count of lines before and
  #                 after the copyright notice line, respectively.
  getBufferLines: ->
    buffer = atom.config.get('auto-copyright.buffer')
    switch
      when buffer instanceof Array
        switch buffer.length
          when 0 then [0, 0]
          when 1
            [buf] = buffer
            [buf, buf]
          else buffer
      when buffer? then [Number(buffer), Number(buffer)]
      else [0, 0]

  # Gets the owner text.
  #
  # @return [String] Owner text to place in the copyright notice.
  getOwner: ->
    owner = atom.config.get('auto-copyright.owner')
    throw new ConfigMissingError('No owner text set') unless owner?
    owner

  # Gets the copyright notice template to use.
  #
  # If there is no template set in the configuration, then it defaults to:
  #
  # `Copyright (c) %y by %o. All Rights Reserved.\n`
  #
  # @return [String] Copyright notice template text.
  getTemplate: ->
    template =
      atom.config.get('auto-copyright.template') or 'Copyright (c) %y by %o. All Rights Reserved.'

    template + "\n"

module.exports = AutoCopyrightConfig
