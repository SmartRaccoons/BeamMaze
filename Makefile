install :
	bower install
upgrade :
	bcu -a
	bower update

compile :
	grunt compile

run :
	coffee app_dev.coffee

production-mobile :
	grunt compile
	grunt compile-cocoon
	grunt cocoon-upload
