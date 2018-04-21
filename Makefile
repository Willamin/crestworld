.PHONY: build
.DEFAULT_GOAL := build

build:
	rm -rf /Users/will/.cache/crystal/*crestworld*.cr
	shards build
