---
title: The Super-Safe Linear Color-Gradient-a-rizer
author: Ben Stolovitz
week: 2
assigned: 2016-02-03
due: 2016-02-10
---

## The idea

* This is a TOC
{:toc}

In this assignment, you will create an indicator light for a **potentiometer** (a "knob" in normal-person speak, or a **pot** in engineer speak). This is, as you might expect, a very common application of simple microprocessing, and you might see indicator lights controlled by tiny computers anywhere from your car to the little blinking sleep light on your laptop.

Your indicator light will be an RGB LED that scales between two colors and then blinks red when a pot is turned up too high.

By the end of this assignment, you should know how to wire up circuits that produce continuous ("analog") values, read these values into your Arduino, and simulate analog output from your Arduino using Pulse-Width Modulation (PWM). Let's go!

## The background

### Potentiometers

### Potentiometers

Potentiometers are **variable resistors**, three-terminal circuit elements in which the resistance between the terminals can be varied by turning a physical knob. Two of the terminals allow connection to each end of a fixed resistance, and the third terminal (often called the **wiper**) can be positioned at any point between the end terminals.

A common use for a potentiometer (**pot** for short) is as a **voltage divider**.  If one end terminal is at a positive voltage (say, +5V) and the other terminal is at ground (aka 0V), the wiper voltage will then have a voltage between 0 and +5V, with the specific voltage at the wiper terminal determined by the position of the control knob of the pot.

In essence, the wiper terminal effectively divides the voltage across the end terminals, with the term **divides** coming from the mathematical expression $\frac{R_w}{R_p} \times (5V)$, where $R_p$ is the total resistance between the two end terminals, and $R_w$ is the (variable) resistance between the wiper and the end terminal at 0 V (ground). If $R_w$ is 0 ohms, the voltage at the wiper terminal is 0V.  If $R_w$ is equal to $R_p$ ohms, the voltage at the wiper terminal is 5 V.  Therefore, if we connect the wiper terminal to an analog input pin of the Arduino, we now have the ability for the user to provide a control input. Note that this "division" does not change the resistance at the other terminals.

The wiper terminal is the middle pin and you can choose positive and negative pins arbitrarily from the other two. N.B.---this is **not** true for every electrical element, though.
If, when you get the entire circuit running (including software), you notice that turning the knob clockwise lowers the voltage, feel free to swap the end terminals to clockwise motion of the know gives an increasing voltage.

If none of that made sense, consider reading our [Intro to Circuits](/~cse132/guides/intro-to-circuits.html).

### Analog input & output

<aside class="sidenote">
### Analog: It's not just a remnant of the 80's!
{:.no_toc}

Your Arduino is a **digital** device. It uses discrete *digits*, not continuous signals, to represent data, unlike **analog** systems, which store information in a physical signal as a signal *level*. This difference, and our preference for digital, lies at the heart of modern computing and is why computer science students take Discrete Mathematics at this school.

However, not all computers are digital. That's why some old fogies will sometimes call your laptop a "digital computer" and reminisce about the "digital revolution." The earliest computers were *analog*. They took continuous variables as input, like *voltages*, performed physical, mechanical operation on them, and produced physical values as output.

