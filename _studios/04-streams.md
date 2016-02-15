---
title: Streaming Data from Arduino to Java
author: Roger Chamberlain
week: 4
assigned: 2016-02-15
due: 2016-02-15
---

## Introduction

* this will be a TOC 
{:toc}

Up to this point, everything we have sent from the Arduino to the desktop
PC has been displayed on the PC screen using the Serial Monitor built into
the Arduino IDE.  No more!  We can receive data sent from the Arduino in
a Java program as well, and that is the topic of today's studio.

### Objectives

By the end of this studio, you should know:

- how to receive data from a serial port in a Java program, and
- (optionally) how to send and receive data types that are larger than a single byte.

## Enabling Java communications

The first step is setting up the necessary Java libraries.

1. The following files have been made available in the `jars/` directory of your
repositories: `RXTXcomm.jar`, `rxtxSerial.dll`, and `librxtxSerial.jnilib`.
Also, `SerialComm.java` and `PrintStreamPanel.java` have been provided in
the `java/studio4/` directory.

	If you don't see them, you need to perform a repository update.

2. Next, you need to alter the **build path** for Java.  Right-click on the
project name (i.e., your repository checkout), go down to `Properties` and select
`Java Build Path`.  Then click `Libraries` and add the `RXTXcomm.jar` file as
a library (using the `Add Jars...` button on the right).

	This adds a new `.jar` file to our compiler's **build path**, a list of directories and `.jar` files (which are just zipped folders) that the compiler uses to find the classes in your program. This week's prebuilt `SerialComm` class depends on the classes in `RXTXcomm.jar`, so including it lets us use them.

3. Once the `.jar` file is listed as a library, expand it and choose a **native library location**, selecting the `jars/` directory in the
workspace. 

	This location is a directory where Java can find **native code** for working with OS-dependent hardware. Since Arduinos use serial ports on your computer, we need OS-dependent (and thus non-Java) code to communicate with them. This code is in `rxtxSerial.dll` (for Windows) and `librxtxSerial.jnilib` (for Mac). The compiler is smart enough to use the right one.
4. The `SerialComm` and `PrintStreamPanel` class files
(found in `java/studio4`) make it easy to use Java's streams (`InputStream` and `OutputStream`) to communicate with serial ports on your computer
and provide additional GUI support for diagnostic printing, respectively.
You will use them both to accomplish the tasks below.

## Authoring Java tools

### Simple printing

<aside class="sidenote">
#### Startup debugging
{:.no_toc}

You can only have one open connection to your Arduino at any given time, be it
uploading new code, Serial Monitor, or a custom Java app.

So make sure to close all your Java programs after running them.

1. Click the red square on the side of the Java `Console` to stop the program.
2. Click the `x` next to it to clear that program's output and show any other running programs (if there are)
3. Repeat for all open programs.

Also close Serial Monitor when you are not using it.
</aside>

The first task is to have a Java program receive data sent by the Arduino.
We will start simple.

1. In `java/studio4`, create a new Class (called `SerialTestInput`) to hold our program.

	Make sure to give it a `static void main()` method. This is where your Java program will start.
