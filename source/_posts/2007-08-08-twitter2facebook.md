---
id: 37
title: Twitter2Facebook
date: 2007-08-08T16:19:00+00:00
author: Danjones
layout: post
guid: http://goodevilgenius.org/wordpress/2007/08/08/twitter2facebook/
permalink: /twitter2facebook/
blogger_permalink: /2007/08/twitter2facebook.html
blogger_author: Dan Jones
blogger_blog: goodevilgenius.blogspot.com
pvc_views: 112

---
One of these days, I promise I'm going to write about something other than my [Greasemonkey](http://www.greasespot.net) scripts. Today, however, will not be one of these days.

I recently subscribed to [Twitter](http://twitter.com/), which is a social networking site dedicated entirely to tell your friends what you're doing. Well, I decided it would be great if I could keep my Facebook status set to my Twitter status. I thought this would be a good idea because I can set my twitter status from just about anywhere ([even Facebook](http://apps.facebook.com/twitter)). I began to search and found a couple programs (e.g. [this](http://www.kerrybuckley.com/2007/07/14/updating-facebook-status-from-twitter/) really nice ruby script) that could be run in the background on your computer and would do exactly this. The only problem with them was that they all would log you out of another facebook login. This is fine if I'm not actually on my computer, but if I'm on my computer using Facebook, I wouldn't want this.

So I decided to write [another Greasemonkey script](http://userscripts.org/scripts/show/11277) for Facebook that would do it in your browser, with your already logged-in facebook session.

This script will check your Twitter status every time you go to the Facebook homepage, and if it's different than your Facebook status, it will update your facebook status with your current twitter status.

I hope you enjoy it.
