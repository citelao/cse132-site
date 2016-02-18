---
title: A Brief Introduction to Object-Oriented Programming
short: Objects
week:
- "4"
- "5"
author: Rishil Mehta
---

In CSE 131, you spent a lot of your time digging into code that was almost completely prepared for you. This meant that you didn't have to worry about the big-picture stuff---you could focus on figuring out the details of the methods you were supposed to be working on.

Unfortunately, the real programming world isn't always like that. Starting with CSE 132, you will be asked to do a lot more overhead work (sometimes you'll even be building entire, working projects from the ground up). To be able to do this, you need to have some familiarity with **object oriented programming**, which is the way Java and C++ (and most programming languages) work. Thankfully, a lot of people have made online tutorials that will help you learn the basics. The goal of this document is to point you to these sources of information and help you wrap your head around the concept of object oriented programming.

By the end of this document you should:

- know how classes and objects work and why they do what they do,
- be able to make real-life analogies to object-oriented programming concepts so that you can actually use objects in code,
- know the basic vocabulary of object-oriented programming, and
- know where to look if you ever get confused or forget how the syntax works in Java.

Let's get started!

## What is object-oriented programming?

The first thing to understand is that **object-oriented programming** is a programming "paradigm" and it is a really, really good way to code things[^sometimes], which is why we do it.

[^sometimes]: Well, it's good for a lot of things. Other paradigms include [functional programming](http://www.smashingmagazine.com/2014/07/dont-be-scared-of-functional-programming/), [finite state machines](https://en.wikibooks.org/wiki/A-level_Computing/AQA/Problem_Solving,_Programming,_Data_Representation_and_Practical_Exercise/Problem_Solving/Finite_state_machines), and a [whole mess of other things](https://en.wikipedia.org/wiki/Comparison_of_programming_paradigms).
If you are wondering:

- "What the heck is object oriented programming?" or
- "Why do we have to overcomplicate our code by making objects instead of just coding things outright?"

