---
title: Bitwise and Boolean Puzzles
author: Claire Heuckeroth and Ben Stolovitz
week: 1
assigned: 2016-01-27
due: 2016-02-03
---


## The idea

In this assignment you will use bitwise and Boolean operators to solve basic logical operations on numbers. These logic puzzles will help you better understand how binary fits into the day-to-day mechanics of computing. In other words, this assignment will help you think about how computers actually look at and understand data that they interact with.  

This assignment will also help you to better understand program organization and how to work with more complex programs that require many functions, files, and interoperating parts.

### Objectives

By the end of this assignment, you should know:

- how to use **bitwise** and **Boolean operators**
- when to use specific **numerical C data types**
- how to read **function signatures**
- what it means to **overload functions**
- how to **compile multi-file programs**
- how to **structure C code**
- how to **automate the build process**

## The background

### Bitwise and Boolean operators

It's hard to talk about numbers at all without talking about **operators**. You should be familiar with many of them already: `+`, `-`, `*`, etc. They take one or two numbers and *operate* on them, changing them. We introduce two new groups of operators: **bitwise** operators and **Booleans** ones. 

**Bitwise operators** are operators that act directly on the individual bits of a binary number, whereas **Boolean operators** operate on the "logical values" that the complete number represents: in C, `0` is a logical `false`, and anything else is `true` (even `-1`).

In a sense, these two groups of operators are very closely related: both operate only on two values (Boolean operators treat everything as either `true` or `false`, and bitwise operators operate on the underlying bits of numbers which can each only be `0` or `1`), and as you'll see in a bit, they perform very similar operations on these values. Their main difference is their scope: bitwise operations work on each bit individually, whereas Boolean operations work on the numbers as a whole.

#### The operations proper

- **Bitwise AND** (`c = a & b`) -- `c`  has `1`s in the places where both of the corresponding bits in `a` and `b` are `1`.
- **Bitwise OR** (`c = a | b`) --  `c` has `1`s wherever *at least* one of the corresponding bits in `a` and `b` is `1`.
- **Bitwise XOR** (`c = a ^ b`) -- `c` has `1`s wherever one *and only one* of the corresponding bits  in a and b is `1`.
- **Bitwise NOT** (`c = ~a`) -- `c` is `a`, with each bit inverted, else `c` is 0.
- **Right shift** (`c = a >> b`) -- `c` is `a`, with each bit moved lower `b` places.
- **Left shift** (`c = a << b`) -- `c` is `a`, with each bit moved higher `b` places.
- **Boolean AND** (`c = a && b`) -- `c` is `1` if both `a` and `b` are non-zero.
- **Boolean OR** (`c = a || b`) -- `c` is `1` if either `a` and `b` are non-zero.
- **Boolean NOT** (`c = !a`) -- `c` is `1` *only* if `a` is `0`. 

### Characters, integers, & longs (oh my?)

