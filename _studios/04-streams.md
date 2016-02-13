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

2. Next, you need to alter the build path for Java.  Right click on the
project name (i.e., your repository checkout), go down to Properties and pick
Java Build Path.  Then click libraries and add the `RXTXcomm.jar` file as
a library (using the `Add Jars ...` button on the right).

3. Once the jar file is listed as a library, expand it and double click
on "Native library location", indicating the `jars/` directory in the
workspace.  Note: during this last step, the `rxtxSerial.dll` and
`librxtxSerial.jnilib` files will not be visible during the selection.
You are selecting the directory that contains them.  FYI: `rxtxSerial.dll`
is the native library for Windows and `librxtxSerial.jnilib` is the native
library for the Mac.

4. The `SerialComm` and `PrintStreamPanel` class files
(found in `java/studio4`) enable
`InputStream` and `OutputStream` access to the serial port
and provide additional GUI support for diagnostic printing, respectively.
You will use them both to accomplish the tasks below.

## Authoring Java tools

1. The first task is to have a Java program receive data sent by the Arduino.
We will start simple.

	In `java/studio4`, create a new Class (called `SerialTest`) that will
(in its `main()` method) print to the console bytes that it receives from
the serial port.
You will need to instantiate a new `SerialComm` class, and invoke its
`connect()` method, which takes a string argument indicating which
serial port.  Note (in the code
for the `SerialComm` class) where to set the baud rate (feel free to leave
it at the current 9600 baud).
Example code for guidance is provided in the `main()` method of `SerialComm`.

	The `read()` method from the `InputStream` object (use `getInputStream()` to
get it) is appropriate for reading the received data.
Prior to invoking `read()`, you probably want to test the results returned
by `available()` to see if input characters are currently ready to be read.

	Each byte can be
assumed to be a character, so the return value from `read()` can either be
assigned to an instance variable (or local variable) of type `char` or
appended to a `String` object (in the latter case, terminating the `String`
and starting a new one when a `\r` character (`0x0d`) is received.

	Using any of your previous Arduino sketches that send data to the PC (e.g,.
`heartbeat` might be a good choice), exercise your Java program and ensure
that you get the same text output on the Java console that you previously
were getting when using the Serial Monitor built into the Arduino IDE.

	Experiment by starting the Java program first, then the Arduino.
You can do this by downloading the Arduino program, running it and testing
via the Serial Monitor, closing the Serial Monitor, and pulling the
plug on the USB cable to the Arduino.  Start up the Java program, then
plug in the Arduino, which will cause it to start again (the sketch is
retained in memory that is not lost when the power is removed).

	After you've tried that, change the startup order.  What happens when?  Why?

2. The second task is to build a tool (that operates on `InputStream`s) that
will be used to provide visibility (observability) into the stream.
The new class is called `ViewInputStream`, and it extends the pre-exising
library `FilterInputStream` class. In our case, the "filter" function
is a display operation.

	Your `ViewInputStream`'s `read()` method should `super.read()` from the
parent `FilterInputStream`, display the byte that has just been read in
ASCII hex form (using the provided `PrintStreamPanel` class),
and return the unaltered byte as its return value.
In other words, this class displays bytes being received through the
input stream, but does not alter them.

	ASCII hex form means that for every byte that goes through the stream, the
output should be 3 characters: a space character and 2 characters that
represent the data byte in hexadecimal (e.g., if the byte in the data
stream is `0x5f`, the string sent to the `PrintStreamPanel` should be
"` 5f`" (or "` 5F`" if you prefer).

	As described in lecture, wrap your `InputStream` in a `BufferedInputStream`.
Wrap the `BufferedInputStream` in your newly created `ViewInputStream`.
Repeat task 1 above now using your `ViewInputStream`'s `read()` method
rather than your original `InputStream`'s `read()` method.
	
3. Show off your working code to an instructor or TA.

## Optional additional stuff

If you are this far by the end of studio time, consider this studio
a success and jump ahead to Finishing up.  If you have time, there are
some additional things you can play with that will also be useful
in the upcoming assignments.

1. All of the data we've been transmitting so far has been ASCII characters.
Let's investigate how to send larger (more than one byte) data types.
An integer (type `int`) in Arduino C is a two-byte type.  Alter your
Arduino sketch (save the altered version in `Arduino/studio4/datatypetest`) 
to periodically send a single integer.  Send the high byte (most signficant
byte) first and the low byte (least signficant byte) second.

	Alter `SerialTest` to combine the two received bytes and store the result
in a Java integer.  (Remember, Java's integers are 4 bytes, so there is
plenty of space for a two byte number to fit.)

	Output the received integers on the console, and compare that with what you see from `ViewInputStream`.

2. Now wrap your `ViewInputStream` with a `DataInputStream` and read the
incoming two byte values using `readShort()`.
How does this compare with the results above?

3. Extend the Arduino C code to send a `long int` (the return value from
`millis()` would be a good choice).  On the Java side, read that using
your `DataInputStream`s `readInt()` method.  How well does that work?

4. Try it again with an Arduino C `float` and `readFloat()` on the Java side.

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
		- `SerialTest.java`
		- `ViewInputStream.java`
</section>
