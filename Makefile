install :
	bower install
upgrade :
	bcu -a
	bower update

compile :
	grunt compile

run :
	python -m SimpleHTTPServer 8111

production :
	grunt compile
	cat bower_components/babylonjs/dist/preview release/babylon.js \
	public/d/js/init.js \
	public/d/locale/en.js \
	public/d/js/game.js \
> public/d/all.js
	uglifyjs --beautify "indent-level=0" public/d/all.js -o public/d/j.js
	rm public/d/all.js


