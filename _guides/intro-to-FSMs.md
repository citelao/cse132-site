---
title: Introduction to Finite State Machines
week:
author: Josh Gelbard and Ben Stolovitz
short: FSMs
---

For lab 4 you need to implement the protocol we designed in class. There are multiple ways to do this, but this tutorial will explain the way we think is simplest. Looking at the assignment, you may think you need to use a ton of `if` statements. While you could code the lab in this way, it will probably be very long and confusing.

Instead, we want to introduce the **Finite State Machine**, one of the most powerful ideas in computing. However, in order to code it in a way that's not confusing, you'll need to know a few concepts first. Namely, `switch`es and `enum`s.

## Switches

The first concept is called a `switch` statement. It’s  a more convenient way to write `if` statements that have a lot of cases. Instead of a series of comparisons to one variable, you check several different cases of a variable. For example, if you had the basic code:

	int friends = 0;
	if(friends == 0) {
		System.out.println("You have no friends.");
	} else if(friends == 1) {
		System.out.println("You have one friend.");
	} else {
		System.out.println("You have many friends");
		System.out.println("You are cool.");
	}
	
	// Prints "You have no friends."

You could instead write a `switch` statement that checks the value of `friends`:

	int friends = 0;
	switch(friends) {
		case 0:
			System.out.println("You have no friends.");
			break;
		case 1:
			System.out.println("You have one friend.");
			break;
		default:
			System.out.println("You have many friends");
			System.out.println("You are cool.");
			break;
	}

	// Still prints "You have no friends."
	
Now, this is not particularly useful because we have so few cases, but it's useful to have a small example to explain the syntax:

	switch(variable) { // the variable to compare
		case 0: // runs if variable == 0
			// statements
			break; // each case must end in a `break`
		default: // runs if none of the cases match
			break;
	}

You should see the value of a switch statement in a larger example:

	int month = 8;
	String monthString;
	// We designate the switch to act according the value stored in month
	switch (month) {
	// The switch will check all of the cases you list
	// This is equivalent to if (month = = 1)...
	    case 1:  monthString = "January";
	             break;
	    case 2:  monthString = "February";
	             break;
	    case 3:  monthString = "March";
	             break;
	    case 4:  monthString = "April";
	             break;
	    case 5:  monthString = "May";
	             break;
	    case 6:  monthString = "June";
	             break;
	    case 7:  monthString = "July";
	             break;
	    case 8:  monthString = "August";
	             break;
	    case 9:  monthString = "September";
	             break;
	    case 10: monthString = "October";
	             break;
	    case 11: monthString = "November";
	             break;
	    case 12: monthString = "December";
	             break;
	    // Catches all of the times when an invalid input is given
	    default: monthString = "Invalid month";
	             break;
	}
	// In this case, August would be printed
	System.out.println(monthString);

## Enums

An `enum` is a built-in data type, just like an `int`, `float`, or `String`. It lets you assign variables to be one of a series of constants you create. For example, the cardinal directions:

	public enum Direction { NORTH, SOUTH, EAST, WEST }
	Direction treasureDirection = Directions.NORTH;

As you can see, defining an enum creates a new type with the name of your enum. From the example above, we create the `Direction` type:

	public enum Direction { NORTH, SOUTH, EAST, WEST }

You can now use the `Direction` type like any other variable -- maybe in a switch statement:

	switch(treasureDirection) {
		case Direction.NORTH:
			// grab coats & snowboots
			break;
		case Direction.EAST:
			// pack swimsuit to cross Atlantic
			break;
		case Direction.WEST:
			// roadtrip!
			break;
		case Direction.SOUTH:
			// get some sunglasses
			break;
		default:
			System.out.println("I don't think that's a direction.");
			break;
	}

There are a couple gotchas to both `enum`s and `switch` statements, but this is enough to learn about Finite State Machines.

## Finite State Machines

A **finite state machine** is a model used in computer science to represent a stateful system and its behavior.

We introduce the **Moore machine**, one type of FSM (you learn about other types in a computer architecture course like CSE260M). In a Moore machine, you make a list of possible states your system can be in, and for each state you decide how input to your system will modify the state.

For example, imagine a computer for a traffic light. You might have three different states: red, yellow, or green. You could also have an "advance" input that progresses the traffic light. We can represent this stateful system in a FSM, and it turns out most of the time the standard is to just draw it:

![A very simple traffic light FSM, with three states G, Y, and R.](http://i.imgur.com/UC113L8.jpg)

Where each circle is a state -- green, yellow, or red -- and the arrows indicate how the one input changes the systems state. The disconnected arrow indicates the initial state.

FSMs can also take multiple inputs. You could represent a search for the letters "dog" in a string with a FSM like this, where you output some `success` variable when you're in the green state:

![A FSM that takes a string and returns true if the sequence "DOG" is present in it.](http://i.imgur.com/M90rfHi.jpg)

You can also have multiple outputs for each state. Consider the long-studied and intractible problem of getting a hot pocket fully cooked:

![The quintessential problem illustrated.](http://i.imgur.com/VN8cJZ0.jpg)

Notice that every state must have defined transitions for every input, in this case `nuke` and `wait`.

## Your Lab

You can model your lab as a FSM, with the input coming from your `InputStream`. What states might you need? Here are a few to get you started: "waiting for magic number", "waiting for input type", "reading raw temperature", etc. This is something that makes sense to list as an `enum`.

Now your program will have several distinct parts. You'll keep track of what your current state is, and, based on that current state, select the next state based on the input from your stream (maybe using a `switch` statement?). You'll also look at the input and have your protocol act appropriately (saving data, printing debug info, etc). Then you'll switch to the next state and run the loop again.

This can look something like:

	State state = State.waitingForMagicNumber;
	while(true) {
		if(in.available() > 0) {
			State nextState;
			switch(state) {
				case State.waitingForMagicNumber:
					// read a byte
					if( /* byte is magic number */ ) {
						nextState = State.waitingForInputType;
					} else {
						nextState = State.waitingForMagicNumber;
					}
					break;
				// ... all your other states ...
				case State.readingRawTemperature:
					// read however many bytes are necessary
					// parse them intelligently
					// save them
					nextState = State.waitingForMagicNumber;
					break;
				// ... all your other states ...
				default:
					State.waitingForMagicNumber;
					break;
			}
            state = nextState;
		}
	}
	
Remember that every state needs a valid transition for every possible input, and think about what states you need to read the protocol properly.

Good luck!