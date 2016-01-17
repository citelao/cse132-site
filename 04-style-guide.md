---
title: Style Guide
author: Ron Cytron, Josh Gelbard, and Ben Stolovitz
permalink: style-guide/
---

Getting the _computer_ to understand your program is no guarantee that _people_ will be able to follow it. Just as you would edit an English composition, you should spend time revising a computer program to make it elegant and readable. The following guidelines will help you write programs that are easy to read and modify. 

**Beginning with Assignment 1, the CSE 132 TAs will expect your assignments to conform to these style and documentation conventions.** A large portion of your lab grade is based on style, so don't assume that it's good enough to just get your program running. Read this Style Guide carefully, and let us know if you have any questions.

-  **Fill out** `cover-page.txt`.
	
	If you make any general assumptions regarding the problem to be solved or about the kinds of inputs your program will accept, be sure to these assumptions in a separate paragraph (labeled `ASSUMPTIONS:`) at the bottom of the cover page. Specific assumptions regarding a particular method should be stated in the header comment for that method.

	Deviations from the assignment should be listed as well. Keep in mind that any significant deviations should also be cleared with the instructor in advance. 
-  **Write a header comment on every file you create**.

	It should have: 

    *   Your name (and the names of any people you worked with--see the CSE 132 collaboration policy)
    *   Your lab section (e.g., `Lab E`)
    *   Your email address
    *   The name of the assignment (e.g., `CSE 132 Assignment 4`)
    *   The name of the file (e.g., `Vector.java`)
    *   A brief description of the purpose of the sketch or class defined in that file. If you have more than one class in a file, headers for subsequent classes in a file need only the brief description of the purpose of the class.
