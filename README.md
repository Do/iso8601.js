iso8601.js [![Build Status][buildstatus]][travis]
=================================================

Partial cross-browser polyfill to add [ISO 8601][iso8601] support to
**Date.parse** and **Date.prototype.toISOString** as defined in ECMAScript 5.1.
Originally based on Paul Gallagher's [rfc3339date.js library][rfc3339date.js].

Supports only the subset of ISO 8601 described in
[ECMAScript 5.1 section 15.9.4.2][ecmascript], [RFC 3339][rfc3339], and the
[Date and Time Formats W3C NOTE][w3c-note].


## Usage

Download [iso8601.js][downloads] and include before other scripts:

```html
<script src="iso8601.min.js"></script>
```

Using [Sprockets 2][sprockets]? There's a gem version. Add to your Gemfile:

```ruby
gem 'iso8601-js'
```

For Rails 3.1+, the library is automatically added to your asset paths. For
other frameworks, add `ISO8601JS.assets_path` to your Sprockets environment:

```ruby
env = Sprockets::Environment.new  # or however you initialize Sprockets
env.append_path ISO8601JS.assets_path
```

Include it in your JavaScript or CoffeeScript files with the `= require`
Sprockets directive:

JavaScript:

```javascript
//= require iso8601
```

CoffeeScript:

```coffee-script
#= require iso8601
```


## Parsing

Parse ISO 8601 date/time strings two ways:

* **Date.parseISO8601** creates a Date instance from a ISO 8601 date string.
* **Date.parse** is polyfilled to attempt ISO 8601 parsing before using the
  browser's native `Date.parse`. Returns the number of milliseconds between the
  Unix epoch and the date. [*EC5 15.9.4.2*][ec15.9.4.2]

Examples:

```js
Date.parseISO8601("2010-07-20T15:00:00Z")
// => Tue Jul 20 2010 08:00:00 GMT-0700 (PDT)

Date.parse("2010-07-20T15:00:00Z")
// => 1307834445456
```


## Formatting

Format ISO 8601 date strings directly from Date instances:

* **Date.prototype.toISOString** generates an ISO 8601 UTC string.
  [*EC5 15.9.5.32*][ec15.9.5.43]. Throws `RangeError` for invalid dates.
* **Date.prototype.toJSON** generates an ISO 8601 UTC string for use by
  JSON.stringify. Returns `null` for invalid dates.
  [*EC5 15.9.5.44*][ec15.9.5.44]
* **Date.prototype.toISO8601String** generates an ISO 8601 string with
  formatting options:
  * *localTimezone*: Use local timezone with offset or UTC? Defaults to *false*.
  * *separators*: Include date/time separator? Defaults to *true*.
  * *milliseconds*: Include milliseconds? Defaults to *true*.

Examples:

```js
var date = Date.parseISO8601("2010-07-20T15:00:00Z")

date.toISOString()
// => "2010-07-20T15:00:00.000Z"

date.toJSON()
// => "2010-07-20T15:00:00.000Z"

date.toISO8601String(true, true, false)
// => "2010-07-20T08:00:00-07:00"
```


## Other

Other EC5 Date-related polyfills:

* **Date.now** returns the number of milliseconds since the Unix epoch.
  [*EC5 15.9.4.4*][ec15.9.4.4]

Examples:

```js
Date.now()
// => 1325174662624
```


## Caveats

The Date constructor is not polyfilled to support ISO 8601. Avoid using `new
Date("...")` to parse strings.


## Contributing

iso8601.js is written in [CoffeeScript][coffeescript]. Use `npm install` to
install required development packages. Compile minified JavaScript output with
`make`. Run the test suite via `make test`.

Patches and bug reports are always welcome. Just send a
[pull request][pullrequests] or file an [issue][issues].



[buildstatus]:    https://secure.travis-ci.org/Do/iso8601.js.png?branch=master "Build status"
[travis]:         http://travis-ci.org/Do/iso8601.js
[iso8601]:        http://en.wikipedia.org/wiki/ISO_8601
[rfc3339date.js]: https://github.com/tardate/rfc3339date.js
[ecmascript]:     http://www.ecma-international.org/publications/files/ECMA-ST/Ecma-262.pdf
[rfc3339]:        http://www.ietf.org/rfc/rfc3339.txt
[w3c-note]:       http://www.w3.org/TR/NOTE-datetime
[downloads]:      https://github.com/Do/iso8601.js/downloads
[sprockets]:      https://github.com/sstephenson/sprockets
[ec15.9.4.2]:     http://es5.github.com/#x15.9.4.2
[ec15.9.5.43]:    http://es5.github.com/#x15.9.5.43
[ec15.9.5.44]:    http://es5.github.com/#x15.9.5.44
[ec15.9.4.4]:     http://es5.github.com/#x15.9.4.4
[coffeescript]:   http://coffeescript.org/
[pullrequests]:   https://github.com/Do/iso8601.js/pulls
[issues]:         https://github.com/Do/iso8601.js/issues
