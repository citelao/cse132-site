---
title: Stoplight Engineering
author: Ben Stolovitz
week: 3
assigned: 2016-02-08
due: 2016-02-08
---

## Introduction

* this will be a TOC 
{:toc}

Last week, you explored some of the differences between the Arduino and your regular computer: though your Arduino could connect to and directly control circuits, it was too slow to keep time well using `delay()`.

Today we will explore this concept further and introduce a workaround to the problems introduced in delay-based timing.

### Objectives

By the end of this studio, you should know:

- how to write **delta-based timing** software and
- how to **asynchronously control multiple outputs**.

## Hooking up a stoplight

The first step in programming an intersection is building the intersection.

1. 
	<aside class="sidenote">
	### Total transmit failure
	{:.no_toc}
	
	Your first inclination might be to start at pin 0, then work up from there as you add pins. This will not work.
	
	Pins 0 and 1 are `RX` and `TX` pins: they are connected to the same parts of your Arduino that handle receiving and transmitting data from the computer. The upshot of this? If you attach a circuit to these pins, uploading probably won't work.
	
	As a result, the convention in Arduino is to wire starting at pin 13 and work down.
	</aside>

	Wire up the intersection by hooking up 8 LEDs to your Arduino: two traffic lights (red, yellow, and green), and one pedestrian "walk" indicator (both "walk" and "don't walk", any color). 

	If you wish, it is fine to use your RGB LED (used in assignment 1) as the
"walk"/"don't walk" indicator.  One traffic light is to represent a North-South (NS) road, and the other represents an East-West (EW) road. The intersection has a single walk indicator with 2 LEDs: when it is safe to walk across the road, one "walk" LED will flash. When it is not safe to walk across the road, the other "don't walk" LED (maybe a red one?) will be on.

	Attach each discrete LED to a digital pin, making sure that each's path to ground has a series resistor as indicated in the diagram below:

	![The LED-output circuit diagram.](../img/LEDOutput1.png)

	Any resistor value between 200 ohms and 500 ohms will work fine.
	
	Since the LEDs represent different combined components (stoplights and walk signals), grouping them appropriately will help you understand the system better.
2. Test your connections by writing (and saving in `Arduino/studio3/`) a simple Arduino sketch called `LEDtest` that turns the 8 LEDs on and off. Maybe start with your `heartbeat` sketch from last week?

## Getting the light to change

1. Open the `stoplight` sketch in `Arduino/studio3/stoplight/`. It should be basically empty.
2. From last week, you should know that using `delay()`-based timing is inaccurate. Furthermore, it is a **blocking** procedure: your Arduino literally waits for however long you specify, not running any other code until the delay is completed. 

	This is not good for our stoplight: we have to time many different states (NS light green, NS light yellow, EW light green, etc.) while also maintaining constant flashing on the walk signals. We *could* carefully architect our times so that these states and flashes correspond (i.e. the flash interval is a factor of the state duration, so you could measure state changes in "number of flashes"). But there's a better solution that doesn't require such convoluted reasoning.
	
	In fact, let's put that to rest right now by writing out constants for the different states of our system. Consider the different phases an intersection has: One light is green, then it is yellow, then the other light is green, etc. You can reduce the system down to four different intervals for the stoplights and one for the walk signal (recall the discussion in lecture).
	
	Use `const int`s at the start of your program to define these numbers in milliseconds[^define]. To underscore our point, choose a prime number for at least one of the traffic intervals, like `3041`.
3. 
	<aside class="sidenote">
	### Structuring
	{:.no_toc}

	While certainly not required, we believe it's easiest to structure your program as a **finite state machine**. We recommend reading our [Introduction to FSMs](/~cse132/guides/intro-to-FSMs.html) guide, as it will make your program *significantly* easier to reason about.

	If you successfully implement a FSM, your `loop()` should become a two or three step process:

	- calculate new state
	- output traffic signal LEDs based on state
	- independently flash walk signal

	Since the code for each process is fairly long, separate each phase into a different function. I guarantee this will make your program simpler to understand and explain.
	</aside>

	To make this timing work, we will no longer use `delay()`. Instead, we implement **delta-based timing**. It's a powerful concept used in everything from slow computers to the most recent blockbuster video games (it's actually [vital to them](http://gafferongames.com/game-physics/fix-your-timestep/)).

	Delta timing (as it's also called) is a **non-blocking** timing mechanism. It does not halt the rest of the program while it waits. It is not a specific function, but rather a *mindset*, a different way of reasoning about your programs. And it all starts with `millis()`.
	
	`millis()` returns a `long int` (or `long`, same type), the number of milliseconds that have elapsed since your sketch began. Instead of *having your sketch wait* for the right time, you *wait for your sketch* to reach the right time. By keeping track of the `millis()` value of the *last* time you executed a recurrent task, you can compare its value to the *current* `millis()` value every iteration of the loop, and if the difference---the **delta**---is larger than a certain value, you execute the task again.
	
	For example, if I had a task I wanted to run every second, like in the heartbeat project:
	
	~~~ c
	long int accumulator = 0;
	void loop() {
		if(millis() - accumulator > 1000) {
			accumulator += 1000;
			Serial.print("beat");
		}
	}
	~~~
	
	Because there's no delay, this `if` statement does not block program execution: I could have several more timers and accumulators executing at once.
	
	Use a delta time loop to make your stoplight change appropriately controlling the lights for the two streets (ignore the pedestrians for the moment). You  will need to use a global variable to keep track of the state of your intersection and another as the accumulator. This is why we recommend using a FSM (see sidebar).
	
[^define]: In Assignment 2, we recommended using `#define` over `const int`. This was a mistake on our part. `#defines` are slightly better in pure C, but we recommend `const int`s in Arduino C for type safety. [This StackOverflow answer](http://arduino.stackexchange.com/a/14187) explains the reasoning for `const int`.

## Just add pedestrians

Because a delta time loop does not block, you can have other timers running at the same time, even if they have very ugly common factors. For example, strategy games update the game state very rarely (maybe 7 Hz) but redraw the screen very frequently (60 Hz). They just have two delta time loops, one for game state and one for screen state.

1. Add another delta time segment to your program to flash the walk signals appropriately. When the road is crossable, one of the walk LEDs should flash, and when the road is not crossable it should be off and the other walk LED should be on.  If you have used the RGB LED for your walk indicators, be creative with your color choices here!

## Finish up

1. Commit your code and verify in your web browser.
2. Check out with a TA.

Changes to repo structure:

<section class="tree">

- `Arduino/`
	- `studio3/`
		- `stoplight/stoplight.ino`
		- `LEDtest/LEDtest.ino`
</section>