-  **Describe all methods** if they are not clear from their name. Err on the side of over-documenting.
	
	In all comments, _be brief and informative._ Since the CSE 132 TAs are already familiar with the assignment, please don't repeat the details of the assignment. Instead, communicate your approach to solving the problem.

	This must be in Javadoc form if writing Java code, which Eclipse can help you write: after typing the method header, go to the line immediately above the method header and type the characters `/**` and then press `enter`. Eclipse will set up a method comment with the parameter names.

	As an example:

		/**
		 * Deposits the given amount into the account.
		 * REQUIRES: The given amount is positive.
		 * @param amount the dollar amount to deposit
		 * @return the new balance
		 */
		 
		 public int deposit(int amount) {
		 	if (amount < 0)
		 		throw new IllegalArgumentException("positive 
		 		amount required");
		 	balance += amount;
		 	return balance;
		 } 

-  **Choose meaningful names** for all variables, parameters, classes, and methods.

	Use complete words instead of abbreviations. For example, use `width` instead of `w`. However, if an assignment specifies a particular name, please don't choose a different one.
-  **Use named constants** instead of sprinkling numbers throughout your code. 

	For example, if a paint program has a standard brush size of 5 pixels, don't just put the number 5 all over the code. Instead, define and use a constant at the top of the class, like this:

    `static final int BRUSH_SIZE = 5; // in Java`
    
    or

    `const int SCALE = 3; // in Arduino C`

    `#define SCALE 3 // alternative Arduino C form` 

    This not only makes it easier to read the program, but also simplifies changing the values later because you only have to make the change in one place, where the constant is defined. 

    Rule of thumb: if a constant is used more than once, give it a name.
-  **Keep your program clear.** Your program's logic should be simple. Avoid "clever" tricks that save a line of code at the expense of clarity.

	Be especially careful to keep boolean expressions simple. This will ensure readability and will help you avoid logic errors. Also, remember to simply return the value of a boolean expression, rather than testing it in a conditional statement that returns true or false:

		// GOOD:
		return (height >= level);
		
		// BAD:
		if (height >= level) {
			return true;
		} else {
			return false;
		}

-  **Avoid duplicating code** by writing an appropriately named procedure and calling it where neeeded.
-  Follow standard formatting conventions.

	TODO format me.

<dl>
<dt>**Capitalization:**</dt>
<dd>
<dl>
<dt>variables and method names</dt>
<dd>the first letter is lower case, with the first letter of each subsequent word capitalized  
for example, `int caloriesFromFat = 18;`</dd>
<dt>class names</dt>
<dd>the start of each word is capitalized  
for example, `public class DirectionVector {`</dd>
<dt>constants</dt>
<dd>the entire name is capitalized  
for example, `public static final double PUPIL_FRACTION = 4;`</dd>
</dl>
</dd>
<dt>**Indentation:**</dt>
<dd>
<dl>
<dt>braces</dt>
<dd>the open brace `{` goes at the end of the line before the start of the code block. 
the close brace goes on its own line, indented to match the beginning of the line containing the corresponding open brace (an exception is "else" which goes on the same line as the closing brace for the corresponding "if", so the closing brace for the "if" doesn't appear on its own line)</dd>
<dt>code inside braces</dt>
<dd>indent one level for each level of curly braces ({})</dd>
<dt>code inside consequents</dt>
<dd>use curly braces and indent one level for consequents in conditional statements (braces may be omitted if there is only one statement in a consequent, but some editors expect the braces in order to do automatic indentation properly)</dd>
<dt>continued lines</dt>
<dd>when a statement continues across two or more lines, indent the second and remaining lines an equal amount past the start of the first line of the statement. See the example.</dd>
example:
```
public static boolean withdraw (int amount) {
   	if (balance < amount) {
      	return false;
  	} else {
      	balance = balance - amount;
      	System.out.println("Withdrawl of $" + 
      			amount + " successful, leaving $" 
      			+ balance + ".");
      	return true;
   	}
}
```

**TIP:** Eclipse will help correct your indentation. Select the section of the file you want to correct, and then choose "correct indentation" from the "source" menu.

</dd>

<dt>**Order of variables and methods within a class definition:**</dt>

<dd>

<dl>

<dt>constants</dt>

<dd>if you define any constants, they should go first, with public constants before private ones</dd>

<dt>class variables (static variables)</dt>

<dd>if you define any static variables, put them immediately after the constants, listing the public variables first</dd>

<dt>instance variables</dt>

<dd>should follow the class variables, with the public ones first</dd>

<dt>constructors</dt>

<dd>should precede all other methods</dd>

<dt>public accessors</dt>

<dd>should immediately follow the constructors</dd>

<dt>other methods, public and private</dt>

<dd>can be listed in any logical order, with related methods near each other</dd>

<dt>the `toString` method</dt>

<dd>should be last so people can find it quickly</dd>

</dl>

</dd>

</dl>

- **Use brief inline comments** whenever the meaning of the code is not immediately obvious. For example, inline comments can be useful to summarize cases in a conditional expression.

		if (xPosition < xLeft) // left of box
			...
		else if (xPosition > xLeft + width) // right of box
			...
		else if (yPosition < yBottom) // below box
			...
		else // inside or above box
			...


-  **... but avoid them if possible**. Write **self-documenting code** to avoid the need for inline comments. 

The comment in the following example adds no information and should be omitted since it just wastes the reader's time:

`int rectangleWidth = 5; //the rectangle has a width of 5`

-  When a CSE 132 assignment asks for test cases, **present your test cases clearly and methodically.**
    *   Test cases should be ordered logically, preferably in the same order as the code being tested.
    *   Whenever possible, choose test cases whose expected output be quickly computed in your head (without the need for a calculator).
    *   When there are only a few possible inputs, test them all. Otherwise, choose test cases that exercise all branches of the code (for example, one test case that satisfies the condition in an if statement and a second test case that doesn't satisfy the condition).
    *   Be thorough. Pretend that you are an adversary trying to "trick" the program into giving the wrong answer. For example, test cases should include zero or negative values even if the "normal" case is a positive number. However, you are not obligated to test inputs that violate your stated assumptions.
-  **Be professional.** Use the same care in preparing your code as you would for any writing assignment. Avoid jokes in your code, slang terms, crude comments, etc.

-  **Use common sense.** Remember that the CSE 132 style guide is only a guide. Your primary concern should be making sure that others can read and understand the text of your program. If you think an additional comment or particular organization will get your ideas across more effectively, do it. However, if you are considering deviating significantly from the guidelines or if you are in doubt about something, discuss it with us first.