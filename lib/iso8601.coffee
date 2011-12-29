# iso8601.js
#
# Partial ECMAScript 5.1 Date object polyfill to support the ISO 8601 format
# specified in section 15.9.1.15 in Date.parse (section 15.9.4.2) and
# Date.prototype.toISOString (section 15.9.5.43). ISO 8601 formats from RFC 3339
# and the W3C Date and Time Formats NOTE (http://www.w3.org/TR/NOTE-datetime)
# are also supported.
#
# Adds string parsing and formatting functions directly to the native Date
# object and prototype. Uses native functionality where available.
#
# Examples
#
#   Date.parse("2010-07-20T15:00:00Z")
#   // => 1307834445456
#
#   date = Date.parseISO8601("2010-07-20T15:00:00Z")
#   // => Tue Jul 20 2010 08:00:00 GMT-0700 (PDT)
#
#   date.toISOString()
#   // => "2010-07-20T15:00:00.000Z"
#
#   date.toISO8601String(true)
#   // => "2010-07-20T08:00:00.000-07:00"
#
# Note: Avoid using "new Date(...)" to parse ISO 8601 strings since this library
# does not polyfill the Date constructor.
#
#
# Originally based on Paul Gallagher's rfc3339date.js library
#   https://github.com/tardate/rfc3339date.js
# Copyright (c) 2010 Paul GALLAGHER  http://tardate.com
#
# Additional modifications by the Do team
# Copyright (c) 2011 Do  http://do.com
#
# Licensed under the MIT license
#   http://www.opensource.org/licenses/mit-license.php
#



# Helper function to left-pad numbers to the specified length
pad = (number, length = 2) ->
  result = number.toString()
  while result.length < length
    result = '0' + result
  result

# Unit test to check native ISO 8601 parsing support
supportsISOParsing = Date.parse?('2011-06-11T23:20:45.456-0700') is 1307859645456



# Date.prototype.toISO8601String
#
# Format the date in ISO 8601 / RFC 3339 with custom rules. With no parameters,
# output is equivalent to the ECMAScript 5.1 defined Date.prototype.toISOString.
#
# localTimezone - Use local timezone or UTC offset? (default: false, i.e. UTC)
# separators    - Include date/time separators? (default: true)
# milliseconds  - Include milliseconds? (default: true)
#
# Examples
#
#   new Date().toISO8601String(true)
#   // => "2010-07-25T19:51:31.427+08:00"
#
#   new Date().toISO8601String(true)
#   // => "2010-07-25T19:51:31.427+08:00"
#
#   new Date().toISO8601String(true)
#   // => "2010-07-25T19:51:31.427+08:00"
#
Date::toISO8601String = (localTimezone = false, separators = true, milliseconds = true) ->
  # Raise RangeError for invalid dates
  timet = @getTime()
  if timet != timet  # isNaN
    throw new RangeError 'Invalid date'

  dateSeparator = if separators then '-' else ''
  timeSeparator = if separators then ':' else ''

  result =
    if localTimezone
      @getFullYear().toString() + dateSeparator +
      pad(@getMonth() + 1)      + dateSeparator +
      pad(@getDate())           + 'T'           +
      pad(@getHours())          + timeSeparator +
      pad(@getMinutes())        + timeSeparator +
      pad(@getSeconds())
    else
      @getUTCFullYear().toString() + dateSeparator +
      pad(@getUTCMonth() + 1)      + dateSeparator +
      pad(@getUTCDate())           + 'T' +
      pad(@getUTCHours())          + timeSeparator +
      pad(@getUTCMinutes())        + timeSeparator +
      pad(@getUTCSeconds())

  if milliseconds
    result += '.' +
      pad (if localTimezone then @getMilliseconds() else @getUTCMilliseconds()), 3

  if localTimezone
    tzOffset = @getTimezoneOffset()
    if tzOffset >= 0
      result += '-'
    else
      result += '+'
      tzOffset *= -1
    result + pad(tzOffset / 60) + timeSeparator + pad(tzOffset % 60)
  else
    result + 'Z'



