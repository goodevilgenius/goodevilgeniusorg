---
id: 326
title: How I automatically download YouTube videos recommended on Reddit
date: 2013-09-05T02:37:50+00:00
author: Danjones
layout: post
guid: http://goodevilgenius.blogs.goodevilgenius.org/?p=326
slug: how-i-automatically-download-youtube-videos-recommended-on-reddit
tags:
    - software
    - projects
---
There are a number of subreddits in which people regularly post links to YouTube videos that I might like to later view. I've put together a system that downloads these videos to my computer for later viewing. I thought other people might like to learn how I've put this together so that they can reproduce it on their home computer. For the purpose of this tutorial, I'll use [/r/Music](http://www.reddit.com/r/Music "/r/Music") as an example, since it frequently contains posts to music videos.

There are a number of prerequisites to make this work. I think my method should, theoretically, work on any operating system, but I use Linux (Ubuntu, specifically), and think it's probably a lot easier to set up there than any other OS. The other programs you'll need are:

  * A web server that can handle PHP (I use [Apache](http://httpd.apache.org/ "Apache HTTP Server Project"))
  * [PHP](http://php.net/ "PHP: Hypertext Preprocessor")
  * [youtube-dl](http://rg3.github.io/youtube-dl/ "youtube-dl")
  * [FlexGet](http://flexget.com/ "FlexGet")
  * A task scheduler, such as [cron](http://en.wikipedia.org/wiki/Cron "cron - Wikipedia, the free encyclopedia")

Additionally, there is a PHP script I wrote to make it work together, but we'll get to that later. youtube-dl and FlexGet both require Python, and several other dependencies.

<!--more-->

I'll start with FlexGet, because that's the program that will actually find the new videos. FlexGet is kind of a super-charged podcatcher. What it does is look through a data source (such as an RSS feed) for new entries, and either downloads referenced files in those entries, or passes on the information to another program to handle the data. Everything it can do is beyond this tutorial, and I recommend you peruse the website.

To get the data, I'd need a data source that could be parsed to get the links. FlexGet could just grab the front page of the desired subreddit, and parse the data using some very cool string matching and stuff, but that would have involved a lot of stuff for me to figure out, and if reddit significantly changed the design of the site, it could break. So, thankfully, Reddit also provides RSS feeds for every subreddit. Just append .rss to the end of the subreddit URL. So, for /r/Music, the RSS URL would be `http://www.reddit.com/r/Music.rss`.

The problem with these RSS feeds is that when someone posts a link, the URL in the RSS feed is to the comment page, rather than the link. The actual link is available, but it's in the description, rather than the link. For what I'm doing, I just want the actual link to the YouTube video, not the comment page. Now, FlexGet is super flexible. I'm pretty sure I could use FlexGet alone to extract the YouTube URL with no problem, but I had another idea for something that could potentially useful elsewhere.

So, I wrote a PHP script (&lt;https://gist.github.com/goodevilgenius/6426099>) that can be used to rewrite a Reddit RSS feed so that the link for each item is the actual posted link. It can also filter out entries that don't match a given criteria. My criteria is that they have a YouTube url.

So, to use this script, download it from github (in the above URL), and place it somewhere on your local (or remote, if you want) web server. I'll suppose you have a path to it like http://localhost/path/to/reddit\_rss\_linker.php. The script takes a Reddit RSS URL as a `url` query parameter. It also accepts a `filter` and `filter_item` parameter. `filter` should be a regular expression of the form that can be passed to [preg_match](http://us3.php.net/manual/en/function.preg-match.php) as the $pattern. So, to match a youtube URL, I use `@http://(www\.)?(youtube\.com|youtu\.be)@`. That works pretty well for me. I could improve it to only recognize an actual video page, but the seems unnecessary. The filter_item would be the item within the RSS feed that you want to match the filter against.

So, with the URL example I previously gave, to get the modified feed for /r/Music, I would use the following URL http://localhost/path/to/reddit\_rss\_relinker.php?url=http%3A%2F%2Fwww.reddit.com%2Fr%2FMusic.rss&filter=%40http%3A%2F%2F%28www%5C.%29%3F%28youtube.com%7Cyoutu.be%29%2F%40&filter_item=link.

Now, FlexGet can't actually download YouTube videos by itself. So, that's where youtube-dl comes in. Read up about it on its website. The one thing I need to mention is that it must be updated on a regular basis. YouTube is constantly changing stuff (especially some copy protection schemes that frequently affect VEVO videos), so the developer is constantly updating the application to make sure it continues to work with the most recent updates on YouTube. So, if you don't keep your installation of youtube-dl up-to-date, if may fail, and you might not notice you're not getting your videos anymore. The developer included an update feature within the app itself. If you install the app from a repository within your operating system (as I did), make sure you still update it from within the app, because the repos will not stay up-to-date. I added a daily cronjob to keep my copy up-to-date. The command is simply `youtube-dl -U`.

So, to combine all these together, you would have a flexget config file like this:

```yaml
tasks:
  reddit-Music:
    rss: http://localhost/path/to/reddit_rss_relinker.php?url=http%3A%2F%2Fwww.reddit.com%2Fr%2FMusic.rss&filter=%40http%3A%2F%2F%28www%5C.%29%3F%28youtube.com%7Cyoutu.be%29%2F%40&filter_item=link
    accept_all: true
    exec: youtube-dl -f 18 --restrict-filenames -o "/path/to/YouTubeVideos/%(uploader)s/%(title)s-%(id)s.%(ext)s" "{{url}}"
```

This is very basic, and FlexGet can do a lot more (emails when new downloads drop are nice). So, I recommend you read up on the program.

The final step is simply to add flexget to your task scheduler (cron). I'm going to assume you can figure that part out yourself.

And there you have it: an automatic Reddit YouTube downloader.
