.PHONY: clean deps build serve all

export PATH := $(HOME)/bin:$(PATH):/usr/local/bin

POINT=$(shell echo $$((RANDOM%79+128512)) )
EMOJI=$(shell printf '%x' $(POINT) )

IP ?= 127.0.0.1
PORT ?= 4000

all: serve

clean:
	rm -rf public

package-lock.json: package.json
	npm install

node_modules/hexo/bin/hexo: package-lock.json
	npm ci
	# Fix stupid, intentional timestamp bug https://github.com/npm/npm/pull/20027
	find node_modules -type f -exec touch {} +

deps: node_modules/hexo/bin/hexo

public/index.html: node_modules/hexo/bin/hexo
	npx hexo generate

build: public/index.html

serve: build
	npx hexo server -i "$(IP)" -p "$(PORT)"