2. This program will receive data from a serial port (your Arduino) and print it out. In order to do that, you will need to use the `SerialComm` class---that we provide---and connect to the correct port.

	Create a `new` instance of `SerialComm` (`import`ing it as needed), and invoke its `connect()` method to connect to the Arduino. This method takes a `String` argument with the name of the port (identical to the port name from the Arduino IDE). If you do not provide the correct one, it prints an error with a list of potential ports.

	The `connect()` method might `throw` an `Exception`. For example, the port you provide could not exist, or your drivers could be set improperly. When code you write calls other code that might do this, you have two options: pass the exception up for someone else to deal with (by specifying that your function `throws` an exception sometimes: `boolean connect(String portName) throws Exception`, or handle it yourself. Since we are in the `main()` function of your code, there's no one to pass the buck to. You must deal with the exception yourself using a [`try`-`catch` block](https://docs.oracle.com/javase/tutorial/essential/exceptions/catch.html). Eclipse will help you write one.

	Example code for guidance is provided in the `main()` method of `SerialComm` itself.

	Note the code in the `SerialComm` class that sets the **baud rate** (feel free to leave it at the current `9600` baud), the rate at which your serial expects data from your Arduino.
3. 
	<aside class="sidenote">
	### A bit of the abstract
	{:.no_toc}

	The [`InputStream`](https://docs.oracle.com/javase/8/docs/api/java/io/InputStream.html) class is an **abstract** class that merely defines a list of methods and variables that all input streams have. You cannot create an instance of an abstract class because these methods do not have **definitions**. Every object you use that you call an `InputStream` is actually one of its subclasses.

	For example, you can write a `Shape` abstract class that defines methods like `area()` common to all shapes. Then your concrete implementations like `Triangle` and `Square` can write their own `area()` methods. If you have an array of `Shape`s, then, no matter what actual type they are, you can always call `area()` on them. Even though none of the objects in the array are purely `Shape`s---they are actually instances of one of the concrete subclasses---they have this identical function. Thus they can be stored in lists together and treated identically.

	In `InputStream`'s case, which you can see in [it's documentation](https://docs.oracle.com/javase/8/docs/api/java/io/InputStream.html), Java declares that all descendants must have (among other things) an `available()` method and a `read()` method, so you know that any `InputStream` descendant can do both of these things. Likewise, `FilterInputStream` provides a variable called `in`, which is the source `InputStream` that the `FilterInputStream` actually filters *on*.

	</aside>

	Once you have properly connected to a serial port, you can now call the `getInputStream()` method on your instance of `SerialComm` to (as you might expect) get the `InputStream` corresponding to this serial port---the stream of input *into* your Java program *from* your Arduino.

	An `InputStream` is an **abstract** class, part of the over 4200 classes in the Java API. Designed to handle **streams** of data, it provides a [`read()`](https://docs.oracle.com/javase/8/docs/api/java/io/InputStream.html#read--) method to get the latest byte from the stream (destructively, as calling it once will remove that byte from the queue of data) and an [`available()`](https://docs.oracle.com/javase/8/docs/api/java/io/InputStream.html#available--) method that returns the number of bytes that are queued to be read.

	Get this `InputStream` from your `SerialComm` class. Decide upon a way to continuously check if any bytes are `available()` and `read()` them if there are. Have your program [*infinitely*](http://stackoverflow.com/questions/15989618/java-infinite-loop-convention) do this.
4. Now, take the data you read and find a way to print it to the Java console. Note the return type of [`read()`](https://docs.oracle.com/javase/8/docs/api/java/io/InputStream.html#read--). Though in our case it *represents* a `char`, it is not. This is a [design choice](http://stackoverflow.com/a/4659801/788168). You will have to cast it to print it properly.

	Using any of your previous Arduino sketches that send data to the PC (e.g,.
`heartbeat` might be a good choice), exercise your Java program and ensure
that you get the same text output on the Java console that you previously
were getting when using the Serial Monitor built into the Arduino IDE.

5. Experiment by starting the Java program first, then the Arduino.
You can do this by downloading the Arduino program, running it and testing
via the Serial Monitor, closing the Serial Monitor, and pulling the
plug on the USB cable to the Arduino.  Start up the Java program, then
plug in the Arduino, which will cause it to start again (the sketch is
retained in memory that is not lost when the power is removed).

	After you've tried that, change the startup order.  What happens when?  Why?


### A GUI alternative

<aside class="sidenote">
#### `Super`, man
{:.no_toc}

Java is very aware of the class hierarchy, and it's often useful to use functions provided by a parent class. In our case, we want to access the `in` variable that `FilterInputStream` provides, and Java lets us do that with the variable `super`.

Like `this`, which represents the current instance, `super` is automatically present in any object's methods. You can access most parts of your parent classes with the `super` variable, like `super.in` in our `ViewInputStream`.

#### Access control
{:.no_toc}

You might consider this dangerous: child classes able to access any part of their parent classes?

Java provides **access control** to make sure you only expose the right parts of your program to other parts.

- `public` makes a method or variable available to any other part of your program (the `read()` method is an example of this: `in.read()` can be called anywhere in your program). `public` variables can also be modified by any other part of your code: 
- `protected` makes the methods or variable only available to *child* classes and the current instance. This is what the `InputStream in` variable of `FilterInputStream` is.
- `private`: only the current instance can access this variable. Useful for things you don't want other parts of the program to see, like a person's `favoriteDinosaur`

</aside>

Now we will build a class that we can plug onto any `InputStream` that creates a **GUI** (Graphical User Interface) for debugging the stream, separate from Java's console output.

The new class is called `ViewInputStream`, and it extends the pre-existing
library [`FilterInputStream`](https://docs.oracle.com/javase/8/docs/api/java/io/FilterInputStream.html) class, which is intended for streams that "filter" data somehow. In our case, the "filtering" function is to display it in a small window.

1. Your mission, and you're required by this writeup to accept it, is to write the `ViewInputStream`'s `read()` method. Use `super.read()` to use the parent class's (`FilterInputStream`'s) `read()` method, convert the `int`/`char` you read into hex, print it (using the provided `PrintStreamPanel` class and its [`PrintStream`](https://docs.oracle.com/javase/7/docs/api/java/io/PrintStream.html), not `System.out`, though they behave similarly), and `return` the unaltered byte.

	In other words, this class displays bytes being received through the
input stream, but does not alter them.

	You need to convert to hex before you print: for every byte that goes through the stream, the output should be 3 characters: a space character and 2 characters that
represent the data byte in hexadecimal (e.g., if the byte in the data
stream is `0x5f`, the string sent to the `PrintStreamPanel` should be
"` 5f`" (or "` 5F`" if you prefer).

2.  Reimplement the program you made earlier (with `SerialComm`) so that it uses this new `ViewInputStream`. As described in lecture, wrap your `InputStream` in a `BufferedInputStream`, and wrap that `BufferedInputStream` in a `ViewInputStream`.

	You should now be able to view the data in hex as it goes through the `ViewInputStream` *and* be able to view the "true" ASCII value in the Java console.
3. Show off your working code to an instructor or TA.

## Optional additional stuff

If you have gotten this far and it's near the end of studio time, consider today
a success and jump ahead to **Finishing up**.  If you have time, there are
some additional things you can play with that will also be useful
in the upcoming assignments.

1. All of the data we've been transmitting so far has been ASCII characters. While it is very possible to communicate entirely using ASCII characters, it is very inefficient. In other words, you *could* convert your `3` to the ASCII character for `3` (`0x33`) and convert it back upon receipt, but that just seems silly. However, that's what happens when you use `Serial.print()`, or, in general, any "print" method: the program converts whatever you want to print *from* it's internal representation *into* a printable representation, like an ASCII character, then sends that to an output stream.

	If you *actually* want to send a `3`, not `0x33`, over a stream, you use `Serial.write()`. From [the documentation for `Serial.write()`](https://www.arduino.cc/en/Serial/Write), it's clear that it can only send one byte at a time: it can only physically send numbers between `0x0` and `0xff`. Anything more than that is truncated: `301` (`0x012d`) is sent as `45` (`0x002d`).

	Make a new Arduino (in `Arduino/studio4/datatypetest`) sketch that first `Serial.write()`s then `Serial.print()`s the numbers `0` through `360` in sequence. What are the results when you use your Java program to view the output? What about Serial Monitor? Use a list of ASCII characters (available on the internet or via the command `man 7 ascii` in terminal) to understand the output if it's confusing, and remember that an Arduino sketch needs to `Serial.begin(9600)` before it can use any of the serial commands.

2. The Arduino is unable to `Serial.write()` numbers larger than `255`. This is a serious limitation for those of you who enjoy counting. 

	Let's investigate how to send larger (more than one byte) data types.
An integer (an `int`) in Arduino C is a two-byte type. By bitshifting appropriately, you can send each byte of this number *sequentially*. For example, you can send the number `0x4d21` as `0x4d` and `0x21`. Alter this Arduino sketch to send the two bytes in this way, first the **most significant byte** (`0x4d` in the example), then the **least significant byte**.

	Alter `SerialTestInput` to combine the two received bytes and store the result
in a Java integer. You will have to bitshift. Remember, Java's integers are 4 bytes, so there is plenty of space for a two byte number to fit[^negative].

	Output the received integers on the console, and compare that with what you see from `ViewInputStream`.

2. Now wrap your `ViewInputStream` with a [`DataInputStream`](https://docs.oracle.com/javase/8/docs/api/java/io/DataInputStream.html), a stream wrapper that provides several functions for reading multi-byte values (basically duplicates of what you did above). Use the `DataInputStream`'s [`readShort()`](https://docs.oracle.com/javase/8/docs/api/java/io/DataInputStream.html#readShort--) method to read the data you send, instead of doing the bitshifting you did before (comment out the code or something to refer to later). How does this compare with the results above?

3. Extend the Arduino C code to send an Arduino `long int` of 4 bytes (the return value from
`millis()` would be a good choice).  On the Java side, read that using
your `DataInputStream`s `readInt()` method (because normal `int`s are 4 bytes in Java).  How well does that work?

4. Try it again with an Arduino C `float` and `readFloat()` on the Java side.

[^negative]: This size difference actually has a large impact when dealing with negative numbers, which, as in all systems, are stored in two's complement. Since a number's negativity is entirely dependent on its first bit, naively sending the Arduino `int` bytes to Java will not correctly send a negative number. 

	The solution is **sign extension**. Bitshifting right in Java (and on signed values in C) automatically copies the highest bit in all the extended places (`0xff >> 8 == 0xfff`, `0x0d >> 8 == 0x00d`). This preserves the value of the number, though that exact proof is left as an excercise for the reader.

## Finish up

1. Commit your code and verify in your web browser that it is all there.
2. Check out with a TA.

Changes to repo structure:

<section class="tree">

- `Arduino/`
	- `studio4/`
		- `datatypetest/datatypetest.ino`
- `jars/`
	- `RXTXcomm.jar`
	- `rxtsSerial.dll`
	- `librxtsSerial.jnilib`
- `java/`
	- `studio4/`
		- `PrintStreamPanel.java`
		- `SerialComm.java`
		- `SerialTestInput.java`
		- `ViewInputStream.java`
</section>
