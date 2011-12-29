# Tests for the iso8601.js library
#
# For proper testing of timezone offsets, the suite must be run in the PST (non
# daylight savings) timezone environment, e.g. TZ='PST+8'.
#
# Functions are tested directly where possible. Some of these tests won't test
# the polyfill functions unless run in a non-ECMAScript 5.1 environment -
# they'll just test native versions. Be sure to run the suite in older engines.
#

chai = @chai || require('chai')
assert = chai.assert
expect = chai.expect
require('../lib/iso8601') if require?

describe 'Date', ->

  # Date fixtures
  date = new Date(1308392445678)         # Sat Jun 18, 2011 02:20:45.678 PST
  invalidDate = new Date('not a date')   # Doesn't throw exception on creation


  describe 'toISO8601String', ->

    it 'defaults to UTC with date/time separators and milliseconds', ->
      assert.equal '2011-06-18T10:20:45.678Z', date.toISO8601String()

    it 'produces same output as toISOString', ->
      assert.equal date.toISO8601String(), date.toISOString()

    it 'can format without date/time separators', ->
      assert.equal '20110618T102045.678Z', date.toISO8601String(false, false, true)

    it 'can format without milliseconds', ->
      assert.equal '2011-06-18T10:20:45Z', date.toISO8601String(false, true, false)

    it 'can format without date/time separators and milliseconds', ->
      assert.equal '20110618T102045Z', date.toISO8601String(false, false, false)

    it 'can format in local timezone and include offset', ->
      assert.equal '2011-06-18T02:20:45.678-08:00', date.toISO8601String(true, true, true)

    it 'throws RangeError for Invalid Dates', ->
      fn = -> invalidDate.toISO8601String()    # Should throw exception when called
      expect(fn).to.throw RangeError


  describe 'toJSON', ->

    it 'returns the UTC ISO 8601 string for valid dates', ->
      assert.equal '2011-06-18T10:20:45.678Z', date.toJSON()

    it 'returns null for invalid dates', ->
      assert.equal null, invalidDate.toJSON()


  describe 'parseISO8601', ->

    # Using Date.parseISO8601(..., false) to parse without browser fallback.

    it 'parses UTC ISO 8601 strings', ->
      assert.equal date.getTime(), Date.parseISO8601('2011-06-18T10:20:45.678Z', false).getTime()

    it 'parses ISO 8601 strings with timezone offsets', ->
      assert.equal date.getTime(), Date.parseISO8601('2011-06-18T02:20:45.678-08:00', false).getTime()

    it 'returns the input if given a Date instance', ->
      assert.equal date, Date.parseISO8601(date, false)

    it 'returns undefined for non-String input', ->
      assert.isUndefined Date.parseISO8601(2, false)
      assert.isUndefined Date.parseISO8601((-> 1), false)

    it 'returns undefined for invalid string inputs', ->
      assert.isUndefined Date.parseISO8601('this is not a date', false)


  describe 'parse', ->

    it 'parses UTC ISO 8601 strings to epoch milliseconds', ->
      assert.equal 1307834445456, Date.parse('2011-06-11T23:20:45.456Z')

    it 'parses ISO 8601 strings with timezone offsets to epoch milliseconds', ->
      assert.equal 1307859645456, Date.parse('2011-06-11T23:20:45.456-0700')

    it 'falls back to native Date.parse for non ISO strings', ->
      assert.equal 807926400000, Date.parse('Wed, 09 Aug 1995 00:00:00 GMT')


  describe 'now', ->
    it 'returns the current time in milliseconds since epoch', ->
      assert.equal new Date().getTime(), Date.now()