Then watch the first 3 minutes or so of this [Khan academy video](http://study.com/academy/lesson/object-oriented-programming-vs-procedural-programming.html).

Most of the remaining articles are from the official Java documentation.

# What are objects?

If you are wondering:

- "I'm still not sure what an object is..." or
- "Is there a real-life analogy to objects?"

You might want to read [What Is an Object?](https://docs.oracle.com/javase/tutorial/java/concepts/object.html). It's a little bit technical, but you should be able to see how real-life items can be modeled as objects.

**Quick quiz**: Pretend that you are modeled by an object in Java.

1. Is this a reasonable analogy? (hint: do you, like all Java objects, have “states” and “behaviors”?)
2. What are some states you might have? (hint: for me, some examples would be `Name: Rishil`, `hairColor: Black` etc.)
3. What are some behaviors that you might have? (hint: for me, some examples would be `walk` or `talk`)
4. What are some behaviors you have that can change your own state? (hint: for me, some examples would be `changeName` or `dyeHair`)
5. What are some behaviors you have that can change the state of other objects? (hint: for me, some examples would be `turnOffComputer` or `wakeUpRoommate`)

**States** and **behaviors** are loosely associated with instance/field variables and methods in Java, as we'll see in a little bit.
	
## What are Classes?

If you are wondering:

- “How do you construct an object?”
- "How can I bring [Platonic Ideals](https://answers.yahoo.com/question/index?qid=20090820162913AAmid41) into this?" or
- “Objects like you and me all have something in common: we’re all people.”

Then you might want to know [What Is a Class?](https://docs.oracle.com/javase/tutorial/java/concepts/class.html). What is an **instance** of a **class**? What is an **object**?

Of course, you might also want to know [how to build a class](https://docs.oracle.com/javase/tutorial/java/javaOO/classdecl.html).

**Quick Quiz**: 

1. What's the syntax you would use to create a new class `Person`? 
2. How would you make an instance of that class?
3. What's the difference between an **instance** and a **class**?

There are some common things that go into classes:

### Member variables

[What are member variables?](https://docs.oracle.com/javase/tutorial/java/javaOO/variables.html)

**Quick Quiz**: If we created a `Person` class, what are some field variables that we could have? Try and add these field variables:

- `String hairColor`
- `String eyeColor`
- `String name`
- `int age`
- `String occupation`
- `bool isCute`

1. What should their **access modifier** be -- should they be `public`, `protected`, or `private`?
2. Should these be **instance variables** or **class variables**? What's the difference?
3. Try and think of a few other properties that would make sense for a person to have, and code those in as well.

### Methods

[What's a method?](https://docs.oracle.com/javase/tutorial/java/javaOO/methods.html) Don't worry about overloading methods if it seems confusing. In fact, the documentation even has a warning:

> "**Note**: Overloaded methods should be used sparingly, as they can make code much less readable."

Let’s think of some methods a `Person` object might have (you don’t need to code these). Methods can change the state of that `Person`'s field variables (for example, a function called `puberty()` might change the `isCute` variable to `false`).

Try and think of how you would code a `changeName()` method.  There’s a problem. How do we know what name you want to change your name to? With what we know right now, we would have to create a lot of methods to solve this problem. For example:

	public void changeNameToLinkai() {
		this.name = "Linkai";
	}
	public void changeNameToEzekiel() {
		this.name = "Ezekiel";
	}
	// TODO allow name change to "Amandabeth"
	// ...

…and so on, for every name in the universe. Clearly this is not a good way to implement a `changeName()` method. If only there was a way for us to tell the function which name we wanted to change to when we called it. Oh wait, there is a way to do that, and it’s called using a **parameter**. Now, instead, our `changeName()` method looks something like:

    public void changeName(String newName) {
		this.name = newName;
	}

When we call the `changeName` method on a certain object, we can pass in a name to the variable `newName` as a parameter. 

### Constructors

Learn about [constructors](https://docs.oracle.com/javase/tutorial/java/javaOO/constructors.html) now. One thing this tutorial mentions is that you can have more than one constructor in the same class. If that’s confusing, don’t worry about it too much.

If we created a `Person` class, what might our constructor look like? Let’s pretend that the constructor creates a baby. So, when we instantiate a `Person` object, what are some things about its state that we can set right away? Well: 

    public Person(String itsHairColor, 
    	String itsEyeColor, 
    	String itsName) {
    	
    	this.hairColor = itsHairColor;
		this.eyeColor = itsEyeColor;
		this.name = itsName;
		this.age = 0;
		this.occupation = "unemployed";
		this.isCute = true;
	}

Some things, like hair color and eye color, were parameters that we decided to pass into the constructor. This is because they are different for every person so we need to specify what they are upon construction. Other things, like age, occupation or cuteness, are the same for every person at the time of construction, so we could just set them to `0` or `"unemployed"` or `true`. Try and think of some more attributes a person can have, and then add a constructor to your Person class using the right syntax.

It's also useful to read up about [arguments](https://docs.oracle.com/javase/tutorial/java/javaOO/arguments.html).

### Inheritance

So now we’ve gone over the basics. The last thing we need to cover is **inheritance**, which is what makes object-oriented programming so versatile.

So learn about [inheritance](https://docs.oracle.com/javase/tutorial/java/concepts/inheritance.html).

Evolution in Biology and inheritance in Java have a lot in common. Imagine, for a moment, that we have a class called `Mammal`. What might be some of its field variables? Is there anything we could cede from the `Person` class into the `Mammal` parent class (**superclass**)?

The `Mammal` class is a superclass of lots of other classes, meaning that there are a lot of classes that inherit all the qualities and methods that all mammals have, but also have their own unique properties. These classes are called “subclasses” of the class `Mammal`. Some examples would be the `Dog` class, or the `Bear` class or even the `Person` class. 

If our `Mammal` class existed, it would be appropriate for our `Person` class syntax to be something like: 

    public class Person extends Mammal { 
    	// notice "extends Mammal"
		// ...
	}

The `Mammal` class could itself be a subclass of class `Animal`, which could itself be a subclass of class `Eukaryote` and so on and so forth. 

If we kept going up the chain like this, is there a class that has no superclass—a class which all other classes inherit from? In real life, this is a question for your religious leader. But, in Java, the answer is yes, and it is the `Object` class. The `Object` class is like a platypus— it doesn’t really do much[^what]. If you ever declare a class without using the `extends` keyword, Java will just automatically assume that you are extending `Object`. 

[^what]: Editors note: I have no clue what Rishil meant by this simile.

## Summary
Congratulations, the conceptual section of the tutorial is over! Now that you’ve learned how to create classes, the next step is learning how to initialize and use objects in your functions. Java’s tutorials speak for themselves, so I will let them do the work. 

Start reading the [tutorials](https://docs.oracle.com/javase/tutorial/java/javaOO/objects.html) and read up until the **Questions and Exercises** section.
