# iso8601.coffee
#
# Partial-polyfill to the Javascript Date object to support the subset of
# ISO8601 described as part of RFC 3339 and at:
#   http://www.w3.org/TR/NOTE-datetime
# Adds string parsing and generation directly to Date. Uses native parsing when
# available.
#
# Usage:
#   Date.parse("2010-07-20T15:00:00Z")
#     => 1307834445456     # milliseconds since Unix epoch
#   date = Date.parseISO8601("2010-07-20T15:00:00Z")
#     => Tue Jul 20 2010 08:00:00 GMT-0700 (PDT)     # Date instance
#   date.toISO8601UTCString()
#     => "2010-07-20T15:00:00Z"
#   date.toISO8601LocaleString()
#     => "2010-07-20T08:00:00-07:00"     #  When run from a browser in PDT
#
# Note: Avoid using "new Date(...)" to parse ISO8601 strings since this library
# does not polyfill the Date constructor.
#
#
# Based on Paul Gallagher's rfc3339date.js library
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

# Unit test to check if browser has native ISO8601 support
supportsISO8601 = Date.parse?('2011-06-11T23:20:45.456Z') is 1307834445456



# Date.prototype.toISO8601UTCString
#
# Date instance method to format the date as ISO8601 / RFC 3339 string (in UTC
# format).
#
# Usage: d = new Date().toISO8601UTCString()
#          => "2010-07-25T11:51:31.427Z"
# Parameters:
#   separators   : include date/time separators? (default is true)
#   milliseconds : include milliseconds? (default is true)
Date::toISO8601UTCString = (separators = true, milliseconds = true) ->
  dateSeparator = if separators then '-' else ''
  timeSeparator = if separators then ':' else ''

  result =
    this.getUTCFullYear().toString() + dateSeparator +
    pad(this.getUTCMonth() + 1)      + dateSeparator +
    pad(this.getUTCDate())           + 'T'           +
    pad(this.getUTCHours())          + timeSeparator +
    pad(this.getUTCMinutes())        + timeSeparator +
    pad(this.getUTCSeconds())

  if milliseconds and this.getUTCMilliseconds() > 0
    result += '.' + pad(this.getUTCMilliseconds(), 3)

  result + 'Z'



# Date.prototype.toISO8601LocaleString
#
# Date instance method to format the date as ISO8601 / RFC 3339 string (in local
# timezone format).
#
# Usage: d = new Date().toISO8601LocaleString()
#          => "2010-07-25T19:51:31.427+08:00"
# Parameters:
#   separators   : include date/time separators? (default is true)
#   milliseconds : include milliseconds? (default is true)
Date::toISO8601LocaleString = (separators = true, milliseconds = true) ->
  dateSeparator = if separators then '-' else ''
  timeSeparator = if separators then ':' else ''

  result =
    this.getFullYear().toString() + dateSeparator +
    pad(this.getMonth() + 1)      + dateSeparator +
    pad(this.getDate())           + 'T'           +
    pad(this.getHours())          + timeSeparator +
    pad(this.getMinutes())        + timeSeparator +
    pad(this.getSeconds())

  if milliseconds and this.getMilliseconds() > 0
    result += '.' + pad(this.getMilliseconds(), 3)

  tzOffset = this.getTimezoneOffset()
  if tzOffset >= 0
    result += '-'
  else
    result += '+'
    tzOffset *= -1

  result + pad(tzOffset / 60) + timeSeparator + pad(tzOffset % 60)



# Date.parseISO8601
#
# Parses ISO8601 / RFC 3339 date strings to a Date object. Uses native browser
# parsing if available.
#
# Usage: Date.parseISO8601("2010-07-20T15:00:00Z")
if supportsISO8601   # With browser support, just use the default constructor
  Date.parseISO8601 = (input) -> new Date(input)

else  # Otherwise, here's the polyfill
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

  Date.parseISO8601 = (input) ->
    return input if Object::toString.call(input) == '[object Date]'
    return if typeof input != 'string'

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



# Date.parse
#
# Parses date strings; returns time in milliseconds since the Unix epoch. See
# http://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Date/parse
#
# This polyfills the standard Date.parse to support ISO8601 / RFC 3339 date
# strings if the browser doesen't have native support.
#
# Usage: d = Date.parse("2010-07-20T15:00:00Z")
#          => 1279638000000
if typeof Date.parse != 'function'   # No built-in Date.parse, use our version
  Date.parse = (input) -> Date.parseISO8601(input)?.getTime()
else if not supportsISO8601     # No native ISO8601 support, chain our version
  oldDateParse = Date.parse
  Date.parse = (input) ->
    result = Date.parseISO8601(input)?.getTime()
    result = oldDateParse(input) if not result and oldDateParse
    result