For example, an addition circuit might take two input voltages and combine them to produce one output voltage. Or [someone could simulate a bouncing ball](https://www.youtube.com/watch?v=qt6RVrmvh-o&t=0m42s) in a similar way.

The US Navy used physical, mechanical *rotation* in some of the earliest computers to aim battleship guns during WW2. Their [explanatory videos](https://www.youtube.com/watch?v=_8aH-M3PzM0) are some of my favorite things on YouTube.

We transitioned away from analog for two reasons: since the data is the signal itself, a noisy signal will futz with your results, and changing how your computer operates requires physically rebuilding the computer. Digital computers avoid both issues by allowing a **noise margin** between their two discrete values (high and low), and by being able to add new functionality with new *code*.

In any case, *all* modern sensors produce some type of continuous value corresponding to whatever they measure. It's up to you to transform them into some digital value (and we'll do this later in the semester). Unless you want to make an analog computer with a custom-built circuit. 
</aside>

Most day-to-day electrical components that measure real-world values provide the output in a continuous way. Pots, for example, are variable resistors, increasing their resistance to current as they're turned. Your Arduino, however, is **digital**. Though it also runs on electricity, it uses two fixed voltages to represent its values -- a $0V$ **low** and $5V$ **high**, with tolerances built in for noise[^tolerance].

[^tolerance]: The exact details are a little more specific: devices have a specified, "ideal" voltage level for high and low, with separate margins above and below for what each device will *accept* as high and low and *output* for the same values. The Arduino, for example, will treat anything as high as $1.5V$ as *low*, but will output, at maximum, $0.9V$ if asked to write a low itself.

#### Writing out

You built your first circuit in studio this week, wiring up an LED to one of your Arduino's many pins. When you turned that pin on, or digitalWrote `HIGH` to it, the Arduino output $5V$ to that pin. When you turned it off, the Arduino output $0V$.

Your Arduino can *only* output one of those two values. This might be sad news if you wanted to light up your RGB LED at anything other than full brightness, but for one thing: **Pulse-Width Modulation** (**PWM** for short). Because the human eye is much, much slower than your Arduino, if you turn an LED off and on very, very rapidly (on the order of 100 times per second), you will perceive that LED as being dimmer than full brightness[^movies]. [The Arduino reference on PWM](https://www.arduino.cc/en/Tutorial/PWM) explains how to do this in more detail.

[^movies]: This is similar to how movies look like motion even if they are only static images. Changing the images 24 times a second is enough to fool the brain into thinking it sees motion.

On Arduino, PWM is about as easy as "traditional" `digitalWrite()`s. In order to change the brightness of each color in your RGB LED, you will need to use `analogWrite()` (documented on the [Arduino reference page](https://www.arduino.cc/en/Reference/AnalogWrite)) to output a PWM'd signal. 

#### Reading in

However, we still haven't dealt with continuous values. You can now conceivably *mimic* a signal between $0$ and $5V$, but how do you read one?

On that note, *how do you even read a signal*?

We've never formally covered it, but you may have guessed that Arduino has two types of reads: `digitalRead()`s and `analogRead()`s. We will cover digital, "on-or-off" reads later in the semester[^involved], but right now you will use `analogRead`. [Its documentation](https://www.arduino.cc/en/Reference/AnalogRead) will be helpful.

[^involved]: Digital reading is a bit more involved. Because we usually want a single, clean signal when we digitally read something (for example, we want to know exactly if a button is pressed, ignoring noise in the signal), we have to do a bit of filtering that we haven't quite covered. With analog reads, we just treat the noise as part of the data. And in this case, noise doesn't really matter.

## The assignment

Let's get started with the assignment.

1. Create a new Arduino sketch (in the `arduino/assignment1/` folder of your repository) called `indicator`.
2. 
	<aside class="sidenote">
	### Overwhelming circuit diagram syndrome
	{:.no_toc}
	
	Circuits are hard. It takes a certain amount of intuition to understand them, intuition you might not have if you are just learning circuits. If the main circuit for this studio is confusing, we suggest two things:

	1. Read our [Intro to Circuits](/~cse132/guides/intro-to-circuits.html) guide.
	2. Wire up some simple circuits, provided below.
	
	#### Simple LED
	{:.no_toc}

	The first circuit is simple: just light up an LED. The diagram puts the resistor after the LED, but the order does not matter.

	![A simple resisted LED circuit.](../img/ledcircuit.png)

	1. Connect 5V to a row on your breadboard.
	2. Attach a 200ohm resistor (or as close as possible that you have) as a bridge between this power row and another row. The red LED we are using needs a resistance of about 200 ohms, using a simple calculation you can learn in a physics class.
	3. Attach the long stem of your LED to this resisted row and the other stem to an adjacent row.
	4. Ground this final row.

	Your LED should light up whenever your Arduino is plugged in.

	#### Dimmable LED

	If you were successful with this, it might make sense to attach your LED to a PWM pin instead. You can then write a simple program to test out `analogWrite()` before the big multi-color LED. The diagram for this is not particularly illuminating.

	1. Use the circuit from above, but instead of pulling from the `5V` pin on your Arduino, pull from a PWM pin (marked with a `~` on your board).
	2. Write a simple program (using `analogWrite()` and `delay()`) to gradually fade your LED from on to off.

	This should be more than enough to get you started reading ciruit diagrams.

	</aside>

	We need to build our circuit. The final circuit diagram follows, and we will guide you through building it:

	![The RGB-pot circuit diagram.](../img/assignment-circuit.png)

	1. Attach the **potentiometer**: wire up a circuit from the `5V` pin, through a potentiometer, to ground. Use the two *outer* pins for these connections, although the order does not matter. Connect the final pin (the center pin) to an analog pin of your choice (look for the pins labeled `A0`-`A5`).
	
		You can test the circuit by `analogRead()`ing from that pin and `Serial.print()`ing the result. It should be a fluid number between `0` and `1023` as you turn the potentiometer.
	2. Attach the **LED**: attach resistors to 3 PWM pins your Arduino (you need PWM to modulate each color's brightness). Keep in mind that only some pins are PWM pins. The reference for [`analogWrite()`](https://www.arduino.cc/en/Reference/AnalogWrite) helps there. 

		It's easiest to connect the pins directly to rows on your breadboard with plain wires, then attach resistors from those rows to new rows. You will attach the LED to these new rows.

		But first, we need to decied which resistors to use for which pin. We give you several different types of resistors, each with slightly different resistances. Luckily, these LEDs are tolerant enough to support any real ordering, but there is an "optimal" resistance for each color. Try to choose the closest resistance for each: red, 180ohms; green, 250ohms; blue, 300ohms.

		Each stem is attached to a different color LED, as you can see in the diagram, with stem `2` as the **common cathode**[^cathode]. You have two ways of numbering the other stem `1`, `3`, and `4`. The easiest is to note that stem `2` is the longest. The other is to find the flat end of the otherwise round LED. The stems count away from it, starting at `1` closest to the notch, and `4` farthest.

		Stem `1` is red, stem `3` is blue, and stem `4` is green.

		You can test this circuit by `analogWrite()`ing to each of these pins in your Arduino code. The corresponding color should light up.
4. Complete the Arduino code so that it linearly scales between two colors of your choice as the potentiometer goes from completely open to almost closed. 
	
	However, decide upon a cutoff voltage (you work for a *very* safety-minded company) that switches the LED to pure red and causes it to blink slowly (using `delay()` as in Studio). When the potentiometer is turned back below this threshold, the program resumes. There can be a small lag before the program resumes (as in, don't try to fix it if one occurs. We'll explain how to get rid of it later).

[^cathode]: There are two types of RGB LEDs, **common cathode** and **common anode**. As you might guess, one has a shared cathode as the long stem, and the other has a shared anode as the long stem. Common anode LEDs are actually controlled by writing *high* to the colors you want to shut off, and providing a constant `HIGH` at the anode. Because there is no potential difference at those *high* cathodes, there is no current and no light. We don't use common anode LEDs in this class.

### Guidelines

You are given pretty much free reign to complete this assignment as you choose. However, in order to make our lives a lot easier once it comes time to grade everything, pay attention to these coding guidelines, as well as the [style guide](/~cse132/style-guide/) for this class:

- Use exactly **three resistors** in your circuitry.
- Keep arbitrary constants (pin numbers, cutoff thresholds, colors, etc) as **compile-time constants** near the top of your Arduino program, using [`#define MY_CONSTANT value`](https://www.arduino.cc/en/Reference/Define).
- Use consistent and high-quality **indentation**. Better programmers use better indentation. So be a better programmer.
- **Read up** on `analogRead()` and `analogWrite()` from the Arduino documentation. It's very good.

## The check-in

- 15pts: Did the lab work?
	- Is it wired correctly?
	- Does it obtain real-world values as input?
	- Does it output real-world values?
	- Is it an easy grade (follow the **Guidelines**)?
- 5pts: Is the cover page correct?
	- Complete?
	- Correctness: PWM
	- Correctness: `analogRead()` conversions
	- Correctness: resisting circutits