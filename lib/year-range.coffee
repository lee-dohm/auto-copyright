#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

# Public: Represents an arbitrary collection of copyright years.
module.exports =
class YearRange
  # Internal: Array of years the copyright applies to.
  values: null

  # Public: Initializes a new instance of the {YearRange} class.
  #
  # * `text` {String} of the year range to convert.
  constructor: (text) ->
    @convert(text.toString())

  # Public: Returns the year range.
  #
  # Returns the year range as a {String}.
  toString: ->
    throw Error('@values is undefined') unless @values?

    inRange = false
    text = @values[0].toString()

    appendYear = (i) =>
      if @values[i] == @values[i-1] + 1
        inRange = true
        return

      if inRange
        text += "-#{@values[i-1]}"
        inRange = false

        text += ", #{@values[i]}" if @values[i]?
      else
        return unless @values[i]?
        text += ", #{@values[i]}"

    appendYear(i) for i in [1..@values.length]

    text

  # Internal: Converts the text representation into a numeric array representation.
  #
  # * `text` {String} of the year range to convert.
  convert: (text) ->
    unless text.match /\d{4}(-\d{4})?((,\s*\d{4})|(\d{4}-\d{4}))*/
      throw new Error('Not a valid year range')

    temp = []
    items = text.split(/,\s*/)
    temp = temp.concat(@convertItem(item)) for item in items
    @values = temp

  # Internal: Converts the text representation of a single element of a year range into a numeric
  # array representation.
  #
  # * `text` {String} containing a component of a year range.
  #
  # Returns either an {Array} of numbers representing a year range or a single year {Number}.
  convertItem: (text) ->
    if text.match /\d{4}-\d{4}/
      [start, end] = text.split('-')
      [Number(start)..Number(end)]
    else
      Number(text)
