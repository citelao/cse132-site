---
title: "Protocols, or What did you say?"
author: Roger Chamberlain and Ben Stolovitz
week: 4
assigned: 2016-02-17
due: 2016-02-24
---

## The idea

* This will be a toc
{:toc}

When two computers send data from one to another, it is the job of a **protocol** to specify how bytes transmitted by the sender are to be interpreted by the receiver. The idea is simple: if we specify *very, very* concretely how we expect our data, it becomes easy to communicate with our program. Despite the vast differences between our Arduino and Java programs, so long as we create and follow a well-defined protocol, the differences barely matter.

In this assignment, you will build a pair of programs---one Arduino, one Java---that harvest real-world data, transmit it, and then filter it on a beefier processor. Though this assignment focuses mostly on the data transmission, this centralized design is very useful in many circumstances. WIFI networks, at least in the small scale, rely on this, where many devices connect to a centralized hub.

Using a provided protocol, you will design an Arduino program to send and a Java program to receive real-world measurements.

## The background

### Protocols

No matter what we want to communicate, someone, somewhere, somehow has to decide upon a way of communicating it. Someone created a **protocol**. This is clear when looking at something like language: it has rules, syntaxes, grammars, symbols, definitions, and a slew of implicit and explicit rules. Though not as murkily defined as language, all forms of computer communications have the same structure.

