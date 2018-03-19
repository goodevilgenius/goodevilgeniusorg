---
id: 339
title: 'membash: Memcache for the BASH shell'
date: 2014-04-28T19:48:51+00:00
author: Danjones
layout: post
guid: http://goodevilgenius.blogs.goodevilgenius.org/?p=339
permalink: /2014/04/28/membash-memcache-for-the-bash-shell/

---
I recently had an idea that required using [memcache](http://memcached.org/ "memcached") from a [BASH](https://www.gnu.org/software/bash/ "Bash - the Bourne Again SHell") script. So, I decided I would write a script that would allow me to do exactly that.

First, I set out to find if anyone had already done that. I found [a script on github](https://gist.github.com/ri0day/1538831 "memcache_cli.sh") that supposedly could do that already, but it doesn't work on [Debian](http://www.debian.org/ "Debian - the universal operating system")-based systems (such as my OS of choice: [Ubuntu](http://www.ubuntu.com/)), and it didn't seem very user friendly, anyhow. So, I forked that project and created [my own version](https://gist.github.com/goodevilgenius/11375877 "membash").

<!--more-->

Aside from the original script, I found two other resources to help me flesh it out:

  * [Memcached In A shell Using nc And echo](http://www.kutukupret.com/2011/05/05/memcached-in-a-shell-using-nc-and-echo/)
  * [Memcached telnet command summary](http://blog.elijaa.org/?post/2010/05/21/Memcached-telnet-command-summary)

I ended up not needing this at all (yet), but it was still a great exercise. The entire script is available below:
