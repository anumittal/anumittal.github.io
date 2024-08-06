init:
	hash bundle

install:
	bundle install
	# gem install nokogiri
	hash jekyll

build:
	bundle exec jekyll build

serve:
	bundle exec jekyll serve --watch

upgrade:
	bundle outdated
