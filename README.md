iso8601.js
==========

Adds [ISO 8601][iso8601] date parsing and formatting to the JavaScript Date
object. Based on Paul Gallagher's [rfc3339date.js library][rfc3339date.js].

Supports only the subset of ISO 8601 described as part of [RFC 3339][rfc3339]
and the [Date and Time Formats W3C NOTE][w3c-note].


## Usage

Download [iso8601.js][downloads] and include as usual before other scripts:

```html
<script src="iso8601.min.js"></script>
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

console.log(Date.parse("2010-07-20T15:00:00Z");
// => 1307834445456
```


## Formatting

Format ISO 8601 date strings directly from Date instances:

* **toISO8601UTCString** generates an ISO 8601 string in UTC.
* **toISO8601LocaleString** generates an ISO 8601 string with the offset equal
  to the browser's local timezone.

Examples:

```js
var date = Date.parseISO8601("2010-07-20T15:00:00Z");

console.log(date.toISO8601UTCString());
// => "2010-07-20T15:00:00Z"

console.log(date.toISO8601LocaleString());
// => "2010-07-20T08:00:00-07:00"
```


## Caveats

The Date constructor is not polyfilled to support ISO 8601. Avoid using `new
Date("...")` to parse strings.


## Contributing

iso8601.js is written in [CoffeeScript][coffeescript].

Patches and bug reports are always welcome. Just send a
[pull request][pullrequests] or file an [issue][issues].



[iso8601]:        http://en.wikipedia.org/wiki/ISO_8601
[rfc3339date.js]: https://github.com/tardate/rfc3339date.js
[rfc3339]:        http://www.ietf.org/rfc/rfc3339.txt
[w3c-note]:       http://www.w3.org/TR/NOTE-datetime
[downloads]:      https://github.com/Do/iso8601.js/downloads
[coffeescript]:   http://coffeescript.org/
[pullrequests]:   https://github.com/Do/iso8601.js/pulls
[issues]:         https://github.com/Do/iso8601.js/issues