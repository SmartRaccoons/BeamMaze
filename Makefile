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
	cat node_modules/gameanalytics/dist/GameAnalytics.js \
	bower_components/babylonjs/dist/preview\ release/babylon.js \
	bower_components/microevent.js/microevent.js \
	bower_components/lodash/lodash.js \
	bower_components/zepto/zepto.js \
	bower_components/universalapi/uniapi.js \
	bower_components/js-cookie/src/js.cookie.js \
	public/d/js/init.js \
	public/d/locale/en.js \
	public/d/locale/lv.js \
	public/d/js/object/data.js \
	public/d/js/object/object.js \
	public/d/js/object/blank.js \
	public/d/js/object/beam.js \
	public/d/js/object/mirror.js \
	public/d/js/view/view.js \
	public/d/js/view/router.js \
	public/d/js/view/start.js \
	public/d/js/view/stages.js \
	public/d/js/view/game.js \
	public/d/js/game/map.data.js \
	public/d/js/game/map.js \
	public/d/js/game/game.js \
	public/d/js/view/popup.js \
	public/d/js/analytics.js \
	public/d/js/run.js \
> public/d/all.js
	uglifyjs --beautify "indent-level=0" public/d/all.js -o public/d/j.js
	uglifycss public/d/css/screen.css > public/d/css/c.css
	rm public/d/all.js

	# convert ../download.png -crop 400x400+200+50 -resize 200x200 public/stage/l-3.png
