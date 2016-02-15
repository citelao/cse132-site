---
title: Streaming Data from the PC to the Arduino
author: Roger Chamberlain
week: 5
assigned: 2016-02-22
due: 2016-02-22
---

## Introduction

* this will be a TOC 
{:toc}

After sending data from an Arduino to the PC running Java, this week
we turn things around.  We will send data from the PC to the Arduino,
and display it on an LCD.

### Objectives

By the end of this studio, you should know:

- how to utilize the LCD display in an Arduino sketch,
- how to receive data from the serial port in an Arduino sketch,
- a bit about how to work with strings in C, and
- (optionally) how to send serial data in a Java program.

## LCD Display

The first thing we'll do today is to get the LCD display working so that
we can display things on the Arduino itself (not just sending it to the PC).

1. Starting from the example application and support code in your repository,
author an Arduino sketch that receives strings from the serial port (of
length up to 16 characters, feel free to truncate if longer) and displays
them on the LCD display.  You can use `Serial.available()` and `Serial.read()`
or `Serial.readbytes()` to receive characters from the serial port.

	The example application is
in `Arduino/studio5/LCDExample/LCDExample.ino`.  If it isn't there, update
your local copy from the repository.

	The library files needed to use the LCD are `ST7036.h`, `ST7036.cpp`,
and `lcd.h`, all of which should be in the libraries directory,
`Arduino/libraries/LCD/`.  It is important that the Sketchbook location is
the `Arduino` directory of the *current* copy of your checked out repository
(either in your Eclipse workspace or a separate checkout performed using
the command line).  Use `File>Preferences` in the Arduino IDE to check
(`Arduino>Preferences` on a Mac),
and if you need to change it to get it right, you will also need to restart
the Arduino IDE.

	Execute the example application and look over its code.

	Open the blank sketch `Arduino/studio5/serial2LCD/serial2LCD.ino`
and do your work here.  Once you have declared an object of type `ST7036`
(e.g., named `lcd` as in the example code), you can use `lcd.print()` just
like you use `Serial.print()` for sending things to the Serial Monitor
on the PC.

	The LCD coordinate system (set `SetCursor()` in the example) has the
character position indicated with an ordered pair `(x, y)`, where `x`
indicates the display row (either `0` or `1`) and `y` indicates the
display column (ranging from `0` to `15`).

2. The first received string should be displayed on the top row (row 0),
the second received string should be displayed on the bottom row (row 1).
When the third string is received, the display should be cleared and
the cycle repeated (first displaying on the top row).

3. When using the Serial Monitor in the Arduino IDE to test the code above,
the line that you type in is actually delivered to the Arduino when
you hit the `return` key, which causes a `'\r'` character (carriage return)
to be sent as well.  Do not send this character to the LCD display, but do
use it for the sketch on the Arduino to understand that the string is complete.

	You will need to do some (fairly simple) string manipulation
within your Arduino sketch to accomplish this.  Take a look at the
[string][stringref]
documentation for Arduino C, and use the array of characters approach
to strings, not the `String` class.
Given the need to support 16 characters that will be displayed on the LCD,
and a `'\r'`, and a `NULL` termination, what is the minimum size you should
declare an array of characters for use in this sketch?

	[stringref]: https://www.arduino.cc/en/Reference/String

4. In addition to displaying the received strings, echo them back to the
sender (including the trailing carriage return).  This last capability you
will likely want to turn on and off at various times, so feel free to
put it in a conditional that is set at compile time (e.g., whether the
conditional passes or not is determined by some value in a `#define` or
a `const int` declaration near the top of the sketch).

Show off your sketch to an instructor or TA.

## Optional additional stuff

If you are this far by the end of studio time, consider this studio
a success and jump ahead to Finishing up.  If you have time, there are
some additional things you can play with that are part
of Assignment 5, so doing them now gets you ahead of the game.

### Enabling Java communications

The next step is setting up the necessary Java libraries.
If you did this previously (e.g., in studio last week) you do not need to
do it again.  Skip ahead to **Authoring Java tools**.

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

### Authoring Java tools

1. The first task is to have a Java program send data to the Arduino.
We will start simple.

	In `java/studio5`, create a new Class (called `SerialTestOutput`) that will
(in its `main()` method) ask for a string of user input (up to 16 characters)
and send it out the serial port.
You will need to instantiate a new `SerialComm` class
(which we gave you in studio 4, you will need to
`import studio4.SerialComm;`), and invoke its
`connect()` method, which takes a string argument indicating which
serial port.  Note (in the code
for the `SerialComm` class) where to set the baud rate (feel free to leave
it at the current 9600 baud).
Example code for guidance is provided in the `main()` method of `SerialComm`.

	The `write()` method from the `OutputStream` object (use `getOutputStream()` to
get it) is appropriate for sending the character data.
You will want your `SerialTestOutput` to mimic the functionality of 
the Arduino IDE's Serial Monitor.  Make sure a `'\r'` is the
last character sent to the serial port.

	Using the Arduino sketch you developed above,
exercise your Java program and ensure
that you get the same text output on the LCD console that you previously
were getting when using the Serial Monitor built into the Arduino IDE.


2. The second task is to build a tool (that operates on `OutputStream`s) that
will be used to provide visibility (observability) into the stream.
The new class is called `ViewOutputStream`, and it extends the pre-exising
library `FilterOutputStream` class. In our case, the "filter" function
is a display operation.

	Your `ViewOutputStream`'s `write()` method should `super.write()`
from the
parent `FilterInputStream` and display the byte that has just been written in
ASCII hex form (using the provided `PrintStreamPanel` class from studio 4).
In other words, this class displays bytes being sent through the
output stream, but does not alter them.

	ASCII hex form means that for every byte that goes through the stream, the display
should show 3 characters: a space character and 2 characters that
represent the data byte in hexadecimal (e.g., if the byte in the data
stream is `0x5f`, the string sent to the `PrintStreamPanel` should be
"` 5f`" (or "` 5F`" if you prefer).

	Wrap your `OutputStream` in your newly created `ViewOutputStream`.
Repeat task 1 above now using your `ViewOutputStream`'s `write()` method
rather than your original `OutputStream`'s `write()` method.
	
## Finish up

1. Commit your code and verify in your web browser that it is all there.
2. Check out with a TA.

Things that should be present in your repo structure:

<section class="tree">

- `Arduino/`
	- `studio5/`
		- `LCDExample/LCDExample.ino`
		- `Serial2LCD/Serial2LCD.ino`
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
	- `studio5/`
		- `ViewOutputStream.java`
		- `SerialTestOutput.java`
</section>