# Date.prototype.toISOString
#
# Format the date in UTC ISO 8601 / RFC 3339.
#
# Defined in ECMAScript 5.1 15.9.5.43. An implementation is set only if the
# browser lacks native support.
#
# Examples
#
#   new Date().toISOString()
#   // => "2010-07-25T11:51:31.427Z"
#
unless Date::toISOString
  Date::toISOString = Date::toISO8601String



# Date.prototype.toJSON
#
# Format the date in ISO 8601 UTC suitable for use by JSON.stringify. Returns
# null for invalid dates. See ECMAScript 5.1 15.9.5.44.
#
# Examples
#
#   new Date().toJSON()
#   // => "2010-07-25T11:51:31.427Z"
#
unless Date::toJSON
  Date::toJSON = (key) ->
    if isFinite(@valueOf())
      @toISOString()
    else
      null  # Spec requires returning null for non-finite values



# Date.parseISO8601
#
# Parses ISO8601 / RFC 3339 date strings to a Date object. Uses native browser
# parsing if available.
#
# input     - The String to parse.
# useNative - Use browser native parsing if available? (default: true)
#
# Examples
#
#   Date.parseISO8601("2010-07-20T15:00:00Z")
#   // => ....
#
ISO8601_PATTERN = ///
  (\d\d\d\d)       # year
  (-)?
  (\d\d)           # month
  (-)?
  (\d\d)           # day
  (T)?
  (\d\d)           # hour
  (:)?
  (\d\d)?          # minute
  (:)?
  (\d\d)?          # seconds
  ([\.,]\d+)?      # milliseconds
  (
    $|             # end of input = no timezone information
    Z|             # UTC
      ([+-])       # offset direction
      (\d\d)       # offset hours
      (:)?
      (\d\d)?      # offset minutes
  )
///i

DECIMAL_SEPARATOR = String(1.5).charAt(1)

parseISO8601 = (input) ->
  type = Object::toString.call(input)

  # Return the input if it's already a Date instance
  return input if type == '[object Date]'

  # Can only parse Strings
  return undefined unless type == '[object String]'

  if matches = input.match(ISO8601_PATTERN)
    year    = parseInt(matches[1], 10)
    month   = parseInt(matches[3], 10) - 1
    day     = parseInt(matches[5], 10)
    hour    = parseInt(matches[7], 10)
    minutes = if matches[9]  then parseInt(matches[9], 10)  else 0
    seconds = if matches[11] then parseInt(matches[11], 10) else 0
    milliseconds =
      if matches[12]
        parseFloat(DECIMAL_SEPARATOR + matches[12][1..]) * 1000
      else
        0

    result = Date.UTC(year, month, day, hour, minutes, seconds, milliseconds)
    if matches[13] && matches[14]  # Timezone adjustment
      offset = matches[15] * 60
      offset += parseInt(matches[17], 10) if (matches[17])
      offset *= if matches[14] is '-' then -1 else 1
      result -= offset * 60 * 1000
    new Date(result)

if supportsISOParsing
  Date.parseISO8601 = (input, useNative = true) ->
    if useNative     # Use the default Date constructor, we have native support.
      new Date(input)
    else             # Force the polyfill.
      parseISO8601 input
else                 # No native support, always use polyfill.
  Date.parseISO8601 = parseISO8601



# Date.parse
#
# Parses date strings; returns time in milliseconds since the Unix epoch. See
# http://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Date/parse
#
# This polyfills the standard Date.parse to support ISO 8601 / RFC 3339 date
# strings only if the browser doesen't have native support.
#
# Examples
#
#   Date.parse("2010-07-20T15:00:00Z")
#   // => 1279638000000
#
if Object::toString.call(Date.parse) != '[object Function]'
  # No built-in Date.parse, use our version.
  Date.parse = (input) -> parseISO8601(input)?.getTime()
else if not supportsISOParsing
  # No native ISO 8601 parsing, chain our version
  oldDateParse = Date.parse
  Date.parse = (input) ->
    result = parseISO8601(input)?.getTime()
    result = oldDateParse(input) if not result and oldDateParse
    result



# Date.now
#
# Returns the Number value (milliseconds since the Unix epoch) of the current
# time. See ECMAScript 5.1 15.9.4.4.
#
# Examples
#
#   Date.now()
#   // => 1325174662624
#
unless Date.now
  Date.now = -> new Date().getTime()
