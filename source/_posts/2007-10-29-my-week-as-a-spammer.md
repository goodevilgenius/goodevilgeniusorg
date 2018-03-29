---
id: 15
title: My week as a spammer.
date: 2007-10-29T15:36:26+00:00
author: Danjones
layout: post
guid: http://goodevilgenius.org/blog/index.php?/archives/13-guid.html
permalink: my-week-as-a-spammer
jd_tweet_this: yes
pvc_views: 30

---
So, last week, I was trying to think of new ways to spread the word about our [entry into the Insomnia Film Festival](/2007/10/17/apple-insomnia-film-contest-2007/). As I was thinking of ways to spread the word, the [student directory](https://directory.utexas.edu/) at my school came to my mind. It lists all the students, faculty, and staff at the university who haven't specifically restricted their listing. All in all, that comes to about 70,000 people. I thought that if I could search that directory, and send an email off to everyone in it asking them to vote for our entry, surely at least 1% of them would vote. That would send our rating through the roof! Yeah, I knew this was spam, but it was for a good cause so it seemed like a good idea to me.

So I looked into the directory and found out that I didn't even need to use the web interface to access it. I was planning on writing a program that would send queries to through the web site, and parsing the results. Not easy, but not that awful. But I didn't even need to do that. There's a little program on my computer called `finger` that could query the server, and send back the results in a nice, easy to parse format. One caveat though: it would only return the first 50 matches to each query. So, I would have to try many different permutations to get a good number of results. So, I typed out a few commands that would loop through the number 0-999, two letter permutations (aa, ab, ac &#8230; zz), and three letter permutations. It would write the results to a file, sort the file alphabetically, and remove duplicate entries. When that loop finished (after a little more than a day), I had 53,380 unique email addresses for [University of Texas](https://www.utexas.edu) students, faculty, and staff. I actually never showed up in the list, but with such a common name, that wasn't too surprising.

Ok, so I had the addresses, the next step was to write a good email and send them out. Here's what the email said: 

> Dear {name},
> 
> How would you like to support a group of UT filmmakers? We're a small group of UT students who
  
> recently produced a film for the Insomnia Film Festival sponsored by Apple. For this festival,
  
> we, and other college and high school students across the nation, shot, edited, and scored a
  
> three-minute film in only 24 hours. Now we'd like your help.
> 
> This festival is a vote-based contest. Those in the top 25 get their film featured in Apple
  
> Stores across the nation. Our film, "Crosswalk," can be seen [at Apple's website](http://edcommunity.apple.com/insomnia_fall07/item.php?itemID=3D1839). For instructions on how to register to vote, you can go [here](http://goodevilgenius.org/blog/index.php?/archives/12-Vote-for-Crosswalk-in-the-2007-Insomnia-Film-Contest.html).
> 
> We'd love it if you would view our film, and if you like it, give it a four-star rating.

So, now that I had this great email, the next step was to send it off. Now comes the problem. The mail server on my computer is a little buggy. It sends emails off pretty slowly, and while it's fine for everyday use, sending off 50,000 emails would take forever, and bottleneck any other email I want to send off while it's sending the others. So, in my excitement, I came up with what I thought was a brilliant idea. Being in the Computer Science Department, I had access to the CS Department's computers, and I could even log in remotely. And I knew that their mail server wouldn't be buggy like mine, since I'm sure it transmits well over 50,000 emails on any given day. I was sure that if I sent mine off from UT, it would just be a drop in the bucket, and nobody would mind. So, I logged in to one of the headless machines (i.e., computer without a monitor) from my home computer. I copied the list over, and wrote a little script to send them off. Before I started to send them, I checked to see if anyone else was logged in to the same machine. Nobody was, so I started sending them off, and it seemed to be working fine. After about 2/3 of them were sent off, I noticed that I started getting back a weird error. They weren't sending properly. Then I noticed an email in my inbox from, apparently, one of the lab admins. It read thusly:

> Do you know that you have 37,000+ messages queued up on olympus {the name of the computer} to addresses all over the Internet? Is this intentional? Can you convince me it is not spam? i.e., do all these recipients know you and did they solicit your email? Or is this unsolicited email?
> 
> Did it ever occur to you to ask before doing this?
> 
> I have disabled email on olympus.

Of course, it hadn't occurred to me to ask beforehand. I didn't even think anyone would mind. Clearly, I hadn't thought through this properly.

A little while later, I received another email from one of the higher-ups in the department. It wasn't actually addressed to me, just CCed to me. It was addressed to the guys who administer the CS user accounts. It read:

> If we don't see a reply by tomorrow morning, please turn this account off.

Oh crap! This was more serious than I thought. So, I immediately sent a reply to the first email I got.

> Yes, these were unsolicited emails. However, they weren't commercial.
> They were sent to UT students/faculty/staff informing them about a
> contest in which a few UT students were competing, encouraging them to
> vote in the contest. 
> 
> I realize now I probably should have asked before I sent out such a
> large volume of email, but I guessed that several thousand were probably
> not much when one considers how many emails are sent through the email
> server everyday. 
> 
> I also checked olympus before I started sending them out to see if
> anyone else was logged in to the computer beforehand, so that I wouldn't
> be hogging resources from somebody else on the same machine. 
> 
> I apologize for my actions, and in the future, I will not use University
> machines for my own personal projects. 
> 
> Apologetically,   
> Dan Jones

I hoped that would fix it. About half an hour later, however, I noticed I had been booted off of olympus. It could have just been a timeout. I logged back on, but it wouldn't let me. I tried my CS department email, and it still worked, but I couldn't log in to the computers. Not a huge deal, but a thought occurred to me. The CS department has a website you log into to turn in homework assignments. You have to use your computer account to login. I tried it, and couldn't log in! This was not good. I decided to send a response to the second email, to the higher-up in the department.

> I have responded to the mail (my response is attached),
> and I am very sorry for what I have done. 
> 
> My account seems to be disabled. I fully accept the consequences of my
> actions, and feel it is fully justifiable to deny me access to the CS
> computers, however, disabling my account also restricts my access to
> Turnin. I do still have assignments I need to turn in there, and it
> seems too harsh to not allow me to do my assignments.
>
> I promise I will never use University computers for my own projects
> again. I just ask that I be able to still use Turnin so I can continue
> to do my coursework. 
> 
> Sincerely,
>
> Dan Jones

I received no response. So, I decided to forward this to the guys responsible for administrating the accounts, telling them that while I could still check my email, I had no access otherwise. Remember that the email telling them to cut my account said to do so by the next morning if I didn't respond. I did respond, and they cut it immediately after my response. I wasn't sure what to do. I waited, and less than half an hour later, I couldn't get my department email anymore. I decided there was nothing else I could do right then, so I forgot about it until the next day.

The next day, I still had no access to my account, but I did have a new email in my main UT email account inbox.

> The Information Security Office at The University of Texas at Austin has
> received a report that you have used UT Austin's mail system
> inappropriately. The report specifically alleges you, or someone using an
> account that you are responsible for, used the mail system to send
> unsolicited email (spam). 
> 
> While you certainly have a right to distribute information to those who
> have indicated a desire to receive it, sending the information to large
> groups of recipients who may not have requested it is a violation of
> University policies and can result in a suspension of network privileges,
> disciplinary action, or both. I've attached a copy of the message attributed
> to you which is the subject of the complaint and which, on it's face, does
> appear to violate University policies. 
> 
> 
> 
> The complete policy regarding acceptable use and your responsibilities
> as a user can be found at: 
> 
> http://www.utexas.edu/its/policies/responsible.php 
> 
> The rules for acceptable use provide: 
> 
> > Section IV:
> > 
> > 7. Use resources appropriately. Do not interfere with the activities
> > of others or use a disproportionate share of resources. Send messages
> > only to those who may be interested in the content. Examples of
> > inappropriate use of resources are shown below. These actions frequently
> > result in complaints and subsequent disciplinary action.
> > 
> >   * Sending a message at random to a large number of newsgroups
> >     or recipients (known as "spamming the network").
> >   * Attempting to inconvenience someone by sending a large number of
> >     messages (commonly referred to as a "mail bomb").
> >   * Deliberately causing any denial of service, including flooding
> >     or ICMP attacks ("ping attacks").
> >   * Excessively controlling a chat channel by such actions as kicking
> >     off or blocking other users.
> 
> Student Judicial Services will be informed if there is a second complaint.
> If you have any questions please contact SJS at: 
> 
> http://deanofstudents.utexas.edu/sjs/ 

Wow! This was getting pretty serious, but it was just a warning. So, I used the same finger program I used to get the emails to see if my CS account was still active. It showed up, so they hadn't deleted it, just disabled it. I decided to send another email from my main UT email account to the guys in charge of CS accounts.

> I am the owner of the CS account with the username drj.
> 
> I was recently involved in an issue where my account was disabled due to
> innapporpriate behavior. I have received a warning from the Student
> Judicial Services, and have already stated multiple times that I realize
> my actions were innappropriate, and it will not happen again. 
> 
> I remain unable to access my account, and without my account, I am
> unable to use the Turnin program to turn in my school assignments. 
> 
> I can see (through finger) that my account has not been deleted, and I
> would like to know if I am going to be given access to my account once
> again. I can accept not being able to use departmental computers again,
> but I cannot do my schoolwork without access to Turnin. 
> 
> Since I have no way to access my cs email account, I would appreciate a
> response to this email address. 
> 
> Thank you,
>
> Daniel Jones

Later that day, I received a response to that email from the same higher-up initially involved.

> Dear Mr. Jones, 
> 
> Please come see me tomorrow to discuss what happened. I am available
> from 10-11:30.

I went to see her the next morning. I arrived just after 10. I knocked on her office door, and she called me into the office. She was in a meeting. "I'm Dan Jones."

"Oh, you're the bad guy. Could you give me five minutes?"

I'm the bad guy apparently. I wait until the meeting ends and everyone leaves. She calls me in. I don't remember the exact conversation, so I'll paraphrase.

> "Because of the enormity of what you did, we had to disable your account. I just want to know what you were thinking."
> 
> "Well, I wasn't really. Did you actually read the email itself?"
> 
> "Yeah, something about a film contest."
> 
> "Yeah, well, I really just wanted to help a friend. I knew this was a way I could help get votes for his film. I was just so excited to help him I didn't use my common sense and think through what I was doing. Looking back on it, I realize that it was a bad idea, and not clearly thought out. I'm really very sorry for it."
> 
> "Well, you know, this doesn't just affect you, it affects the whole department. ITS found out about this, and now we look like we have no control over our students. They start asking questions like, 'Why do you let your students do these sorts of things?' It makes the whole department look bad."
> 
> "I understand."
> 
> "What you do on your home computer is completely your own business, but once you use our computers, it becomes our business."
> 
> "Right"
> 
> "Normally, we'd delete your account right off, and you'd have to deal with the consequences. You tell me it was a stupid mistake. We're all allowed to make stupid mistakes. I'm going to tell them to reactivate your account. But I want you to read every single department and university policy. Because if you violate even the smallest one, your account is gone, and if that affects your academics, you'll have to deal with it."
> 
> "Ok, I will."
> 
> "Alright. I don't want to see your name again until you graduate."
> 
> "Ok, thank you so much. I really appreciate it."

And so, all has return back to normality. I've certainly learned a few lessons about shared resources and proper computer use that I won't soon forget. And that is the story of my week as a spammer.
