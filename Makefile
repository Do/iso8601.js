all:
	mkdir -p ./out
	./node_modules/.bin/coffee -o out -c lib/iso8601.coffee
	./node_modules/.bin/uglifyjs -o out/iso8601.js.min out/iso8601.js

clean:
	rm out/*

test:
	TZ='PST+8' ./node_modules/.bin/mocha --reporter spec

testbrowser:
	echo "Browse to http://localhost:8000/test/browser/index.html"
	python -m SimpleHTTPServer

.PHONY: all clean test testbrowser
