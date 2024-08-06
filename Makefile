init:
	hash bundle

install:
	bundle install
	# gem install nokogiri
	hash jekyll

build:
	bundle exec jekyll build

upgrade:
	bundle outdated
