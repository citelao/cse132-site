---
title: Command Line Can Be Not Terrifying
author: Ben Stolovitz and Josh Gelbard
week: 0
assigned: 2016-01-20
due: 2016-01-20
---

* This is a TOC
{:toc}

It's time to learn that scary beast we call command line. Today's studio will walk through obtaining a Linux terminal, file browsing, file creation, output redirection, and terminal source control.

Let's begin!

## Obtaining a Linux Terminal

<aside class="sidenote">
### What am I obtaining?
{:.no_toc}

Without splitting hairs, all modern operating systems provide some sort of **command line** that can be used interact with the computer. Actually, that's all a command line is: it's a way of interacting with your computer. You're probably already used to the **GUI**, the Graphical User Interface, of your computer, but you can do most things on your computer through the command line as well.

We hold Steve Jobs as the person who popularized the GUI interface as an improvement over terminal-based computing, as it makes life easier for many things (how do you make a diagram in text? how can you see multiple programs at once?), but the command line is still incredibly useful, especially for programmers. For example, typing tends to be a lot faster than clicking, so most batch file manipulation is easier in terminal. Likewise, text is small to transfer compared to images and video, so remote server maintenance is almost completely done in terminal.

In fact, that's what we will be doing now. Because each operating system has slightly different programs available on the command line (Windows has an entirely different operating system structure, too, but that's getting about three years ahead of ourselves), we want to make sure you all work on the same type of system.

We will remotely connect (**SSH** or open a "Secure SHell" into a physical machine kindly hosted by WUSTL IT). Then, since we are on the same machine, you won't run into compatibility errors or find yourself missing something that everyone else has.
</aside>

Are you on **Mac**? We will connect to the WUSTL Linux systems just to make sure you have `svn` installed (Macs are based on UNIX, just like Linux).

1. Open up Terminal.
2. Connect to the Linux boxes WUSTL provides by typing `ssh YOURWUSTLUSERNAME@shell.cec.wustl.edu`.
3. If asked, `yes`, you want to save the RSA key.
4. Enter your WUSTL Key password, as prompted. The letters will not appear as you type.
5. When the connection opens, type `qlogin` and enter your password again when prompted[^whyq].
6. Done.

Are you on **Windows**? Windows is not a Linux machine, so we need to *connect remotely* to one.

[^whyq]: This moves your connection to a different computer so the main `shell.cec.wustl.edu` computer doesn't get overloaded with 250 connections.

1. Download [PuTTY](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html). **Note**: You only need to do this if you're using your own machine, the lab machines already have it installed.
2. Under `Host Name`, type `YOURWUSTLUSERNAME@shell.cec.wustl.edu`.
3. Click `Open`, entering your WUSTL password when prompted.
4. When the connection opens, type `qlogin` and enter your password again when prompted[^whyq].
5. Done!

## File Browsing

Well, you got yourself a terminal window. You might want to get your bearings.

### What's the current directory?

1. The terminal is at its core a **file browser**. You can navigate through directories and perform actions on the files within.

	Which directory are you in now? Print the **working directory** with the `pwd` command. 

	This command prints the **absolute path** to your folder, from the **root directory** on your computer (or the remote computer in this case). It is always represented as `/`. A plain `/` is the root directory.

2. Now try typing `dirs`. This prints a **relative path**, relative to your **home directory**, `~`. Like the root directory, a plain tilde *always* means your home directory. 

	Each user on a Linux machine has their own home directory. You can figure out the *absolute path* to your home directory by comparing the outputs from the `pwd` and `dir` commands. What is it?
2. What files are in the current directory? `ls` will tell you.
3. Write down the absolute path to your home directory and the list of files in your current directory. You will enter these into a coversheet later in this lab. If you have a large list of files in your current directory, just write down a few.

The directory you are currently in will not do. We will be creating several files today, and we don't want to clutter the home directory.

### Breaking new ground

<aside class="sidenote">
#### More than you ever wanted to know about paths
{:.no_toc}

Paths should be familiar to you, if you've ever seen a URL (`http://ben.stolovitz.com/this/is/not/real.txt`) or navigated your file system. We presented two ways to represent these paths, these locations of files and folders on your computer: **absolute** and **relative**.

