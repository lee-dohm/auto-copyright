#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

YearRange = require '../lib/year-range'

describe 'YearRange', ->
  beforeEach ->
    spyOn(Date.prototype, 'getFullYear').andReturn 3000

  describe 'when constructing a year range', ->
    it 'rejects strings that contain anything other than digits, commas and hyphens', ->
      expect( -> new YearRange('/')).toThrow()

    it 'accepts strings that contain a single four-digit year', ->
      expect(new YearRange('3000').values).toEqual([3000])

    it 'accepts strings that contain two four-digit years separated by a comma', ->
      expect(new YearRange('3000,4000').values).toEqual([3000, 4000])

    it 'accepts strings that contain two four-digit years separated by a comma and a space', ->
      expect(new YearRange('3000, 4000').values).toEqual([3000, 4000])

    it 'accepts strings that contain a year range', ->
      expect(new YearRange('3000-4000').values).toEqual([3000..4000])

    it 'accepts strings that contain a mix of comma-separated years and year ranges', ->
      range = new YearRange('2004, 2011-2014, 2016-2017, 2020')
      expect(range.values).toEqual([2004, 2011, 2012, 2013, 2014, 2016, 2017, 2020])

  describe 'when converting back to text', ->
    it 'throws an error when values is null or undefined', ->
      range = new YearRange('3000')
      range.values = null
      expect( -> range.toString()).toThrow()
      range.values = undefined
      expect( -> range.toString()).toThrow()

    it 'converts a single number', ->
      range = new YearRange('3000')
      expect(range.toString()).toEqual('3000')

    it 'converts two disjoint numbers', ->
      range = new YearRange('3000, 4000')
      expect(range.toString()).toEqual('3000, 4000')

    it 'converts a year range', ->
      range = new YearRange('2010-2015')
      expect(range.toString()).toEqual('2010-2015')

    it 'converts a mix of comma-separated years and year ranges', ->
      range = new YearRange('2004, 2011-2014, 2016-2017, 2020')
      expect(range.toString()).toEqual('2004, 2011-2014, 2016-2017, 2020')

  describe '::addYear', ->
    it 'adds the current year to the array if none is specified', ->
      range = new YearRange('1999')
      range.addYear()

      expect(range.toString()).toEqual '1999, 3000'
