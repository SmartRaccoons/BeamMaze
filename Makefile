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
	cat bower_components/babylonjs/dist/preview\ release/babylon.js \
	bower_components/microevent.js/microevent.js \
	bower_components/lodash/lodash.js \
	public/d/js/init.js \
	public/d/locale/en.js \
	public/d/js/object/data.js \
	public/d/js/object/object.js \
	public/d/js/object/blank.js \
	public/d/js/object/mirror.js \
	public/d/js/object/beam.js \
	public/d/js/object/platform.js \
	public/d/js/map.data.js \
	public/d/js/map.js \
	public/d/js/game.js \
	public/d/js/debug.js \
	public/d/js/run.js \
> public/d/all.js
	uglifyjs --beautify "indent-level=0" public/d/all.js -o public/d/j.js
	rm public/d/all.js