You can probably intuit that a path is a series of folders separated in some way. In linux, this is by a forward slash (`/`). On Windows, it is usually a backslash (`\`). The path `Documents/johnnykaratesongs.txt`, therefore, indicates that the `jonnykaratesongs.txt` file is in the `Documents/` folder (where I wrote the trailing `/` to indicate that `Documents` is, in fact, a folder).

This is a **relative** path, because it assumes you know the location of the `Documents/` folder. To avoid the chicken-and-egg problem (isn't *everything* relative?), a *relative* path relative to a certain **root directory**, the base directory of the file system, is considered an **absolute path**. This is typically represented as a simple slash: `/`.

Then, the path `/Users/dwyera/Documents/johnnykaratesongs.txt` might be the absolute path for the same file mentioned above. Since `~` represents the absolute path to your home directory, any path that begins with one is also an absolute path: `~/Documents/jonnykaratesongs.txt`, if your home directory is `/Users/dwyera/`.
</aside>

Create a new directory, then browse to it!

1. `mkdir DIRECTORYNAME` with whatever directory name you want.
2. `cd DIRECTORYNAME` to browse into the new directory. 
3. Is there anything in your new directory? Remember this answer for your cover sheet.
4. Make another directory within this new one, then see if you can browse back to your home directory (`cd ..` goes up a directory, and `cd ABSOLUTEPATH` will move to some absolute path).
5. What's the absolute path of your new directory? What's the *relative* path, relative to your home directory? Write these in your coversheet.

## File creation & modification

It's really easy to make files in command line.

### Leave a message

<aside class="sidenote">
#### STDOUT?!
{:.no_toc}

`STDOUT`, or Standard Output, is a **stream** of data that your terminal automatically provides. By default, commands you run in terminal send their output to this standard output, which your terminal then prints to the window (so you see the output).

We will talk about streams in much more detail throughout the semester, but you can think of them of as a black box that programs can send data to and receive data from. They are very similar to files. In fact, they are so similar that Linux treats *files* and *streams* the same (standard output is actually a file in your hidden `/dev/` directory). Think of it from the program's perspective: both are places to send data to, and the program has no idea what is going to happen to the data in the future, or where it even exists. It could be on a USB drive, on your hard disk, or [nothing at all](http://www.freeos.com/guides/lsst/ch04sec1.html).

It then makes sense that the terminal provides you a way of outputting data to other streams in lieu of the standard output.

</aside>

1. Go to the second directory you created, using `cd`.
2. Use `touch README.txt` to create a new file called `README.txt`.
3. If you use `cat README.txt` to print out the content of `README.txt`, you will see no output. `README.txt` is empty.
4. Let's fix this. `echo 'text'` will print `text` to `STDOUT`, your terminal's  default output. You can redirect content from `STDOUT` to a file by following a command with `> FILENAME`. Use this **output redirection** to leave a helpful message in `README.txt`. This will replace anything that currently exists in `README.txt`.
5. Make sure your message got written by using `cat` to print out the content of `README.txt`

Let's duplicate our data because no one actually reads `README`s. To do this, we will use the `cp` (copy) command.

<aside class="sidenote">
#### `man` oh `man`
{:.no_toc}

The `man` command provides documentation for all commands that bothered writing any.

The information you need is usually on the first page. The `Synopsis` shows the different ways a command may be used, with several optional flags wrapped in square brackets `[]`, and required arguments at the end. The `Description` explains what the different arguments mean.
</aside>

1. Use `man COMMANDNAME` to learn how `cp` works. You don't need any arguments with dashes, and you should be able to figure it out on the first page. 

	If you need to move around (you don't), `j` and `k` browse up and down the help 
	file, and `q` will return to terminal.

2. Copy `README.txt` to `PLEASE_README.txt`.
3. Are they the same? Verify using `cat`.
4. Append some text (`>>` instead of `>`) saying that people should read the real `README.txt` next time.

### Pass the data along.

I want to show you how to pass content from one program to another.

1. `history` shows a list of all your most recent commands. Try it now!
2. You can **pipe** output from one command into another command as its input, similar to how you can redirect the final output into a file.

	For example, say I wanted to find all the times I used the `man` command. I could redirect the output of `history` to a file, as you just did, and then run `grep` (a search command) through that file, but you can skip the middleman by *piping* the data from `history` to `grep`.

	`grep 'man'` searches the provided input (which is by default another stream, `STDIN`, that we haven't talked about) for the word `man`, so `history | grep 'man'` searches your history for the word `man`. This sends the output of `history` as input to `grep`. Now `STDOUT` only shows lines that have `man` in them: lines where you used the manual command.

3. How many times did you use the `man` command today? Use `wc` (and the manual entry for it) to count the number of lines that `grep` returns. You will need to pipe twice, once to `grep`, and once to `wc`. You should do this in the same line. Write the number you get in your `cover_page.txt`.

### Get a coversheet

1. Use `curl` to download the cover page for this assignment (`https://wustl.box.com/shared/static/eus29j0ca0hpqjonj7csvn15o1x5qa9w.txt`). Look up the documentation using `man`. 

	This time, you will have to use the `-L` argument. The `-L` argument (case-sensitive) tells `curl` to follow redirects. We must do this because WUSTL Box redirects several times.
2. Save it to a file `cover-page.txt` in the first directory you created (the parent directory), using output redirection or the `-o` argument.

### Mark it up

File editing in Linux is really hard. Like, it sucks until you get good.

There are a couple editors, and all of them are weird. Choose one for this next bit. I like `emacs`, but I also think it's cool that `man 7 ascii` gives you a list of the ASCII characters and spend my free time reading the Stack Overflow newsletter, so take it with a grain of salt (ed— this file has been edited several times and each time the recommended editor has changed. Also, the correct program is `vi`).

For the sake of time, we recommend you use `nano`.

1. Read the guide to your new favorite text editor (`nano`) on the [330 wiki](http://classes.engineering.wustl.edu/cse330/index.php/Linux#File_Editors).
  	
2. Answer all questions you can in the `cover-page.txt`. You can edit a specific file by passing the filename as the argument when you open your editor, so `nano cover-page.txt`, for example.

## Source Control

<aside class="sidenote">
### Source Control for the Skeptical
{:.no_toc}

You may have used SVN last semester in CSE131, or you may have heard the various dire warnings of programmers past imploring you to please use SVN or some other source control, like git or Mercurial.

**Source control** is a file versioning system, extremely useful for content creators (like you!). Unlike *passive* file revisioning, which might create backups of your work every couple of minutes, source control is *active*. It saves versions of your work whenever you tell it to. Along with a *message*, you **commit** your changes to some remote **repository** that holds all of them and lets you see the history of your work.

In my experience, you cannot convince anyone to use source control until 3am the day before the final project is due, when "I swear it was working yesterday" but they commented out a critical section and can't find it again.

If you wish to avoid that scenario, learn these steps well. Commit early, commit often.
</aside>

Time to get your stuff up on the internet.

### Checkout the code

You need to checkout your code into a local copy so you can make edits.

1. In your home directory, create a directory to hold your SVN repos. I called mine `svn/` because I'm creative.
2. Browse into that directory, and then type `svn checkout https://svn.seas.wustl.edu/repositories/WUSTLUSERNAME/cse132_sp16/`. You will need to add an additional `--username WUSTLUSERNAME` argument if you did not SSH with that username.
3. Enter your WUSTL password when prompted. Do **not** save it unencrypted. That would be bad. The letters won't appear, as always.
4. `cd` to the new SVN directory. It should have an `Arduino/` folder and some files prefixed with `.`.

### Move your code to a new home

It's time to move the directories you created earlier into your repo.

1. Make a new directory next to `arduino/` and `java/` called `shell/`.
2. Figure out the `mv` command and move the directories you created earlier into that `shell/` directory. Again, you need no special arguments to do this.

### Sputnik Niner-Niner, what's your status?

1. Within the local copy of your SVN repo, type `svn status` to see the status of your local copy. You should see your `shell/` directory with a question mark before it. 

	If you committed now, you would not push your new directory to the server. You need to tell SVN to track that new directory.
2. `svn add shell` to track that new directory.
3. `svn status` should now show all the files in the `shell/` directory, with `A`'s next to them.

### Get it online!

1. `svn commit -m "YOUR MESSAGE HERE"`
2. Make sure your code got pushed by going to your repository in a browser[^everytim]. The address is: `https://svn.seas.wustl.edu/repositories/WUSTLKEY/cse132_sp16`

	You should have a `shell/` directory with:
	
	<section class="tree">
	
    - a subdirectory
	    - `README.txt`
	    - `PLEASE_README.txt`
    - `cover-page.txt`
    </section>
 
3. Use `svn log` to list the commit messages to your repo.	
	Some of my recent commits: 
	
	- "autograder is salty"
	- "i guess there's a typo?"
	- "spaces always getcha"
	- "Now with real non-hacky things"
	
	 Unless you took a computer science class last semester, you will probably only see the commit message you just wrote and the ones we used to set up your repo.

	 But we read them when we grade! Commit messages can be very expressive and help us grade. *And* they can aid us in recovering your code if everything blows up.

	 And that happens to at least one group every year.
4. Press `^D` (`Control-D`)[^commands] on your keyboard a couple times to end your SSH sessions: once to leave `qlogin`, and again to leave `shell.cec.wustl.edu`. You are now logged out of those remote computers, which is nice on WUSTL IT.

[^commands]: `^D` is one of many commands that send *signals* to your terminal. `^D` sends `EOF`, or "end of file" (your input is a file, or a stream, sent to the shell). `^C` sends `INT`---`interrupt`---and asks the currently running program to exit. There are a bunch, and you can learn 'em in [CSE361s](http://classes.cec.wustl.edu/~cse361s/web/).

Anyway, once that's done, you're ready to get checked out. Congratulations! You know bare-bones command line! If this piqued your interest at all, you might want to check out some more in-depth aspects of the command line. You can read about [the Linux file system](http://www.freeos.com/guides/lsst/appa.html#whatisfile), [a general primer to command line that brags about including XKCD comics](http://clusters.engineering.wustl.edu/guide/), or take a look at [the TVTropes of programming, C2](http://c2.com/cgi/wiki?CommandLine). 

Any and all reading you do will be of tangible benefit to you later in this semester. Shell is pretty much a self-starter thing, and reading is the only way to learn. I will also say this: I have yet to meet someone who understands command line and has trouble programming.

[^everytim]: You should ensure you committed properly *every time* you submit code this year. Every time! I can tell you from experience that the one time you don't check will be the one time you didn't commit properly.
