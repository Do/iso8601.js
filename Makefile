all:
	mkdir -p ./out
	./node_modules/.bin/coffee -o out -c lib/iso8601.coffee
	./node_modules/.bin/uglifyjs -o out/iso8601.js.min out/iso8601.js

clean:
	rm out/*
