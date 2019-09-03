.PHONY: clean stage serve all

export PATH := $(HOME)/bin:$(PATH):/usr/local/bin

POINT=$(shell echo $$((RANDOM%79+128512)) )
EMOJI=$(shell printf '%x' $(POINT) )

IP ?= 127.0.0.1
PORT ?= 4000

all: serve

clean:
	rm -rf public

stage: clean
	npx hexo generate

serve: stage
	echo https://goodevilgeniusorg-goodevilgenius.c9users.io/
	npx hexo server -i "$(IP)" -p "$(PORT)"
