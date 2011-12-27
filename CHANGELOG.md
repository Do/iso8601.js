## 0.2.0 (2011-12-27)

* API changed to match [ECMAScript 5.1][ecmascript] ISO 8601 support for the
  Date object.
  * `Date.prototype.toISO8601UTCString` is now `Date.prototype.toISOString`.
  * `Date.prototype.toISO8601LocaleString` has been removed. Similar formatting
    is available by passing *true* to `Date.prototype.toISO8601String` which
    allows other customizations as well.
* ISO 8601 UTC formatting falls back to native support if available. Performance
  improvement on modern browsers for common usages.
* Stricter browser test for native ISO 8601 parsing. Ensures timezone offsets
  are correctly handled. Fixes Firefox issues.
* Unit tests. Suite runs via node or browser harness.

## 0.1.0 (2011-12-23)

* First release. Extracted from the Do web client, based on Paul Gallagher's
  [rfc3339date.js library][rfc3339date.js].



[ecmascript]:     http://www.ecma-international.org/publications/files/ECMA-ST/Ecma-262.pdf
[rfc3339date.js]: https://github.com/tardate/rfc3339date.js
