---
title: The Super-Safe Linear Color-Gradient-a-rizer
author: Ben Stolovitz
week: 2
permalink: weeks/2/assignment
---

## The idea

* This is a TOC
{:toc}

In this assignment, you will create an indicator light for a **potentiometer** (a "knob" in normal-person speak, or a **pot** in engineer speak). This is, as you might expect, a very common application of simple microprocessing, and you might see indicator lights controlled by tiny computers anywhere from your car to the little blinking sleep light on your laptop.

Your indicator light will be an RGB LED that scales between two colors and then blinks red when a pot is turned up too high.

By the end of this assignment, you should know how to wire up circuits that produce continuous ("analog") values, read these values into your Arduino, and simulate analog output from your Arduino using Pulse-Width Modulation (PWM). Let's go!


## The background

### Potentiometers

Potentiometers are **variable resistors**, if you've had any experience with circuits. Basically, they resist very little current when they're turned to one extreme, and resist almost all current when they're turned to the other. In between, they generally scale their resistance linearly or logarithmically. Hence the term variable resistor: their resistance varies depending on how much they're turned.

They generally have three pins: a positive pin, a negative pin, and an output pin. The positive pin goes to your voltage source, the negative to ground, and the output to wherever you wish the output to go. In most cases, you want to attach the output to an analog input on your Arduino. 

The output is usually the middle pin and you can choose positive and negative pins arbitrarily from the other two. N.B.---this is **not** true for every electrical element, though.

The variable resistance of a pot has another implication. Since it does not resist current at one extreme, it has the ability to short circuit a connection from high to ground if there are no other resistors present. Make sure to include a resistor between it and its connection to source or ground. 

If none of that made sense, consider reading our [Intro to Circuits](TODO).

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
	Circuits are overwhelming if you haven't wired many before. Just make sure your final potentiometer circuit looks like this:
	
	TODO image of pot circuit + diagram

	If you cannot understand the schematic diagram easily, you should consider reading our [Intro to Circuits](TODO) guide and doing **Studio 1B**.
	</aside>
	Wire up a circuit from the 5V pin, through a potentiometer, to the analog pin of your choice (look for the pins labeled `A0`-`A5`). Make sure to resist the pot's connection to ground.
	
	You can test the circuit by `analogRead()`ing from that pin and `Serial.print()`ing the result. It should be a fluid number between `0` and `1023` as you turn the potentiometer.
3. Wire up your RGB LED to 3 PWM pins on your Arduino. You need PWM in order to modulate the brightness of each color. Keep in mind that only some pins are PWM pins. The reference for [`analogWrite()`](https://www.arduino.cc/en/Reference/AnalogWrite) helps there.

	The RGB LED is basically 3 LEDs in one little case, so naturally it has 3 input leads and one output. The longest lead is the common one, although whether it's the cathode or the anode may vary. Thankfully, it doesn't matter.
	
	TODO image of common anode and common cathode RGB LED
	
	You'll want to resist each of the three other leads individually.
	
	Your circuit should look something like this: TODO sidenote this
	
	TODO image of circuit.
	
	You can test this circuit by `analogWrite()`ing to each of these pins in your Arduino code. The corresponding color should light up.
4. Complete the Arduino code so that it linearly scales between two colors of your choice as the potentiometer goes from completely open to almost closed. 
	
	However, decide upon a cutoff voltage (you work for a *very* safety-minded company) that switches the LED to pure red and causes it to blink slowly (using `delay()` as in Studio). When the potentiometer is turned back below this threshold, the program resumes. There can be a small lag before the program resumes (as in, don't try to fix it if one occurs. We'll explain how to get rid of it later).

### Guidelines

You are given pretty much free reign to complete this assignment as you choose. However, in order to make our lives a lot easier once it comes time to grade everything, pay attention to these coding guidelines, as well as the style guide for this class (TODO link):

- Use exactly **four resistors** in your circuitry.
- Keep arbitrary constants (pin numbers, cutoff thresholds, colors, etc) as **compile-time constants** near the top of your Arduino program, using [`#define MY_CONSTANT value`](https://www.arduino.cc/en/Reference/Define).
- Use consistent and high-quality **indentation**. Better programmers use better indentation. So be a better programmer.
- **Read up** on `analogRead()` and `analogWrite()` from the Arduino documentation. It's very good.

## The check-in

TODO copy first two levels from rubric