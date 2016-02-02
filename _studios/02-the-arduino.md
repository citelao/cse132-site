---
title: Introduction to Arduino
author: Ben Stolovitz
week: 2
assigned: 2016-02-01
due: 2016-02-01
---

## Introduction to Arduino

* This will be a TOC
{:toc}

The Arduino is a (very) small computer that has dramatically fewer capabilities than the desktop or laptop machines that you have used in the past to run Java programs. For example, it doesn't have a keyboard, it doesn't have a screen, its processor is well over 100 times slower, and you might even be wondering, "what is the point?" The point is that small computers like the Arduino are priced relative to their capabilities. Want a computer for under \\$10? If so, the Arduino is a great choice! Its small size makes it incredibly useful for lots of jobs where it would seem overkill to use a $1500 laptop. Over the course of the semester, we'll discover all that the Arduino can do, even though it starts out as humbly as it does.

### Programming the Arduino

Although the Arduino itself is a computer separate from your laptop or desktop, its lack of screen serves as an impediment to programming it directly. We write and compile programs for it on a larger computer and then send them over to the Arduino via USB. The Arduino, as you'll soon see, runs one program at a time, for as long as it's plugged in.

As you might imagine, the transfer process is very complex, and until the Arduino came out in 2005, microprocessor programming was a [long and arduous task](http://www.atmel.com/images/doc0943.pdf). Luckily for us, we are past those dark ages of computing and we have the **Arduino IDE** (Integrated Development Environment). You may be familiar with the *Eclipse* IDE, which we use in CSE 131 to write and compile Java programs. The *Arduino* IDE helps you write and compile Arduino programs and also manages uploading those programs to your Arduino board.

Arduino programs, however, are not written in Java. They are written in a variant of C, one with extra libraries specifically for writing Arduino programs. Since you have already been introduced to C, programming the Arduino should be a snap.

### Today's studio

Today you will get accustomed to the basics of Arduino C by writing a simple "heartbeat" program and uploading it to your Arduino board.

Then you will write an identical program in Java and compare the two programs to understand the differences between the two systems.

#### Objectives

By the end of studio, you should know:

- how to **structure a basic Arduino program**,
- how to **use the [Arduino reference guide][arduinoref]**, 
- how to **communicate with your Arduino**, and
- how to **use Arduino digital output pins**.

[arduinoref]: https://www.arduino.cc/en/Reference/HomePage

Onward!

## Setting up Arduino

<aside class="warning">
If you wish to use your own laptop for development, you'll find the Arduino IDE [on the official site](https://www.arduino.cc/en/Main/Software), for Windows, Linux, and Mac.

This software is already installed on the lab machines, so if you have *any* trouble with the installation process, finish the studio exercises on the lab computers, and *then* ask for help with the installation.
This is especially true if you are using one of the RedBoard Arduino's (manufactured by Sparkfun), as they need a different driver.

Do the studio today. Install the software later.
</aside>

### Getting ready

Like last week, you need to check out your repository so that you can commit the changes you make today. You may also need to tweak Arduino's preferences to make it easier to use.

<aside class="sidenote">
#### Adjust the fonts and add the lines

Taking a couple moments now to change the font size might save you hours of squinting.

##### Eclipse

1. Open the `Preferences` window (`Window>Preferences` for Windows, `Eclipse>Preferences` on Mac)
2. In the search field (`type filter text`), type `colors and fonts` and select the similarly-named result.
3. Change `Basic>Text Font` to a nice font.
4. Make sure `Java>Java Editor Text Font` is set to default (it will say so).
5. Click `OK`. 

##### Arduino

1. Open the `Preferences` window (`File>Preferences...`; `Arduino>Preferences...` on Mac)
2. Change `Editor font size` to something reasonable. Like 18.
3. Check `Display line numbers`.
4. Click `OK` and restart the Arduino IDE.

</aside>

1. Organize around one computer, using the large screens on the walls to make things easier if you need.
2.	Open Eclipse.

	Make sure to note where your **Eclipse workspace** is located. You will need it.
	
	If you don't know, `File>Switch Workplace>Other...` will show you. Press `Cancel` if you don't want to change it.
3. Make the font size bigger if necessary.
4.	Check out your repository.
	
	We will be using Eclipse for this, but it really is the same operation we did earlier using the command line.  The primary difference is that the local copy gets put in your Eclipse workspace.
		
	You *must* have **Subversive** installed to do this step. It is a moderately confusing process, so keep in mind that the lab computers already have it installed if you have any trouble.
	
	1. In Eclipse, open the `SVN Repository Exploring` perspective (`Window>Open Perspective>Other...>SVN Repository Exploring`).
	2. In the `SVN Repositories` pane on the left of the Eclipse window, right click and select `New>Repository Location...`.
	3. The `URL` is `https://svn.seas.wustl.edu/repositories/YYYY/cse132_sp16`, where `YYYY` is your WUSTL key, in lower case letters.
		
		Here are some sample WUSTL keys followed by their corresponding `YYYY`:
		
		- RonKCytron &rarr; ronkcytron
		- ima.StudeNt &rarr; ima.student
		- Queen.Mary.4 &rarr; queen.mary.4
	4. Press `OK` and you will be prompted for a username and password. Enter the same username you used as your `YYYY` above and your WUSTL password.
	5. You have now added the *remote* location to Eclipse's byzantine internals. Now you have to check out a *local* copy of your code, so that you may work on it.
		
		You should see the URL you entered in the `SVN Repositories` pane now. If you expand it by clicking the triangle next to its name, you will see at least these two directories: `Arduino/` and `java/` (most likely you will see `shell/` and `c/` as well, but we can ignore these today). Right click on your URL and select `Check Out`.
	6. With that complete, switch back to the `Java Browsing` perspective (in the same way you switched perspectives before). You should see the folder you checked out in the `Package Explorer` on the left of your Eclipse window.
	
	 	If you right click, `Show In>System Explorer`, your file browser will open and show the actual files you've checked out. Congratulations, you now have a local working copy of your repo. You can edit it and commit your changes, just like you did in command line, but you can use Eclipse to do it now[^alternatives].
	 	
5. Find the file `helloworld.ino`, located in the `Arduino/studio2/helloworld` folder of your repository. Open it in the Arduino IDE.
6. Make sure your Arduino files save to your repository automatically by changing your **Sketchbook location**.

	In the Arduino Preferences window (`File>Preferences...`[^arduinomac]), change the `Sketchbook location` to your Arduino repository folder.
	
	This makes the Arduino IDE put new files in your repository working copy by default, so you can easily commit them to the server when you're done working.
7. Restart the Arduino IDE and reopen `helloworld.ino`.

[^alternatives]: If you dislike the Eclipse experience, there are several other ways to check out and commit your code. 

	On Mac and Linux, you can very easily use the command line. The thing to watch out for in this case is to ensure the local copy of the repository goes into your Eclipse workspace.  If not, you will have trouble with Java.

	On Windows, I've heard a lot about [TortoiseSVN](https://tortoisesvn.net), which integrates with System Explorer, so you can right-click on SVN files and commit them from there.

	Any other SVN app will also work. But none are necessary: Eclipse will do the trick.

[^arduinomac]: `Arduino>Preferences...` on Mac.

### Running a program

The `helloworld.ino` file is a complete Arduino program. Compiling and uploading it should help you learn the Arduino interface.

<aside class="sidenote">
#### Problems uploading?

Considering that you are compiling a program from C, using an old USB driver designed by one company to communicate with a board designed by another company running code designed by a third, it's surprising that Arduino upload works as often as it does.

But stuff goes wrong. A lot. Here's how to troubleshoot your upload.

- **Is your code free of syntax errors?** Make sure that your code is correct (**Verify** it and make sure the status is `Done compiling.`)
- **Are you writing to the correct port?** Look under `Tools>Port>` and select a different one. On Windows it will be something like `COM3`. On Mac, it will be something like `/dev/cu.usbmodem1492`. There's no good way to find the correct one aside from guess-and-check.
- **Restart the Arduino IDE and plug everything in again**. It works a lot of the time.
</aside>

![An annotated screenshot of the Arduino IDE](../img/arduino.png)

1. Click the **Upload** button to *compile* `helloworld` and *upload* it to the Arduino (the **Verify** button just compiles your program, looking for errors in the code).
2.	Make sure the code uploaded correctly (the **status message** should say `Done uploading.`).
3. Open the **Serial Monitor** to view the output that our newly programmed Arduino writes to its *serial port*. You should see the phrase `Hello, world!`.
4. Press the **reset button** on your Arduino. The Serial Monitor should  display the phrase `Hello, world!` again.
5. The Arduino has two **entry points** into your code, or, in other words, two places it looks to run your code. Whenever the Arduino starts up or is reset, the Arduino runs the `void setup()` function once. After that, the Arduino runs the `void loop()` function over and over until the Arduino is unplugged or reset.

	Opening serial monitor or pushing the reset button on the Arduino both reset the Arduino.
	
	Note that opening the serial monitor will sometimes print garbage data as the signals between the Arduino and computer sync up.

## Timing in Arduino

Now you'll write your own Arduino program in C.

1. Take a quick look at the [Arduino reference][arduinoref]. It should be surprisingly similar to Java. 

	Pay special attention to the `Serial` library (under *Communication* in the *Functions* section on the far right of the reference) and the `delay()` function.
2. Author a program called `heartbeat` in the `studio2` folder (so the `heartbeat.ino` file should be in `Arduino/studio2/heartbeat/`) that, once per second, prints:

		<n> sec have elapsed
		
	where `<n>` is the number of seconds that have passed since the program was reset. The `delay()` function will come in handy, as will `Serial.print()` and `Serial.println()`.
		
	You will need to start basically from scratch and add the files to your repository manually, but you can use some [starter code](../src/heartbeat).
	
	 Note that C strings work differently than Java strings (namely `string  + string` does not exist in C, and Arduino C does not support `printf()`), so you'll need to work around that. The [Arduino reference page on strings](https://www.arduino.cc/en/Reference/String) explains the C implementation in more detail. 
4. Verify that your newly authored program is functioning at least approximately correctly.

## Digital output in Arduino

The program you just wrote could easily be a Java program on your laptop (as it will soon be), and does not show off the power of the Arduino. We'll add a flashing light to show off the critical feature of the Arduino: it can interface with everyday electrical circuits.

1. You probably noticed the numbered holes on each side of the Arduino. We call these **pins**. The Arduino code you create can read and write electrical signals from these pins: they can turn on and off lights (as we will do today), read whether or not a button is pressed, or determine how far a knob is turned, as long as you wire up the correct circuit.

	Circuits are hard, so we will use *pin 13*  because it is already attached to an LED on the Arduino body itself, and so requires no wiring on your part. Later, we will walk through attaching your own LED to pin 13. This code will power it just the same.
2. In your `setup()` function, ensure pin 13 is ready to write by setting its `pinMode()` to `OUTPUT`. Look at the Arduino reference for `pinMode()` to learn how.
3. Modify your `loop()` to blink the LED every second, just before it `Serial.print()`s. You will need to divide your loop into *two* `delay()`s---one where the LED is on, and one where the LED is off.

	You can turn the LED on and off by turning on and off the pin it's attached to. In computer science terms, you **write `HIGH` or `LOW` to the pin**. The aptly named `digitalWrite()` function will help you do this.
4. Make sure your program still beats approximately once a second.

## Timing in Java

Now write the earlier timing program in Java.

<aside class="sidenote">
### A package deal

Java is completely centered around classes. In Java, almost everything you use is a class of some sort. Java's Marxist equivalent is C, which has no concept of a "class." C++ adds classes to the C language (hence the name, which basically means "C, incremented").

With any large codebase, you begin to run into problems when you try naming things (is my `Character` a single letter of text, or is it my favorite person in a television show?). Whereas C generally ignores the issue (people describe C as a hammer that makes every problem look like your thumb), Java and C++ both introduce the concept of **namespaces**, where you can group classes into named spaces called **packages** (Java) or **namespaces** (C++).

In general, Java packages look like a reversed domain name: `com.stolovitz.math` (which might hold Math classes for quadratics or complex numbers) or `edu.wustl.cse.users` (which might hold classes for user manipulation and management). All builtin Java classes (of which there are over 4000) are in subpackages of the `java` or `javax` package. A `Character` might therefore be found in the `java.lang` or `com.stolovitz.movies` package. The compiler maintains a list of all available packages when it is run, and the `import` statements at the beginning of every Java class file tell the compiler which classes to use from which packages.

It is good practice to structure your directory structure identically to the package name, so my `com.stolovitz.movies.Character` class (the full class name includes the package name) would be in the `com/stolovitz/movies/` directory. Java compilers get confused if the package name and directory structures differ.

Luckily, creating classes and packages in Eclipse *automatically* creates the required directories, so you don't need to worry about that. Just make sure to create classes through Eclipse so the package is set correctly.
</aside>

1. Create a new package in your Java repository called `studio2`. You can do this by right-clicking your Java repository in Eclipse and clicking `New>Package`. Notice that this creates a folder `studio2/` in your Java repository.
2. Create a new class `Heartbeat` in the `studio2` package. Make sure you include a `public static void main(String[] args)` method so that your new class can be a standalone Java program. You can do this within the **New Java Class** wizard.
3. Your `Heartbeat` program should print a message to console once per second. Use `Thread.sleep()` to measure the passage of time, as described in class. Remember that `Thread.sleep()` can throw an exception, and you should use `try {} catch() {}` blocks to catch any exceptions.
4. Verify the program works reasonably.

## Comparison

Now compare how good your Arduino is at keeping time compared to your desktop or laptop.

1. Start up both programs and observe how long it takes to start drifting in time relative to one another. Make note of this to tell your TA during checkout.
2. Add some code to your Arduino program that displays the return value from the `millis()` function. How many milliseconds should elapse every iteration? What do you actually see? What does this imply about the reliability of timing using `delay()`?

## Finishing up

Check out and get out.

1. Make sure to *commit* your workspace

	In Eclipse's package explorer, any files you have modified since your last commit are prefixed with a `>`.
	
	Right-click the outer-most folder (you want to commit *everything* within), and choose `Team>Commit...`. Write a helpful message and press `OK`.
	
	You can verify that your changes went to the server by opening the repository URL in any web browser. Log in with the same WUSTL key `YYYY` and password as before, and you can now browse the files to make sure your changes committed.
2. Show your two timing programs and your repository to a TA.
3. Tell your TA how long it took for your Arduino and computer to get out of sync.

Repository structure for this lab:

<section class="tree">

- `Arduino/`
	- `studio2/`
		- `helloworld/`
			- `helloworld.ino`
		- `heartbeat/`
			- `heartbeat.ino`
- `java/`
	- `studio2/`
		- `Heartbeat.java`
</section>
