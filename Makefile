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
	bower_components/lodash/lodash.js \
	bower_components/zepto/zepto.js \
	bower_components/universalapi/uniapi.js \
	bower_components/js-cookie/src/js.cookie.js \
	bower_components/howler.js/dist/howler.js \
	public/d/js/init.js \
	public/d/locale/en.js \
	public/d/locale/lv.js \
	public/d/js/object/data.js \
	public/d/js/object/object.js \
	public/d/js/object/text.js \
	public/d/js/object/blank.js \
	public/d/js/object/beam.js \
	public/d/js/object/mirror.js \
	public/d/js/game/map.data.js \
	public/d/js/game/map.js \
	public/d/js/game/game.js \
	public/d/js/view/view.js \
	public/d/js/view/router.js \
	public/d/js/view/start.js \
	public/d/js/view/game.js \
	public/d/js/view/popup.js \
	public/d/js/analytics.js \
	public/d/js/sound.js \
> public/d/all-before.js

	cat public/d/all-before.js \
	public/d/js/run.js \
> public/d/all.js
	uglifyjs --beautify "indent-level=0" public/d/all.js -o public/d/j.js
	rm public/d/all.js

	cat public/d/all-before.js \
	public/d/js/platform/draugiem.js \
	public/d/js/run.js \
> public/d/all-draugiem.js
	uglifyjs --beautify "indent-level=0" public/d/all-draugiem.js -o public/d/j-draugiem.js
	rm public/d/all-draugiem.js

	cat public/d/all-before.js \
	public/d/js/platform/offline.js \
	public/d/js/run.js \
> public/d/all-offline.js
	uglifyjs --beautify "indent-level=0" public/d/all-offline.js -o public/d/j-offline.js
	rm public/d/all-offline.js

	rm public/d/all-before.js
	uglifycss public/d/css/screen.css > public/d/css/c.css

	# convert ../download.png -crop 400x400+200+50 -resize 200x200 public/stage/l-3.png