Because we could never express the definition of one accurately enough ourselves,
from [Wikipedia](https://en.wikipedia.org/wiki/Communications_protocol),
**protocols** are "the rules that define the syntax, semantics and synchronization of communication and possible error recovery methods." In a word: **rules**.

If we define every bit of our protocol precisely enough---from the size of `int`s to the encoding used for `char`s to the ordering and grouping of data---we can easily (and independently) write software to both produce and parse that data.

We detail this week's protocol below.

### Our protocol

We chose to design a protocol that centers around the sending of individual
**messages**. Each message we send will have a 1 byte **header** and a variable length **payload**. The header is basically used for book-keeping and the payload is the actual information being sent.

In our case, the payload will send **key-value pairs**: a **key** indicating the meaning of our value (is it a temperature or a string?, etc.) and a **value** for that key. A value might be a
raw temperature reading, a filtered temperature reading,
a potentiometer reading, a timestamp, an error message, etc.

#### Header

<aside class="sidenote">
##### Magic numbers
{:.no_toc}

Magic numbers can be found not only in **communication protocols**,
but in places all over computer science. One such place
is in files that are expected to be of a particular type.

You can understand the arbitrary nature of file extensions by renaming a `.jpeg` file `.txt`---it will be garbage, but your computer doesn't have any "checker" when using files. What could happen if you accidentally ran a `.txt` file or a JPEG as a compiled program? What if some of the bytes in the file translated to machine instructions to destroy a file?

To prevent that, ELF files (compiled Linux programs) and their Windows equivalents, `.exe`s, both have magic numbers at the beginning. ELF files begin with 4 bytes of magic numbers: `0x7f 0x45 0x4c 0x46` (or `DEL E L F` in ASCII---`DEL` is a special character). Windows executables: `0x4d 0x5a` (`M Z`, the initials of the designer).

If you consider the similarity between **file formats** and protcols, it's not surprising that [many, many recognizable filetypes](https://en.wikipedia.org/wiki/Magic_number_(programming)) have magic numbers, too.
</aside>


As stated above, the message header's helps the
communication protocol do some book-keeping. In our case, the header is
designed to help us sync up the beginning of a message both
at the sender and the receiver.

Consider what happens if the sender is delivering a series
of two-byte integers, high byte first then low byte second,
and the receiver somehow misses one byte.
If this happens, all the integers that follow will be
interpreted incorrectly by the receiver.

We will significantly decrease (but not completely eliminate)
the possibility of this happening by starting each message
with a **magic number**, a constant value
that is known to both sender and receiver as always present
at the start of a message.

When the sender wishes to transmit a message, it must start
the message with the magic number.
For our protocol, the magic number is `0x21`, or an ASCII `'!'`.

When the receiver is ready to interpret an incoming stream
of bytes, it knows that the first byte of a valid message
will be the magic number.  When it reads a byte from the
stream, if the byte is not the magic number, it can discard
that byte (and all subsequent bytes that are not the magic
number) until it reads a byte that *is* the magic number.
In this way, it is reasonably assured to be aligned with
the beginning of a message.

#### Payload

The payload in our protocol is comprised of a **key-value pair**,
where the **key** defines both the meaning and the format of the subsequent **value**.

The key is a fixed-length field: one byte.
The value is a variable-length field, the number of bytes depending
upon a number of factors.

For this assignment, we define the following keys:

- `0x30`	debugging string in UTF-8 format, maximum of 100 characters long
- `0x31`	error string in UTF-8 format, maximum of 100 characters long
- `0x32`	timestamp, 4-byte integer, milliseconds since reset
- `0x33`	potentiometer reading, 2-byte integer A/D counts
- `0x34`	raw (unfiltered) temperature reading, 2-byte integer A/D counts
- `0x35`	converted (unfiltered) temperature reading, 4-byte float, degrees C
- `0x36`	filtered temperature reading, 4-byte float, degrees C

As the semester progresses, we might add to the above list, but we
won't change the meaning of these already-defined keys.

For string values in UTF-8 format, the first two bytes are a two-byte
integer that gives the length (number of characters) of the string.
This is then followed by the ASCII characters of the string.
In our protocol, characters are restricted to the range `0x01` to `0x7f`
(i.e., `NULL`---`0x00`---is not allowed, nor are characters in the extended
range of the UTF-8 standard[^ascii]).
In Java, the `DataInputStream` method `readUTF()` should simplify things
greatly.

[^ascii]: In reality, a UTF-8 string can consist of *a lot* more than ASCII characters, like emoji, Greek letters, [Klingon](http://www.evertype.com/standards/csur/klingon.html), and more. However, the designers of Unicode were careful to ensure that the first 128 characters exactly matched those of ASCII, so ASCII strings are identical to their Unicode counterparts.

For multi-byte values that represent a single number (e.g., 2-byte integers,
4-byte integers, 4-byte floats), the order of the bytes is most significant
byte first and least significant byte last.
In Java, take a look at the `DataInputStream` methods `readShort()`,
`readInt()`, and `readFloat()`.

## The assignment

<aside class="sidenote">
### For all you hackers
{:.no_toc}

We want to provide two ways of completing this assignment: the guided way in the main writeup, and a more "free-form" way. In this sidebar we just detail what we expect the protocol to do and what your programs should output, but in the main writeup we guide you through the process in more detail. Choose whatever you like.

1. Wire up your potentiometer and temperature sensor to two analog ports on your Arduino. The wiring is identical to before.
2. In a 1Hz delta-time loop (in `sender.ino`), send---using our protocol:

	- the timestamp of the loop (do not call `millis()` a second time, store the first call as an `unsigned long` and use that),
	- the potentiometer reading,
	- the unfiltered, raw, A/D counts value for the temperature sensor,
	- the unfiltered temperature in Celsius (keep in mind `analogReference()` must be at `DEFAULT`, not `INTERNAL`, because of the potentiometer),
	- the filtered temperature in Celsius

	Make sure to do *all* the calculation *before* sending any messages.

	Finally, if the potentiometer reading is over a certain value of your choice, send an error string (key: `0x31`) `High alarm` at the very end of the delta-time loop.
3. Edit the `run()` method of `MsgReceiver` in Java to read these messages and print them out as it receives them. Make sure to output both the type of message (e.g., debug string, error string, potentiometer value, raw temperature,
unfiltered temperature, filtered temperature) and the value
(the string value, integer value, or floating point value). 

	Have it print a visually distinct error message if an unknown key is used.

That's the entire lab. If it seems simple, make sure to use a finite state machine on the Java side, as we will probably be extending this later in the semester.
</aside>

1. Author enough of the Arduino sketch `sender.ino` to send debug messages (i.e. send the magic number `!`, the key `0x30`, and then a UTF-8 encoded string, prefixed with its length)

	Send a few debug messages, making sure you're confident doing so. Can you write a function to `sendDebug()`? You can accept a string literal as an argument by taking a `char*` as an argument.

	If the Serial Monitor isn't helpful enough, alter the Java `MsgReceiver`'s `run()` method to continuously read bytes from the provided input stream (just like you did in studio). Because the stream is wrapped in a `ViewInputStream` in the constructor for you, you will see a window with the content printed in hex form.
2. Author enough of the Java program that you can receive a debug message and reliably observe the debug string on the console window.

	Send a few more debug messages.
3. Set up a delta-time loop, running at about 1Hz, that sends a message with the `millis()` value used to control it (i.e., save the return value from 
`millis()` in a variable so that you can use it both for the `if` test
in the delta-time code and send it to the PC. Make sure to use an `unsigned long`).

	This is the `0x32` message.
4. Alter your Java code to parse out the message and print it out nicely every time it's received. Include the type of message (e.g., debug string, error string, potentiometer value, raw temperature,
unfiltered temperature, filtered temperature) as well as the value
(the string value, integer value, or floating point value).

	While certainly not required, we believe it's easiest to structure your
receiver program as a **finite state machine**. We recommend reading our
[Introduction to FSMs](/~cse132/guides/intro-to-FSMs.html) guide, as it
will make your program *significantly* easier to reason about.

	Messages that do not conform to the protocol should generate an
error printed to the console that is visually distinct from the
protocol-supported error message. Indent it and use a different format. I like `!!!!! Error` but that may be a little dire for your tastes.
5. Attach the potentiometer and temperature sensors to two distinct
analog input pins. The wiring is the same as the last two assignments.
6. Update your delta time loop to also read the value of the potentiometer, sending it after the `millis()` message. This is the `0x33` message.
7. Likewise update your Java code to read this number and print it out nicely.
8. Continue doing this for the other keys: send and a receive a raw A/D counts reading from the temperature sensor. This is the `0x34` message.

	This hardware setup is the same as for Assignment 3; however, you will need to use
`analogReference(DEFAULT)` to maintain compatibility with the potentiometer.
9. Add the `0x35` message: a converted, but unfiltered, temperature reading in degrees C. Note that you will need to change the conversion formula to accommodate the 5V analog reference voltage.
10. Add the `0x36` message: a filtered temperature reading in degrees C.  Note that
the filtering code doesn't need to change, since the filter's input 
and output are both degrees C (i.e., they haven't changed from Assignment 3).
11. As in Assignment 2, when the potentiometer reading is above a threshold
value (feel free to use whatever value you chose in that assignment, or
pick a new value) send a message with the error string "High alarm".
This key = `0x31` message should come at the end of all output.
12. Double check that you do all your calculation before you send any messages. This makes life easier for the graders (groups your code together), and it *is* required.
13. As an optional part: keep your cricket
from Assignment 3 flashing.  Does it work OK with all the new stuff
going on in the Arduino sketch? Or have we given the Arduino too
much work to do? Tell us about it in your `cover-page.txt` file.

### Guidelines

1. Try to develop an intuition for the raw numbers behind ASCII. For example, what ASCII characters do our protocol's **keys** correspond to?

	This will be helpful if your Java program is behaving strangely and you need to look at Arduino Serial Monitor. You should be able to get a sense of the messages as they come through: you'll see the `!` as the magic number, then the ASCII character of the **key**, then "gibberish." Understanding which numbers go to which ASCII characters will help you make sense of that gibberish.
2. Make sure your program generates errors if it receives input it didn't expect. While silently failing is sometimes good (see [Defensive Programming](https://en.wikipedia.org/wiki/Defensive_programming)), in your case it will make it harder to understand where your program is going wrong. 

	Be loud! Print error messages! User error is the best type of error because it's not your fault.
3. Read your analog values, parse them, filter your data, and *then* print all your messages. It will make it easier for us to grade your assignment (and also easier for you to debug).
4. Send debug strings *a lot*. Since they are the first thing you implement, they are also the first thing you can be confident *works*, so if something is broken, falling back to them may be just what you need. 
	
	Use them only for debugging and small program notes, though. They're "debug strings" for a reason.

## The check-in

1. Open the `cover-page.txt` file in `Arduino/assignment4/` and fill it out.
2. Commit all your code (make sure to add any new files to your repo first).
3. Check out with a TA.

New files:

<section class="tree">

- `Arduino/`
	- `assignment4/`
		- `cover-page.txt`
		- `sender/sender.ino`
- `java/`
	- `assignment4/`
		- `MsgReceiver.java`
		- `ViewInputStream.java`

</section>

### The rubric

- 15pts: Did the lab they demoed work?
	- Is `ViewInputStream` showing received bytes?
	- Is Arduino sending correct messages?
	- Is Java parsing messages correctly?
	- Do they wait for magic number on receipt?
	- Are all message types exercised?
	- Is it easy to grade?
- 5pts: Is the cover page correct?
	- Cover page completely filled
	- Correctness --- cover page questions
	- 2pts bonus: Cricket question/implementation
