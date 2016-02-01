---
title: Introduction to Information Representation
short: Information
week: 
- "1"
author: Ben Stolovitz
---

Computers are very different from humans<sup>[citation needed]</sup>. We've learned from experience that getting them to solve problems for us requires an extreme amount of luck and translation, and popular culture likes to attribute that to computers "thinking differently" from us. While that's certainly true, a lot of problems come from how we *store* information differently.

This guide explains how machines represent things, from the ground up, which is something we can't quite explain for human information[^biology]. First, we talk about the electrical signals we use for binary.

[^biology]: CS dept: 1, Bio: 0

## Binary

At their very cores, modern (digital) machines store **bits** of information in the form of an electrical signal: on or off, `HIGH` or `LOW`, `1` or `0`. This sort of **boolean** information---information that can only be one of two values---is useful for questions like "yes or no?", "shaken or stirred?", "Pawnee or Eagleton?", but not much else. Thankfully, we can use binary as a **number system**, just like decimal.

In order to *really* understand that, consider these two questions:

- What is the number 4?
- What is the number 42?

In the first case, the illuminating answer is very similar to the obvious one. `4` is a symbol we know to illustrate the concept of four items, just like the word `four` means the same thing.

In the second case, however, the interesting answer is a little more silly than the obvious one. `42` is two symbols: a `4` followed by a `2`. In this context, `4` *actually* means "four tens." It is in the tens place. `2` still means "two," or, "two ones," since it is in the ones place.

You may recall an equation like this from grade school:

$$42 = 4 \times 10 + 2 \times 1$$

There's a tacit understanding that each consecutive digit in a number, from right to left, represents the next "place": first the 1's place, then the 10's place, 100's, 1,000's, etc.

But where does this come from? You probably know offhand that we count in "base 10," and therein lies our answer. "Base 10" implies that we have 10 counting symbols: `0`, `1`, `2`, `3`, `4`, `5`, `6`, `7`, `8`, and `9`. After that, our numerical system is, by itself, incapable of representing larger numbers. Hence this **positional notation**, where each consecutive number represents a different "place."

### Positional Notation

Unlike Roman numerals or even tally marks, which both stipulate simple addition of consecutive numbers (e.g. \$XVII = X + V + I + I = 10 + 5 + 1 + 1 = 17\$) , each consecutive number (from right to left) represents a multiple of a certain "place," determined by the base you are counting in.

For example, in base 10, each "place" is an increasing power of 10: the number `452` represents two ones ($10^0$) plus five tens ($10^1$) plus four hundreds ($10^2$), because we have 10 symbols and cannot represent anything larger than 9 with just one number.

That same series of digits in base 6, then (to pick a random base), would be two ones ($6^0$), five *sixes* ($6^1$), and four *thirty-sixes* ($6^2$). This is because base 6 has *six* symbols, not 10, and *runs out of symbols* after 5. Because we are using positional notation, we therefore advance to the next place, which represents the next consecutive number.

Then apply this to binary---base 2. The number `1001` in base 2 represents the number we know of as `9` in base 10:

$$ 1001_2 = 1 \times 2^3 + 0 \times 2^2 + 0 \times 2^1 + 1 \times 2^0 = 9$$

This should lead you to a couple interesting conclusions:

- There must be `n` symbols for any base `n`. Base 2 has 2 symbols.
- Every place is exactly one greater than the maximum value of all the previous places combined: $100_{10}$ is one greater than $99_{10}$, and $1000_2$ is one greater than $111_2$.
- Shifting a number by adding or removing a place ($1,523 \leftrightarrow 15,230$) multiplies or divides it by the current base.
- It is tedious to count in base 2.

If any of these observations do not make sense, I suggest spending more time thinking about different bases and how counting works.

## Hexadecimal

Computer scientists have long known the tediousness of base 2. Simple numbers become very long: it takes 10 places to represent all the numbers less than $1000_{10}$! So most of the time when dealing with computer-numbers we write in **hexadecimal**---hex. 

Hexadecimal is base 16. Base 16 requires 16 symbols, so we take all the base 10 digits, 0-9, and add `A=10`, `B=11`, `C=12`, `D=13`, `E=14`, and `F=15`. Since the base is 16, each place is a power of 16: $100_{16} = 256_{10}$. Therefore, the number $1B_{16} = 27_{10}$.

We typically prefix hex numbers with `0x` to identify them, like `0x4a41`. You can convert any binary to hex by taking each block of 4 binary digits and finding the corresponding hex digit, starting from the right:

$$1 1010 1110 1001 1001 = 0x1AE99$$

## Ints and the things you're used to

Now that we've dispensed with the more abstract mathematics, reality comes into play. Consider why we use *binary* in computing: we only have two possible signals, `HIGH` and `LOW`. It is not physically possible to use any higher base.

We also run into another problem. How can we indicate when a number *ends*? In the human world, this is not a problem: we simply stop writing, make a new line, and write another number. However, this secretly introduces another symbol---some way of demarcating the end of a number. We do not have this extra symbol, unless we count in base 1, which is basically tally marks[^whynot]. Therefore, we assign limits to the size of our numbers.

[^whynot]: We *don't* do this because then it becomes very hard to read long numbers: we could theoretically use `LOW` as the "end" of our number, but then the computer would literally have to read memory until it reached such a `LOW` just to know the size of a number. This leads to all sorts of problems, especially if you understand the mechanics of Turing machines (take a "theory of computing" course if you are interested). One of them is that it would therefore take `n` operations to read the number `n`. Considering computers regularly need to work with numbers larger than a billion and our best ones only do about 3 billion operations per second, that's a problem.

