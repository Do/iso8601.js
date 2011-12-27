iso8601.js
==========

Partial ECMAScript 5.1 Date object cross-browser polyfill to add
a [ISO 8601][iso8601] support to **Date.parse** and
**Date.prototype.toISOString**. Originally based on Paul Gallagher's
a [rfc3339date.js library][rfc3339date.js].

Supports only the subset of ISO 8601 described in
a [ECMAScript 5.1 section 15.9.4.2][ecmascript], [RFC 3339][rfc3339], and the
a [Date and Time Formats W3C NOTE][w3c-note].


## Usage

Download [iso8601.js][downloads] and include as usual before other scripts:

```html
<script src="iso8601.min.js"></script>
```

If you're using [Sprockets 2][sprockets], you can use the gem version of the
library. Add to your Gemfile:

```ruby
gem 'iso8601-js'
```

If using Rails 3.1+, the library is automatically added to your asset paths.
Otherwise add `ISO8601JS.assets_path` to your Sprockets environment:

```ruby
env = Sprockets::Environment.new  # or however you initialize Sprockets
env.append_path ISO8601JS.assets_path
```

Then require it from the appropriate JavaScript or CoffeeScript files with the
`= require` Sprockets directive:

JavaScript:

```javascript
//= require iso8601-js
```

CoffeeScript:

```coffee-script
#= require iso8601-js
```


## Parsing

Parse ISO 8601 date/time strings two ways:

* **Date.parseISO8601("...")** builds a Date instance from a string containing
  an ISO 8610 date.
* **Date.parse("...")** is polyfilled to attempt ISO 8601 parsing on the string
  before using the browser's native `Date.parse`. Returns the number of
  milliseconds between the Unix epoch and the date.

Examples:

```js
console.log(Date.parseISO8601("2010-07-20T15:00:00Z"))
// => Tue Jul 20 2010 08:00:00 GMT-0700 (PDT)

console.log(Date.parse("2010-07-20T15:00:00Z"));
// => 1307834445456
```


## Formatting

Format ISO 8601 date strings directly from Date instances:

* **Date.prototype.toISOString** generates an ISO 8601 string in UTC.
* **Date.prototype.toISO8601String** generates an ISO 8601 string with
  formatting options:
  * *localTimezone*: Use local timezone with offset or UTC? Defaults to *false*.
  * *separators*: Include date/time separator? Defaults to *true*.
  * *milliseconds*: Include milliseconds? Defaults to *true*.

Examples:

```js
var date = Date.parseISO8601("2010-07-20T15:00:00Z");

console.log(date.toISOString());
// => "2010-07-20T15:00:00.000Z"

console.log(date.toISO8601String(true, true, false));
// => "2010-07-20T08:00:00-07:00"
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



[iso8601]:        http://en.wikipedia.org/wiki/ISO_8601
[rfc3339date.js]: https://github.com/tardate/rfc3339date.js
[ecmascript]:     http://www.ecma-international.org/publications/files/ECMA-ST/Ecma-262.pdf
[rfc3339]:        http://www.ietf.org/rfc/rfc3339.txt
[w3c-note]:       http://www.w3.org/TR/NOTE-datetime
[downloads]:      https://github.com/Do/iso8601.js/downloads
[sprockets]:      https://github.com/sstephenson/sprockets
[coffeescript]:   http://coffeescript.org/
[pullrequests]:   https://github.com/Do/iso8601.js/pulls
[issues]:         https://github.com/Do/iso8601.js/issues
