---
title: A Cricket
author: Ben Stolovitz
week: 3
assigned: 2016-02-10
due: 2016-02-17
---

## The idea

* This will be a toc
{:toc}

Crickets chirp at a rate proportional to external temperature: you can actually [calculate the temperature from the rate at which crickets chirp](https://en.wikipedia.org/wiki/Dolbear%27s_law) to within a degree or so. What with today's rapidly moving world, it's come time to build a digital cricket, so that we may do what nature does more precisely and accurately.

## The background

### Spec sheets

Every electrical component has a **specification sheet** (a **spec** sheet). It lists everything you'd want to know about that component, and then some. In our case, we're using the [TMP36](http://www.analog.com/media/en/technical-documentation/data-sheets/TMP35_36_37.pdf), a temperature sensor.

Pages 1 and 3 of the spec sheet have all the information you need to complete this assignment.

### The TMP36

The temperature sensor we are using, the TMP36, operates fairly simply. The circuit connection is essentially the same as a potentiometer. When a voltage is provided across the two outer pins (in the right orientation), the center pin produces an output voltage based on the temperature. 

![A thermistor with pins labeled](../img/tempsensor.png)

You must wire the temperature sensor in the correct way or it will get hot. With the pins *facing* you and the flat end pointed up, the pin on the far left is power, and the pin on the far right is ground. Attach the power pin to +5V and the ground pin to ground.

<aside class="warning">
The temperature sensor *will* burn you if you wire it incorrectly.
</aside>

The output voltage is independent of the supply voltage: it is a linear function of ambient temperature. At $25^{\circ} C$, the TMP36 outputs a specific voltage (written in Table 1 of the spec sheet), and as the temperature changes, the output voltage changes based on a **scale factor** ($mV/ ^{\circ}  C$, also in Table 1 of the spec sheet).

To get the temperature from a voltage, then, you could use the equation (solved out so it should only be useful to check your answers):

$$ T_C = 100 V_{measured} - 50 $$

where $T_C$ is temperature in $^{\circ}C$ and $V_{measured}$ is the sensor voltage in volts (remember, 1 V = 1000 mV).

### Analog Reference

In order to read the temperature output by our sensor, you need to read the voltage into your Arduino. You have experience with this: you used `analogRead()` to read a voltage from a potentiometer in an earlier assignment.

An `analogRead()` returns a number between `0` and `1023` that corresponds to a voltage. In the case of your potentiometer, the `1023` corresponded to $5V$. It turns out that this "upper limit voltage" can be changed. This **reference voltage**, on our Arduinos at least, can be one of two values: $5V$ or $1.1V$.

For our potentiometer, the standard reference voltage ($5V$) made sense because the output ranged from 0 to $5V$. For the temperature sensor, that is less true. Using the equation above, $1.1V$ corresponds to $60 ^{\circ} C$. That is well above the temperature of Wash U's classrooms (especially in winter), and a lower reference voltage gives us more resolution ($\frac{5V}{1024ticks} \approx .005 \frac{V}{tick}$ whereas $\frac{1.1V}{1024ticks} \approx .001 \frac{V}{tick}$), so it makes sense to use a lower reference voltage.

It's not fast enough to do rapidly in your program, but at the beginning of your program (in `setup()`), you can use `analogReference()` to [change the reference voltage to `INTERNAL`](https://www.arduino.cc/en/Reference/AnalogReference).

### Arrays and averages

#### Filtering

The output from your temperature sensor, while *accurate*, may not be particularly *precise*. It's noisy, and fluctuates. In order to obtain a sensible, stable value from the sensor, we need to **filter** the output.

One option is to build physical hardware to filter: the [RC filter](http://www.electronics-tutorials.ws/filter/filter_2.html) is one such filter, and would do fairly nicely if this were an electical engineering class. But we want to handle this in software, so we will use a very simple, [OK](http://www.analog.com/media/en/technical-documentation/dsp-book/dsp_book_Ch15.pdf) filter: a **rolling average**.

A rolling average filter takes a new data point, finds the mean of the $N$ most recent data points for some $N$, and outputs that as the filtered data point.

In mathematical speak:

$$ y_i = \frac{1}{N} \sum\limits_{j=0}^{N-1} x_{i-j} $$

It is only possible to do this if you store the $N$ most recent data points, and the easiest way to do this is with an **array**.

#### Arrays

Though the syntax is very similar to Java's, C arrays and Java arrays are somewhat different. They both are **zero-indexed** and accessed with square brackets (`puppies[0]` gives the *first* puppy in the array while `puppies[1]` gives the second), the declaration for each is slightly different and C does *not* **bounds check** (i.e., C arrays do not prevent you from accessing invalid indexes, like `6` for an array of size `3`).

You can easily declare and use arrays in C, almost identically to Java:

~~~ c
#define COUNT 20
int fibonaccis[COUNT]; // an array of ints!
void setup() {
	fibonaccis[0] = 1;
	fibonaccis[1] = 1;
	for(int i = 2; i < COUNT; i++) {
		fibonaccis[i] = fibonnacis[i - 1] + fibonaccis[i - 2];
	}
}
~~~

## The assignment

### The basic system

1. Wire an LED output to the digital output pin of your choice (avoiding digital output pins 0 and 1), include a series resistor, and attach it to ground (this is the same as the discrete LEDs we wired in studio). Make sure you can turn it on and off.
2. Connect the center, output pin of your temperature sensor to an analog pin. Then attach the power pin to `+5V` and the ground pin to `GND`. If you hold the pins of your temperature sensor towards you and point the flat notch up, the source pin is on the left (pin 1) and the ground pin is on the right (pin 3).

	Make sure you can `analogRead()` from it, even if you haven't set `analogReference()` yet.
3. Write delta time code to `analogRead()` the temperature at 4 Hz (4 times a second). For now, just `Serial.print()` the return value from `analogRead()`, without any conversion.
4. Set `analogReference()` to `INTERNAL`. This will change what each value of `analogRead()` corresponds to (`1023` will now correspond to $1.1V$, not $5V$), which will be important when you...
5. Convert the raw `analogRead()` value into a temperature. Mathematically this is a two step procedure, first converting the raw value into a voltage (i.e., understanding what voltage the temperature probe is generating given the A/D counts returned from `analogRead()`), then into a temperature from the [spec sheet for the TMP36](http://www.analog.com/media/en/technical-documentation/data-sheets/TMP35_36_37.pdf).

	The spec sheet provides a **scale factor** ($\frac{mV}{C}$) of how much output voltage changes for every degree Celsius and a base voltage that is output at $25^{\circ} C$. With that data point and the slope, you can create an equation that transforms voltage into temperature and vice versa. While the counts returned by `analogRead()` are of type `int`, you likely will want to use variables of type `float` to perform the computation and store the resulting temperature value.
 	While the above description is for a two step transformation, feel free to combine the two steps into a single mathematical expression that gives temperature (in degrees C) when provided a return value from `analogRead()`.

	Print out both the raw A/D counts and the converted temperature value until you are confident that your temperature is right.

### The filter

You should now be reading temperature several times per second and printing it out. However, it should be fluctuating a good bit: the raw signal is noisy.

To fix that, we will apply a simple a simple filter: a **rolling average**.
	
1. Define a constant at the top of your program called `FILTER_COUNTS` that specifies a number of values to store in the rolling average. A number between 5 and 10 should be reasonable[^hat].
2. Then create an array of size `FILTER_COUNTS` to store the `N` most recent data points (i.e., `N` equals `FILTER_COUNTS`). The simplest way to do this is by maintaining a count of the number of reads you do: whenever you read a temperature, save it to this array at index `count % FILTER_COUNTS`.

	For example:

		#define FILTER_COUNTS 4
		float temperatures[FILTER_COUNTS];
		int count = 0;
	
		void loop() {
			if(/* delta time code */) {
				readTemp();
				/* more delta time stuff */
			}
		}
		
		void readTemp() {
			int reading = analogRead(/* pin */);
			int temperature = /* some transform on `reading` */;
			temperatures[count % FILTER_COUNTS] = temperature;
			counts += 1;
		}

	If you update the array each time you read the temperature, its mean is the rolling average. 
3. Compute and print this rolling average alongside the raw (unfiltered) temperature. Is it more stable? Does it still respond to temperature changes?
4. Graph the temperature data (unfiltered and filtered) you get from your Arduino in your favorite graphing program. If you structure your output something like this, with commas separating each field of the data:

		24.12,22.65
		23.44,22.87
		24.04,23.13
		22.57,22.99
		21.21,22.76

	you can copy and paste your output into a text file, save it with the file extension `.csv` ("Comma Separated Values"), and open it directly in Excel.
	
	Generate a noticeable change (increase) in temperature by holding the temperature sensor and then letting it go. Make sure to graph both the raw values and the filtered values. Also, double check your temperatures to make sure they're reasonable.

[^hat]: Really I just pulled those numbers out of a hat. See what works.

### The cricket part

Now that your filtering is done, you can use this filtered temperature to make a blinking cricket.

1. [Dolbear's Law](https://en.wikipedia.org/wiki/Dolbear%27s_law) is a formula to calculate the temperature from the amount of cricket chirps in 60 seconds:

	$$ T_C = 10 + \left(\frac{N_{60} - 40}{7}\right)$$
	
	where $T_C$ is the temperature in Celsius and $N_{60}$ is the number of chirps in a minute.
	
	You can solve this in terms of chirps *per second*. By inverting it (1 / chirps per second) you get a period, *seconds per chirp*. If you convert this number into milliseconds per chirp, you can use this as the duration of a delta time iteration to flash your LED.
	
	Solve this equation to determine a period, a number that you can use in a separate delta time conditional to flash a cricket LED.
2. However, even with this number, flashing the LED is not that simple. You need to keep track of whether or not your LED is on (like with a [`boolean`](https://www.arduino.cc/en/Reference/BooleanVariables)), and then alternate between *two* intervals for this "flash" delta time loop:

	If the light is on, wait some time `BLINK_DURATION`, which should be around `200` milliseconds, then turn off, and if the light is off, wait for `period - BLINK_DURATION` and turn back on.
	
	Write the appropriate delta time code (separate from your temperature sampling code) to blink the LED based on temperature. Your program should now asynchronously measure temperature and output data to your PC while blinking the LED.
3. Make sure the blink rate is reasonable[^surprise].

[^surprise]: I was pretty amazed at my sensible-cricket-chirp detection capability, so maybe ask a Southerner to verify.

### Guidelines

1. Make sure to wire the temperature sensor correctly or you will burn yourself.

	The pins number from 1 to 3 left to right with the flat side up and the pins facing you. 
	
	1. Power
	2. Output
	3. Ground

	Your final circuit should look like this:

	![The final circuit](../img/circuit.png)

	Note that this picture has the LED connected to the Arduino pin and the resistor connected to ground.  Either order is fine, Arduino pin then LED then resistor then ground, or Arduino pin then resistor then LED then ground.

2. Don't use `delay()` *at all* in this lab. We will *penalize* you if you do. The delta timing alternative we use is an important concept, and if it is not crystal clear, try reading some more about it and working through examples.

	[Adafruit](https://learn.adafruit.com/multi-tasking-the-arduino-part-1/using-millis-for-timing) has a nice tutorial, as does [StackOverflow](http://electronics.stackexchange.com/a/67090). Adafruit takes some code from [the Arduino tutorial](https://www.arduino.cc/en/Tutorial/BlinkWithoutDelay). Work through some problems, try to see if you can understand the idea in a generic form.
3. Save all your math work (conversions of voltage to temperature, Dolbear's law, etc). It will be helpful for the cover sheet and for when your numbers aren't coming out right (trust me, they will be wrong the first time).
4. The easiest way to check your equations is by plugging in some test values: is the output sensible at 1V? 25 Celsius? Am I blinking at the right rate? Plug at least two values in to make sure everything's working.
5. Verify all your numbers again. Graph them. Are they changing as you hold your temperature sensor? Is the average within the range of the noise of your signal?

## The check-in

1. Open the `cover-page.txt` file in `Arduino/assignment3/` and fill it out.
2. Make *sure* your numbers make sense.
3. Commit all your code and graphs (make sure to add all the new files to your repo first).
4. Check out with a TA.

New files:

<section class="tree">

- `Arduino/`
	- `assignment3/`
		- `cover-page.txt`
		- `cricket/cricket.ino`
		- A graph of your temperature data (in Excel or something similar)

</section>

### The rubric

- 15pts: Did the lab they demoed work?
	- Is the circuit wired correctly?
	- Do they correctly read the temperature sensor?
	- Do they correctly filter the data?
	- Did they graph the data with a noticeable temperature change?
	- Did they use proper delta-time loops?
	- Is it easy to grade?
- 5pts: Is the cover page correct?
	- Cover page completely filled
	- Correctness --- Dolbear's law inversion
	- Correctness --- `analogRead` values
	- Correctness --- Temperature range and accuracy
