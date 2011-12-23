all:
	./node_modules/.bin/coffee -c iso8601.coffee
	./node_modules/.bin/uglifyjs -o iso8601.js.min iso8601.js

clean:
	rm *.js *.js.min
