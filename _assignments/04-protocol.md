---
title: What did you say? - Protocols
author: Roger Chamberlain
week: 4
assigned: 2016-02-17
due: 2016-02-24
---

## The idea

When two computers send data from one to another, it is the job of a
protocol to specify how bytes transmitted by the sender are to be
interpreted by the receiver.
This task is particularly important when the two computers are
of different types, and the programs running on the two computers
are written in different languages.

Protocols are often called upon to do additional things as well.
For example, helping the receiving computer make sense of a stream
of bytes even when some bytes go missing.

We will examine each of the above functions by sending information from
the Arduino to the PC using a protocol that has been provided to you
and receiving messages in that protocol in Java on the PC.

## The background

### Protocols

Quoting
from [Wikipedia](https://en.wikipedia.org/wiki/Communications_protocol),
*protocols* "are the rules that define the syntax,
semantics and synchronization of communication and possible error recovery
methods."
Syntax is basically how does one express something.
Semantics is basically what does something mean.
Synchronization is basically describing who does what when.

The protocol we will use includes all of the above.

### Our protocol

Our protocol is organized around the sending of individual
*messages*.  In our case, a message will be comprised of
a *header*, which will be one byte in length, and a *payload*,
which will have a variable length.
The header is used by the protocol for some function related
to the communication task itself (we'll describe that below),
and the payload is the actual information being delivered
by the message.

In terms of message semantics, our payload will be delivering
*key*, *value* pairs.  The *key* will indicate both the meaning
of the *value* and its type.  Examples of values might be a
raw temperature reading, a filtered temperature reading,
a potentiometer reading, a timestamp, an error message, etc.

#### Header

As stated above, the message header's purpose is to help the
communication protocol do its job.  In our case, the header is
designed to help us sync up the beginning of a message both
at the sender and the receiver.

Consider what happens if the sender is delivering a series
of two-byte integers, high byte first then low byte second,
and the receiver somehow misses one byte.
If this happens, all the integers that follow will be
interpreted incorrectly by the receiver.

We will significantly decrease (but not completely eliminate)
the possibility of this happening by starting each message
with what is called a *magic number*, or a constant value
that is known to both sender and receiver as always present
as the first byte of a message.

When the sender wishes to transmit a message, it must start
the message with the magic number.
For our protocol, the magic number is `0x21`, or ASCII `'!'`.

When the receiver is ready to interpret an incoming stream
of bytes, it knows that the first byte of a valid message
will be the magic number.  When it reads a byte from the
stream, if the byte is not the magic number, it can discard
that byte (and all subsequent bytes that are not the magic
number) until it reads a byte that *is* the magic number.
In this way, it is reasonably assured to be aligned with
the beginning of a message.

<aside class="sidenote">
### Magic numbers
{:.no_toc}

Magic numbers are not only used in message protocols,
but find uses in many other places as well.  One example
is in files that are expected to be of a particular type.
Recall that when we compiled our C programs, one of
the intermediate file types was an *object* file, which
had a `.o` extension on the filename.
What might happen if the linker tried to read in a `.o`
file that wasn't created by the compiler?

The above issue is avoided by ensuring that every `.o`
file starts with a magic number, and if the linker
opens a `.o` file that doesn't have the correct magic
number at the beginning, it throws an error.
The magic number in object files is actually 4 bytes
long: `0x7f 0x45 0x4c 0x46`.  A larger magic number
clearly has the benefit that there is a lower likelihood
that it will be present inadvertently at the beginning 
of a file (or a message).
</aside>

#### Payload

The payload in our protocol is comprised of a *key*, *value* pair,
in which the key defines both the meaning and the format of the value.

The key is a fixed-length field, one byte.
The value is a variable-length field, the number of bytes depending
upon a number of factors.

For this assignment we define the following keys:

`0x30`	debugging string in UTF-8 format, maximum of 100 characters long

`0x31`	error string in UTF-8 format, maximum of 100 characters long

`0x32`	timestamp, 4-byte integer, milliseconds since reset

`0x33`	potentiometer reading, 2-byte integer A/D counts

`0x34`	raw (unfiltered) temperature reading, 2-byte integer A/D counts

`0x35`	converted (unfiltered) temperature reading, 4-byte float, degrees C

`0x36`	filtered temperature reading, 4-byte float, degrees C

As the semester progresses, we might add to the above list, but we
won't change the meaning of the above defined keys.

For string values in UTF-8 format, the first two bytes are a two-byte
integer that gives the length (number of characters) of the string.
This is then followed by the ASCII characters of the string.
In our protocol, characters are restricted to the range `0x01` to `0x7f`
(i.e., `NULL` is not allowed, nor are characters in the extended
range of the UTF-8 standard).
In Java, the `DataInputStream` method `readUTF()` should simplify things
greatly.

For multi-byte values that represent a single number (e.g., 2-byte integers,
4-byte integers, 4-byte floats), the order of the bytes is most significant
byte first and least significant byte last.
In Java, take a look at the `DataInputStream` methods `readShort()`,
`readInt()`, and `readFloat()`.

## The assignment

### The Arduino side --- sending messages

Attach the potentiometer and temperature sensors to two distinct
analog input pins.  The wiring is the same as the last two assignments.

Starting with the empty sketch `Arduino/assignment4/sender/sender.ino`,
write a sketch that periodically (once per second, using delta-time techniques)
reads both analog input channels and
sends the following messages to the attached PC:

1. A timestamp message that is the return value from the `millis()` call
used to control the delta-time loop (i.e., save the return value from 
`millis()` in a variable so that you can use it both for the `if` test
in the delta-time code and send it to the PC. Make sure the variable
you use is declared as an `unsigned long`!
This is a key = `0x32` message.

2. A potentiometer reading of the type used in Assignment 2.
This is a key = `0x33` message.

3. A raw A/D counts reading from the temperature sensor.  This hardware
setup is the same as for Assignment 3; however, you will need to use
`analogReference(DEFAULT)` to maintain compatibility with the potentiometer.
This is a key = `0x34` message.

4. A converted, but unfiltered, temperature reading in degrees C.  Note that
you will need to change the conversion formula to accommodate the 5V
analog reference voltage.
This is a key = `0x35` message.

5. A filtered temperature reading in degrees C.  Note that
the filtering code doesn't need to change, since the filter's input 
and output are both degrees C (i.e., they haven't changed from Assignment 3).
This is a key = `0x36` message.

In your Arduino sketch, read the two analog inputs first (potentiometer
and temperature sensor), then do the processing on the temperature
signal (conversion and filtering), and only once all of the above
is complete should you send out the 5 messages.

As in Assignment 2, when the potentiometer reading is above a threshold
value (feel free to use whatever value you chose in that assignment, or
pick a new value) send a message with the error string "High alarm".
This key = `0x31` message should follow the filtered temperature.

Finally, somewhere that you find it helpful (maybe more than one place),
send a message with a debug string.  It need not follow the message
ordering constraints above, it can be sent from anywhere in the sketch.

### The Java side --- receiving messages

While certainly not required, we believe it's easiest to structure your
receiver program as a **finite state machine**. We recommend reading our
[Introduction to FSMs](/~cse132/guides/intro-to-FSMs.html) guide, as it
will make your program *significantly* easier to reason about.

Starting from the (mostly) empty Java class `MsgReceiver` found in
`java/assignment4/`, author a program that receives messages that
conform to our protocol.  Upon receipt of a complete message, print
a meaningful line to the console, which includes the type of message
(e.g., debug string, error string, potentiometer value, raw temperature,
unfiltered temperature, filtered temperature) as well as the value
(the string value, integer value, or floating point value).

Messages that do not conform to the protocol should generate an
error printed to the console that is visually distinct from the
protocol-supported error message.

### Being smart about the order of development

I would suggest the following sequence:

1. In `MsgReceiver`'s `run()` method, simply consume and throw away bytes.
This allows you to quickly have a Java program running that lets you see
the incoming data (via `ViewInputStream`). You can test this using the
Arduino sketch you used in studio earlier this week.
2. Author enough of the Arduino sketch `sender.ino` that it can send
a debug message (i.e., key = `0x30`).

	Send a few debug messages.
3. Author enough of the Java program that you can receive a debug message
and reliably observe the debug string on the console window.

	Send a few more debug messages.
4. Return to the Arduino sketch and expand the message types supported.
5. Return to the Java side and receive that message type.

	Test it. Use debug messages to figure out what is going on in the
Arudino sketch, and print to the console to figure out what is going on in the
Java program.  Have you figured out yet why I suggested the
development sequence above?

6. Repeat steps 4 and 5 until done.

### The cricket part (completely optional, only do this if you want to)

No, this is **not** required, but if you like, keep your cricket
from Assignment 3 flashing.  Does it work OK with all the new stuff
going on in the Arduino sketch?  Or have we given the Arduino too
much work to do?  Tell us about it in your `cover-page.txt` file.

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

</section>

### The rubric

- 15pts: Did the lab they demoed work?
	- Is ViewInputStream showing received bytes?
	- Is Arduino sending correct messages?
	- Is Java parsing messages correctly?
	- Do they wait for magic number on receipt?
	- Are all message types exercised?
	- Is it easy to grade?
- 5pts: Is the cover page correct?
	- Cover page completely filled
	- Correctness --- cover page questions