Not all numbers are the same length.  Because of this it is useful to have several different [data types](http://www.tutorialspoint.com/cprogramming/c_data_types.htm) that we can choose from for storing differently sized numbers.  In this way we don't waste space storing small numbers in large spaces.  The three data types we will use in this lab are `char`acters (1 byte[^csize]), `int`egers (4 bytes), and `long`s (8 bytes), each of which store whole numbers. 

By default, all of these values are `signed` and can store both positive and negative numbers. Their possible values  range from $-2^{n-1}$ and $2^{n-1} - 1$, where `n` is the number of bits in the data type. `unsigned` numbers range from $0$ to $2^{n}-1$.

Data types in [Java](https://docs.oracle.com/javase/tutorial/java/nutsandbolts/datatypes.html) have different lengths then in C.

[^csize]: All sizes given for the 64-bit C compiler which runs on the computers you ssh into. Java has different sizes, as do several types of 32-bit C.

- **Characters (`char`)** : Smallest addressable unit that can contain integer data.  They are 1 byte (8 bits) in length.  Signed characters range between `-128` and `+127`.
- **Integers (`int`)** : Standard unit to contain integer data.  In C, they contain 4 bytes---32 bits.  Signed integers range between `-2,147,483,648` and `2,147,483,647`.
- **Longs (`long`)** : In C, they contain 8 bytes or 64 bits.  Signed longs range between `−9,223,372,036,854,775,808 and 9,223,372,036,854,775,807`.

### Function overloading

Functions in any language have **signatures** used by the computer to identify them. For example, the signature for the standard C entry point is `int main(void)` or `int main(int, char**)`. In Java, the entry point signature is `public static void main(String[])`. Parameter names are not part of the signature.

Some languages allow **function overloading**: they allow you to create multiple functions with the same *name*, provided they have different *signatures*.  

This can be very useful.  For instance, if you wanted to create a function that adds two numbers. You might write a function `int sum(int, int)`, but then you want to add two `longs` as well. Function overloading allows you to have a similar function called `int sum(long, long)`,  which helps you work with many datatypes without remembering long lists of function names. 

C does not automatically allow overloading[^why], but there are a couple of [ways that we can get around this](http://stackoverflow.com/questions/479207/function-overloading-in-c). The easiest is to give functions with different inputs slightly different names to denote this difference.  This is how we will deal with this issue for this assignment. 

[^why]: Operator overloading is a surprisingly polarized field. The primary argument against it deals with how variables work in C. Some variables, like `char`s, can automatically be cast into other types (`int`s in the case of `char`). This can, as you might expect, be confusing to compile. Given a choice between two functions, both reachable by casting, which one should the compiler pick?

	Despite this, the demand for function overloading is very real (just look at the workarounds linked in the text), and C++ succumbed to the pressure with complex [overload resolution](http://en.cppreference.com/w/cpp/language/overload_resolution) logic. 
	
	Arduino C are secretly a subset of C++, though we normally call it C because so many features are missing, so overload to your heart's content.

### More than one file

As you write more and more complex programs, you will want to reuse parts of your code in multiple places or separate your code into multiple files. This was simple enough to do in Java: create a new class, `import` it where needed, and compile it with your other code. C, however, was written in 1972.

C has never heard of this newfangled `import` business. It does things the old fashion way, with **macros**. Macros are fragments of code, typically prefixed with `#`, that [help you write other code](http://stackoverflow.com/questions/653839/what-are-c-macros-useful-for). The macro language is old and bizarre, but we will use it simply to `#include` other files.

`#include` is not the same as Java's `import`. It is not smart. It is almost literally a copy-and-paster, gluing multiple files together. But it get's the job done... in a very particular way. 

#### Header files

You *could* use the `#include` macro to glue together your other code (write two `.c` files and `#include` one in the other), but that is slow: if I wrote `aLibrary.c` and `aProgram.c` like this, where `aProgram.c` includes the library, I would have to recompile `aLibrary.c` every time I recompiled `aProgram.c`, even if it didn't change. That's not fun.

Instead, we `#include` **header files**, specially written files that simply tell the compiler what functions exist in our other code. Thus all our code splits in two: for each **source file** we have one **header file**. The header files allow you to compile each source file individually, without actually including any other sources. When we want to create our final program, we **link** the compiled source files together into our final executable.

This was a marvelous thing in the 70's, and it remains useful when working with large libraries and lots of code. You've already used some header files---`stdio.h`, the file that declares `printf()`, is a **standard library** header, one that defines functions given to you by the system. Each of these *standard* headers are automatically linked when you compile, but source files you write are not. You must link them manually when you compile.

### Compiling

You compiled individual files with `gcc FILENAME` before, but that tries to create a complete program and looks for an `int main()`. If you plan on gleaning the benefits of header files, you need to be able to pre-compile the **definitions** of your header file functions (i.e. the actual code) and include it in your finished program.

You precompile your source files into **object files** (`.o`; no relation to Java's "objects") with the `-c` flag for GCC: `gcc -c FILENAME`. From then on, you can tell GCC to link to that file by including it in the final `gcc` command: if I have some `main.c` that includes a `library.h` (with associated `library.c`), you can build it in two steps:

```
gcc -c library.c
gcc main.c library.o -o myProgram
```
If you fail to tell GCC about all the files it needs to link against (or their raw `.c` source code), it will give you strange errors.

### Makefiles

Unsurprisingly, this can be tedious. Enter `make`. `make` is a program that helps build programs automatically, so useful that almost every linux computer has it preinstalled. Projects that use `make` have a **makefile**, a special type of file that specifies the commands required to build the project. This allows you to build together large programs without typing long commands every time you want to recompile your program.

A makefile is simply a list of files you want to create, followed by instructions on how to make them. For example, if your new iPhone app, `simplyBananas.c`, depends on `bananaPlacer.c` and `simplyGamesGameEngine.c` (i.e. `simplyBananas.c` includes both source files' respective headers), you simply list their object files as dependencies for the finished `simplyBananas` program, then tell the makefile what needs to be done to link those object files into the final program.

The syntax is a bit... interesting... but most of the work is actually done for you, automatically. We'll build a small one today.

## The Assignment

In order to finish this assignment you must complete the `logic.c`, `logicFunctions` and `Makefile.txt` documents in the `assignment1/` folder in your repository.

### `Make`: our first step

The first step in any project is getting it to build. If you open `Makefile`, you will see a lot of bizarre markup. `#`s indicate a comment, like `//` in Java and C.

If you ignore the comments, you'll see rules that look something like this:
	
```make
result: dependency1 dependency2
	actions 
```

In order to get the file called `result`, `make` needs to first build `dependency1` and `dependency2`, then run all the `actions`, which are just terminal commands. 
	
The most illustrative example is the target `test`, which doesn't actually create a file called `test` (it's a [`.PHONY` target](https://www.gnu.org/software/make/manual/html_node/Phony-Targets.html)). It requires the built program, `manip` (which we have not told `make` how to build just yet), then it runs the subsequent commands. It will be very helpful later.

1. The first thing we want to do is tell `make` how to build our `manip` program if it had no dependencies.
	
	The good news for us is that `make` already knows how to build C programs. There is an [implicit rule](https://www.gnu.org/software/make/manual/html_node/Implicit-Rules.html) for building C code. Specifically, there are explicit rules for linking files from object files and for creating object files from source code. 
	
	What is the implicit rule for building object (`.o`) files? You'll need it for the next steps.
2. The implicit command has several variables within that let you control exactly how a program is built. The first one, `CC`, is the name of the command to build with. By default, it's `cc`, but we want `gcc`. In your `Makefile` where indicated, set `CC` to `gcc` (`CC = gcc`).
3. There is also a variable with a name something like "flags"[^cpp] Because we dislike warnings and like clean code, set it to error on warnings, and warn more often: `-Wall -Werror -pedantic -std=c99 `.
4. Now, finally add a target called `all` that depends on the compiled `manip` program. Refer to the `test` target: you shouldn't have to change much.
	
	When you have successfully completed this step, you will be able to run `make` as-is and generate a compiled `manip` program. `make` will list the commands as it runs, printing any errors.
	
	The build command should look something like `gcc -Wall -Werror -pedantic -std=c99    manip.c`, and running `./manip` should congratulate you and tell you how to run the program.
5. As a final touch, modify the `clean` target to `rm` the compiled `manip` program, so if you `make clean` your directory will actually be clean. Use `rm`'s `-f` flag to prevent it yelling at you if there is no compiled program (i.e. if your directory is already clean).

[^cpp]: Don't use the `CPP` one, that's for C++. Use the `C` flags variable.

### Finishing up a pre-written program

There's not a lot to do in `manip.c` because we built a basic program for you with some functions and libraries you don't quite know yet. Aside from the two functions you don't know---`getopt()`, which automatically reads command-line arguments, and `atol()`, which converts strings to `long`s---the program should actually be pretty understandable.

You'll have to make a few changes to get your program working, though. 

<aside class="sidenote">
### Getopt()

The code we've provided should be fairly easy to understand, though it is designed with further understanding of the command line and we do not expect you to be able to create this program independently.

Apart from the section surrounding `getopt()`, most of the program is simply `printf()`s and simple comparisons. It turns out that many programs, though of course not all, are as simple at heart. In fact, the most confusing parts of this program are the bit manipulation you need to complete and the method in which the program reads arguments: `getopt()`.

You did simple work with arguments in this week's Studio, but creating a robust system for reading many arguments is a much larger ordeal. The work is so repetitive and tedious that the C standard library provides a function called `getopts()` that automates most of it. It reads through `argv`, argument by argument, parsing flags ("options") according to a specially formatted **optstring** until it can no longer parse. Ours is `hs:ilc`, so the syntax is pretty arcane.  

Whenever it successfully parses an option, it returns the option. When it is done, it returns `-1`. Thus our `while` loop reads options until there are no more. If an option accepts an argument, like `-s` does, the argument is placed into `char* optarg`, a global variable.

After it's complete, the global `int optind` holds the index of the next item in `argv`. In our case, it is the number we want to manipulate, so we store it accordingly.

In any case, this is a long way of saying that standard library does a lot of things for you. It makes our lives easier as teachers, and it makes your lives easier as students because you don't actually have to know how `getopts()` works to succeed in this class.
</aside>

1. The first step is getting numbers to read properly. If you run `./manip` as specified in its help text (`./manip NUMBER`), the program will output some information about the number you entered.

	If you run it with the `-s bits` flag, the program should shift the number to the left `bits` times. Except it doesn't.
	
	Right now, `shifted` is just set to `num`. There is a variable called `shift` that is automatically set when the program is run with the `-s` flag. Use that variable to shift `shifted` properly.
	
	Remember that you need to recompile your code before you test it by using `make`.
2. Once you've completed that, find the `TODO` block that says to uncomment about 30 lines. Uncomment those lines, and your program should no longer compile.


### Bit manipulations!

<aside class="sidenote">
### Running `manip` manually

After you compile your program with `make`, you can run it like any other compiled program: `./manip`. If you do so, the program will tell output simple help text detailing the possible arguments.

- `-h`: Print help text
- `-s`: Shift the entered number a specified number of bits left.
- `-i` :  Analyze an `int` (4 byte number).
- `-l` : Analyze a `long` (8 byte number).
- `-c` :  Analyze a `char` (1 byte number).

The arguments must be followed with a number to analyze.

Since this can be a little confusing, below are a couple of example run statements.  Make sure you understand these statements and know how to test various numbers and types.

- `./lab1 -s 2 -i 2342`:  This statement will test `2342` as an `int` and shift it to the right by 2 bits.
- `./lab1 -s 1 -c 2`:  This statement will test `2` as a `char` and shift it to the right 1 bit.
- `./lab1 -s 16 -l 64`:  This statement will test `64` as a `long` and shift it to the right 16 bits.

Make sure to recompile your program as you change your code.
</aside>

1. If you look at the error `make` throws now, you should see something about `symbols not found`. This is because the lines you uncommented used functions that had been **declared** in the `#include`d header file, but not **defined** anywhere. If your program were to try to call one of those functions, it would not be able to find a definition, and it would crash. So the compiler fails, and tells you your program won't work.

	We must tell the Makefile that we depend on other code to work properly, that we depend on another `.c` file. More accurately, our finished `manip` program depends on the compiled `manipFunctions.o` file---the compiled verison of `manipFunctions.c`.
	
	So add a new target for `manip`, just like you did `all`. This time, `manip` is a real file (and not a `.PHONY` one like `all` or `clean` or `test`), so when `make` tries to build `manip` for `all`, it will look at this new rule. Add a dependency to `manipFunctions.o`.
2.  Your program should now compile again when you `make`, but it thinks that the output for every bit-manip function in `manipFunctions.c` is `0`! That's because you haven't written them yet. 
	
	For each of the test in `manipFunctions.c`, use only the bitwise and Boolean operators listed above (i.e., **no `if-then` tests or `while` loops** are allowed) to write functions that return `1` if the input matches the condition given and `0` otherwise. You should be able to solve each in one line.

	- `int hasAZero(int num)`: At least one bit in `num` is a one.
	- `int hasAOne(int num)`: At least one bit in `num` is a zero.
	- `int leastSigHasAOne(int num)`: At least one bit in the *least* significant byte of `num` is a one.
	- `int mostSigHasAOne(int num)`: At least one bit in the *most* significant byte of `num` is a one.
	- `int mostSigBitInt(int num)`: The most significant bit of `num` is a one.
	- `int mostSigBitLong(long num)`: The most significant bit of `num` is a one.  Remember, in C `long`s are 8 bytes (64 bits) in length.
	- `int mostSigBitChar(char num)`: The most significant bit of `num` is a one.  Remember, in C `char`s are 1 byte (8 bits) in length.
3. Once you have completed your code (or while you are writing it), you can test it with `make test`. A correct program should show no output after `diff reference.txt output.txt`, which prints differences between the correct `reference.txt` and your program's `output.txt`.

	Note that this is not a guarantee of correctness, but a simple test we've provided to help you write your program. You should try manual values.

## The check-in
- 15pts: Does your finished program work?
    - Program compiles correctly 
    - Correctly shifts bits and prints out the result 
    - Functions are defined correctly
    - Student is able to show that they can run the program
    - The program is neat and follows the style guide
- 5pts: Is the cover-page correct?
    - Cover page is completely filled out
    - Boolean and bitwise operations
    - 3 byte data type question
    - Program organization question