This is the reason we have `int`s. `int`s store whole numbers in base 2 but have a maximum size[^minsize]. Java is more exacting: `int`s are 4 bytes (a **byte** is a 8 **bits**, digits of binary: $4 \times 8 = 32$ bits), whereas C `int`s are *at least* 2 bytes ($2 \times 8 = 16$ bits). If you want 4 bytes in C, you use a `long`.

[^minsize]: The C specification itself does not actually specify this size. It specifies a *minimum* size, i.e. `int`s need to be able to hold *at least* a certain number, but sometimes a machine makes `int`s larger. Using anything larger than the C specification's maximum number may therefore do different things on different machines, something we call **undefined behavior**. Do not make your programs do undefined things unless you know what you're doing.

## Signed, unsigned, and fixed point

We have two other non-digit symbols that we need to represent with our two symbols: the **negative sign** and the **decimal point**.

### Negativity

The simplest solution is to ignore negative numbers entirely. Don't store anything negative. That is what `unsigned` numbers do, in both Java and C: an `unsigned int` in Java is exactly what you would expect, and can represent all numbers from 0 to $2^{32}-1 = 4,294,967,295$[^obvious].

[^obvious]: Think a little more about positional notation if that doesn't make sense. What's the maximum number, in base 10, you can represent with 4 digits? Can you represent that as $10^{x}-1$?

This will not do, because sometimes we need to work with negative numbers. Several "quick fixes" come to mind: **biased representation**, where where you subtract an implied number `K` from any negative number, so an unsigned `0` becomes `-K`. This number `K` is usually half the maximum value, so that a number can be **equally biased**, with equal negative and positive numbers. This is not used in most circumstances, and neither is **sign-magnitude**, which uses the highest bit as a negative "flag"— `HIGH` and the number is negative, `LOW` and the number is positive[^why].

[^why]: People fought tooth and nail over this when computers were first getting started, arguing between sign-magnitude, two's complement, and an additional one's complement. Sign-magnitude was first out because it could not store the same range of values (a whole bit was dedicated solely to storing positive or negative, and you can eke out another value with the other two), and one's complement lost because it had two forms of the number `0`, like sign-magnitude. Two's complement only has one form of zero and is easier to do computation with, so it won the battle.

Instead, all modern computers use **two's complement** to represent signed numbers. If a number is `signed` rather than `unsigned` (by default, almost every number is `signed` in Java and C), the **most significant bit**---the binary digit in the largest place (the `1` in `1,000,000`)---represents a *negative version of itself*. For example, in traditional, unsigned binary:

$$ 110_2 = 1 \times 2^{2} + 1 \times 2^{1} + 0 \times 2^0 = 5 $$

In *two's complement*:

$$ 110_2 = 1 \times -2^{2} + 1 \times 2^{1} + 0 \times 2^0 = -1 $$

### Fixed-Point

Now what about decimals? If you're handling something like money, fixed-point notation works great. It's about as simple as you might expect.

In whole numbers, there is an implied decimal point at the end:

$$ 1,502 = 1,502.0 = 1 \times 10^3 + 5 \times 10^2 + 0 \times 10^1 + 2 \times 10^0 + 0 \times 10^{-1}$$

Note the last entry in the expanded form: $0 \times 10^{-1}$. Numbers after the decimal point work just like numbers before it in terms of positional notation: $0.51 = 0 \times 10^0 + 5 \times 10^{-1} + 1 \times 10^{-2}$.

So a fixed-point system just moves the implied decimal point over. Fixed-point numbers are not used much, but we describe fixed-point numbers using **Q notation**: a `Q`, followed by the number of pre-decimal point digits, followed by the number of post-decimal point digits. `Q1.15` holds one integer bit and 15 fractional bits. We will use this representation later in the semester.

There is very little native support for fixed-point numbers. 

## Floating Point

<aside class="sidenote">
### Floating Pointless

Floating-point numbers are extremely complicated, with special codes for `NaN` (not a number), infinity, and two forms of zero. Floats can also store numbers in **denormalized form**, a format that almost completely changes the specification you learn here.

They have at least 5 different **rounding modes**, are not transitive (`3.14 + (1e10 - 1e10) != (3.14 + 1e10) - 1e10`), have positive and negative zero, and quirks galore.

If that seems awesome and worth learning about, great! Take 361S or any Operating Systems/Computer Architecture course.

If that seems pedantic and confusing, don't worry. We only care that you know `float`s are scientific notation, how the memory for one is ordered and used, and that they can be imprecise at times.
</aside>

Fixed-point isn't very well supported because it has limited use. In math, you don't always know how many decimal points you want at any given time. The whole idea of **scientific notation** stems from debate on how to sensibly be able to represent `1,200,000,000` and `0.017`, multiply them, and make sense of how accurate the resultant number is. 

Rather than reinvent the wheel, we just went ahead and implemented scientific notation in binary. Given a certain number of bits, we assign some of them to be the **mantissa** (the "number" part of a scienfitically-notated number), and some to be the **exponent**. Then, we throw out everything we said about sensible representation in the section on negativity, add a **sign bit** to represent the negativity of the mantissa, bias the exponent, and throw them together:

$$ (-1)^{sign} \times mantissa \times 2^{exponent - bias} $$

The IEEE decides how `float`s can be implemented. The standard `float` has:

- 1 **sign** bit, followed by
- 8 **exponent** bits, followed by
- 23 **fractional** bits.

If you know scientific notation, the mantissa can *never* have a zero as its first number (e.g. `0.626e-6` is not valid scientific notation). Since their is only one alternative in binary, the `1`, all binary mantissas must start with a `1` (`1.000111e-100`). This is implied and is left out of the data, hence the name **fractional** bits, not "mantissa" bits. The mantissa for a `float` therefore actually holds 24 bits-worth of actual information.

## Text & ASCII

If you have actually gotten here, I suggest going to Chapter 7 of Chamberlain's textbook for more.
