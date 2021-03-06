<!--
title: Learning how a transmit filter works
created: 15 May 2014 - 7:06 pm
updated: 14 June 2014 - 4:14 pm
publish: 25 May 2014
slug: transmit-filter
tags: building, radio
-->

<script src="/js/d3.min.js" charset="utf-8"></script>

The first practical circuit you build in [_The Electronics of Radio_][book] is a
transmit filter. By practical, I mean the kind of circuit you could pull out of
one design and drop into another. Something that fits in a black box. Here's
what the transmit filter in the [NorCal 40A][] transceiver looks like.

<img class="game art" width="640px" height"640px"
     src="/images/norcal-40a-transmit-filter-left-to-right.jpg"
     alt="A close up view of the assembled transmit filter in the NorCal 40A transceiver, looking over the edge of the case and across the circuit board.",
   title="A close up view of the assembled transmit filter in the NorCal 40A transceiver, looking over the edge of the case and across the circuit board." />

From left to right those components are a 4.7 pF disc capacitor, a 100 pF disc
capacitor, a hand wound 3.14 uH inductor, and a 50 pF variable capacitor. The
schematic for them shows how they fit together electrically.

<img class="game art" width="658px" height"253px"
     src="/images/norcal-40a-transmit-filter.png"
     alt="An input signal (P1) feeds into a 4.7 pF coupling capacitor and then into the output signal (P2). A 100 pF capacitor, variable 50 pF capacitor, and 3.14 uH inductor sit in parallel between the coupling capacitor and ground.",
   title="An input signal (P1) feeds into a 4.7 pF coupling capacitor and then into the output signal (P2). A 100 pF capacitor, variable 50 pF capacitor, and 3.14 uH inductor sit in parallel between the coupling capacitor and ground." />

## What's a filter for? ##

What's the point of a filter in a transmitter anyway? At its most basic, a
transmitter consists of four parts. An antenna to radiate a signal,
an oscillator to generate a signal, a power source to drive the oscillator,
and a key to turn the power on and off.

The frequency the oscillator resonates at determines the frequency the
transmitter broadcasts on. Most oscillators are made of quartz, which provides
nice stable frequencies when you excite it with electrons. The problem with
quartz is that it's so stable, it doesn't give you much tuning range. If your
oscillator is a 7.114 MHz quartz crystal, you're pretty much stuck transmitting
on 7.114 MHz. Some radios, like the [Rockmite II][rm40], are designed to be
"rock bound" and operate on just one frequency.

The crystal oscillator in the NorCal 40A operates at 4.9150 MHz. This is known
as the local oscillator or LO. Since 4.9 MHz isn't in the 40 meter amateur radio
band, we need to mix in a second signal to get things into the 7 MHz range. By
making that second signal tunable, we can allow the radio to transmit over a
range of frequencies.

That second signal comes from the variable frequency oscillator or VFO. The one
in the NorCal 40A operates at 2.105 MHz. It's got a bandwidth of about 40 kHz,
which means you can tune it up or down by 20 kHz on either side. Mixing the LO's
4.9 MHz signal with the VFO's 2.1 MHz signal gives us the variable 7 MHz signal
we want.

Signal mixing is known as heterodyning, and like most things that sound like they
herald the dawn of Skynet, it has a down side. Not only does mixing signals get
you their product, it gets you their difference as well. So we get the 7 MHz
signal we want, but we also get a 2.8 MHz signal we don't want. And that's where
the transmit filter comes in. Filters are used to remove unwanted signals.

## Making a minimal viable filter ##

You can make the worlds smallest filter by putting a capacitor and an inductor in
parallel. This is known as an LC circuit, or a tuned circuit, and it stores
electrical energy through oscillation.

<img class="game art" width="510px" height"208px"
     src="/images/norcal-40a-transmit-filter-band-pass.png"
     alt="An input signal (P1) feeds into an output signal (P2). A 150 pF capacitor and 3.14 uH inductor sit in parallel between the output signal and ground.",
   title="An input signal (P1) feeds into an output signal (P2). A 150 pF capacitor and 3.14 uH inductor sit in parallel between the output signal and ground." />

A capacitor stores energy in an electric field. So if you connect a charged
capacitor across an inductor, current will start to flow from the capacitor
to the inductor and build up a magnetic field in the inductor. But the current
doesn't stop once the charge on the capacitor is gone. Because inductors resist
changes in current, the capacitor will begin to charge back up, extracting
energy from the magnetic field in the inductor. Back and forth it goes, from
electric field to magnetic field, swapping polarity each time, and forming
an oscillator.

You can calculate the frequency an LC circuit oscillates at if you know the
inductance in henries and capacitance in farads of the components in it.
Multiply the inductance by the capacitance and take the square root. Multiply
that result by two pi and invert it.

<p class="math">&fnof; =
<span class="fraction">
<span class="fup">1</span>
<span class="bar">/</span>
<span class="fdn">2&pi;
  <span class="radical">&radic;</span>
  <span class="radicand">LC</span>
</span>
</span>
</p>

The resulting frequency is in hertz, and it's that tuned circuit's resonant
frequency. Because capacitors block low-frequency signals and inductors block
high-frequency signals, a tuned circuit will only let signals at its resonate
frequency through. Filters that behave like this are known as band-pass filters.

## Functions in filter land ##

The tuned circuit in the transmit filter of the NorCal 40A has a 100 pF
capacitor, a 50 pF capacitor, and a 3.14 uH inductor. Because the two capacitors
are in parallel, we can sum their values and pretend we're working with a 150 pF
capacitor. By plugging these values into the formula for resonate frequency, we
can figure out where the circuit peaks.

<p class="math">7.33 MHz &asymp;
<span class="fraction">
<span class="fup">1</span>
<span class="bar">/</span>
<span class="fdn">2&pi;
  <span class="radical">&radic;</span>
  <span class="radicand">(3.14 &times; 10<sup>-6</sup>) &sdot; (150 &times; 10<sup>-12</sup>)</span>
</span>
</span>
</p>

The peak of the filter lands just past the edge of the 40 meter band at 7.33 MHz.
That's good because it means the 7 MHz signal generated by the mixer will pass
through the filter. But what about the 2.8 MHz signal we don't want? How well
does this filter remove that unwanted signal? To answer that, we have to look
at the filter's transmission loss.

Transmission loss is the ratio of the voltage that a circuit puts out to the
voltage the circuit takes in. Here's the function to calculate the transmission
loss for an inductor and capacitor in parallel.

<p class="math"><span class="fraction">
<span class="fup">V<sub>out</sub><sup>2</sup></span>
<span class="bar">/</span>
<span class="fdn">V<sub>in</sub><sup>2</sup></span>
</span> = <span class="fraction">
<span class="fup">&omega;<sup>2</sup>L<sup>2</sup></span>
<span class="bar">/</span>
<span class="fdn">R<sup>2</sup>(1 - &omega;<sup>2</sup>LC)<sup>2</sup> + &omega;<sup>2</sup>L<sup>2</sup></span>
</span>
</p>

There are two variables in that function we don't know. One is R, the input
resistance of the filter in ohms. The other is &omega; (pronounced "omega"),
the input frequency to the filter in radians per second. We can figure out the
input resistance by looking at the circuit's input. The transmit filter in the
NorCal 40A is fed by a Philip's SA602AN mixer. Digging through the data sheet
for the mixer, we find that its output resistance is 1500 ohms. Which means the
input resistance to our filter will also be 1500 ohms.

We know what the input frequency to our filter is, it's 2.8 MHz. We can convert
hertz to radians per second by multiplying by two pi.

<p class="math">17592919 rad/s &asymp; 2&pi; &sdot; 2800000</p>

Now we know enough to figure out how good our filter is at rejecting a 2.8 MHz
signal. We can take the formula for transmission loss and  plug in 1500 ohms for
R, 3.14 &times; 10<sup>-6</sup> henries for L, 150 &times; 10<sup>-12</sup>
farads for C, and 17592919 radians per second for &omega;.

<p class="math"><span class="fraction">
<span class="fup">17592919<sup>2</sup> &sdot; 3.14e-6<sup>2</sup></span>
<span class="bar">/</span>
<span class="fdn">1500<sup>2</sup> &sdot; (1 - 12566371<sup>2</sup> &sdot; 3.14e-6 &sdot; 150e-12)<sup>2</sup> + 17592919<sup>2</sup> &sdot; 3.14e-6<sup>2</sup></span>
</p>

Note that I'm being a little fast and loose with my notation here. Scientific e
notation is usually reserved for calculators and programming languages, but I
wanted to fit everything on one line.

Crunching through those numbers, we find our filter has a transmission loss
of 0.0431 volts at 2.8 MHz. Transmission loss is usually expressed in decibels,
which are a logarithmic scale where minus three decibels corresponds to a loss
of half the voltage. We can convert volts to decibels by taking the base ten
logarithm of the voltage and multiplying by twenty.

<p class="math">-27 dB &asymp; 20 &sdot; log<sub>10</sub>(0.0431)</p>

So our filter has a transmission loss of 27 dB at 2.8 MHz. In general, any
frequency with a loss of 40 dB or more falls into what's known as the stop band,
the part where frequencies are rejected. Any frequency with a loss of zero to
3 dB is in the pass band, the part where frequencies are accepted. The range in
between the pass band and the stop band is called the skirt.

Here's a chart of our filter's transmission loss for frequencies between 1 MHz
and 15 MHz.

<div id="band-pass-chart" class="chart"></div>
<script type="text/javascript">
"use strict";

var minX = 1
  , maxX = 15
  , minY = -70
  , maxY = 0
  , i = 0
  , data = []
for (i = 1; i <= maxX; i += 0.1) {
  data.push(i.toFixed(1))
}

var w = 500
  , h = 500
  , margin = 50
  , y = d3.scale.linear().domain([minY, maxY]).range([h - margin, 0 + margin])
  , x = d3.scale.linear().domain([minX, maxX]).range([0 + margin, w - margin])
  , L = 0.00000314
  , C = 150 * 0.000000000001
  , R = 1500

var gain = function (mhz) {
  var hz = mhz * 1000000
  var w = hz * 2 * Math.PI
  var w2 = w * w
  var t = 1 - w2 * L * C
  var t2 = t * t
  var vo = w2 * L * L
  var vi = R * R * t2 + vo
  var v = Math.sqrt(vo / vi)
  var db = 20 * (Math.log(v) / Math.log(10))
  return db
}

var g = d3.select('#band-pass-chart')
  .append('svg:svg')
  .attr('width', '100%')
  .attr('height', '33em')
  .attr('viewBox', '0 0 '+w+' '+h+'')

var line = d3.svg.line()
  .x(function(d, i) { return x(d) })
  .y(function(d) { return y(gain(d)) })

var xAxis = d3.svg.axis().scale(x).orient('bottom')
  .tickValues([1, 3, 5, 7, 9, 11, 13, 15])
  .tickFormat(function(d, i) { return Math.round(d)+' MHz' })

var yAxis = d3.svg.axis().scale(y).orient('left')
  .tickValues([0, -10, -20, -30, -40, -50, -60, -70])
  .tickFormat(function(d, i) { return d+' dB' })

g.append('svg:g')
  .attr('class', 'y axis')
  .attr('transform', 'translate('+margin+',0)')
  .call(yAxis)

g.append('svg:g')
  .attr('class', 'x axis')
  .attr('transform', 'translate(0,'+(h - margin)+')')
  .call(xAxis)

g.append('svg:path')
  .attr('style', 'stroke: deeppink;')
  .attr('d', line(data))

g.append('svg:line')
  .attr('style', 'stroke: darkgray;')
  .attr('x1', x(2.8))
  .attr('y1', y(minY))
  .attr('x2', x(2.8))
  .attr('y2', y(maxY))

g.append('svg:line')
  .attr('style', 'stroke: darkgray;')
  .attr('x1', x(minX))
  .attr('y1', y(-40))
  .attr('x2', x(maxX))
  .attr('y2', y(-40))
</script>

See the vertical line at 2.8 MHz and the horizontal line at -40 dB?  We want our
filter's transmission loss curve to fall below that intersection point, because
that will put the 2.8 MHz signal we don't want in our filter's stop band.

## Chaining filters together ##

To fix our filter, we need to add about 13 dB of cut off at 2.8 MHz to push it
into the stop band. One way to get more loss out of filter is to stick several
of them together in series. We know that capacitors block low-frequency signals,
so we can stick a capacitor in series with our band-pass circuit and use that
as an additional level of filtering.

<img class="game art" width="363px" height"253px"
     src="/images/norcal-40a-transmit-filter-high-pass.png"
     alt="An input signal (P1) feeds into a 4.7 pF capacitor and then into the output signal (P2). A 1500 ohm resistor sits in parallel between the capacitor and ground.",
   title="An input signal (P1) feeds into a 4.7 pF capacitor and then into the output signal (P2). A 1500 ohm resistor sits in parallel between the capacitor and ground." />

The capacitor will block low-frequency signals and let high-frequency ones
through. This kind of circuit is know as a RC circuit, or high-pass filter.
We can find its peak frequency in hertz by multiplying its capacitance in
farads by its resistance in ohms, multiplying that by two pi, and taking the
inverse.

<p class="math">&fnof; =
<span class="fraction">
<span class="fup">1</span>
<span class="bar">/</span>
<span class="fdn">2&pi; &sdot; RC</span>
</span>
</p>

Since we know the input resistance to our band-pass filter is 1500 ohms, we'll
use that as the resistance in our high-pass filter. We can calculate the peak
of our high-pass filter by plugging in 4.7 pF for C and 1500 ohms for R.

<p class="math">22.6 MHz =
<span class="fraction">
<span class="fup">1</span>
<span class="bar">/</span>
<span class="fdn">2&pi; &sdot; 1500 &sdot; 0.0000000000047</span>
</span>
</p>

22.6 MHz is far away from the 7 MHz signal we care about, which is good, since
it means we'll get good loss at lower frequencies. But how much loss will we
get? Here's the formula for the transmission loss of a RC circuit.

<p class="math"><span class="fraction">
<span class="fup">V<sub>out</sub><sup>2</sup></span>
<span class="bar">/</span>
<span class="fdn">V<sub>in</sub><sup>2</sup></span>
</span> = <span class="fraction">
<span class="fup">&omega;<sup>2</sup>R<sup>2</sup>C<sup>2</sup></span>
<span class="bar">/</span>
<span class="fdn">1 + &omega;<sup>2</sup>R<sup>2</sup>C<sup>2</sup></span>
</span>
</p>

We already know that 2.8 MHz is 17592919 rad/s, so we can use that for &omega;.
Plugging in 1500 for R and 3.14 pF for C, we can figure out how good our
high-pass filter is at rejecting the unwanted signal.

<p class="math">0.1231 &asymp;
<span class="fraction">
<span class="fup">17592919<sup>2</sup> &sdot; 1500<sup>2</sup> &sdot; 0.0000000000047<sup>2</sup></span>
<span class="bar">/</span>
<span class="fdn">1 + 17592919<sup>2</sup> &sdot; 1500<sup>2</sup> &sdot; 0.0000000000047<sup>2</sup></span>
</span>
</p>

Taking the base ten logarithm of the loss factor and multiplying by twenty gives
us the loss in decibels.

<p class="math">-18 dB &asymp; 10 &sdot; log<sub>10</sub>(0.1231)</p>

Eighteen decibels of loss is plenty. If we graph the transmission loss equation,
we can get a feel for how well it does across the rest of the band. The chart
below goes from 1 MHz to 15 MHz.

<div id="high-pass-chart" class="chart"></div>
<script type="text/javascript">
"use strict";

var minX = 1
  , maxX = 15
  , minY = -70
  , maxY = 0
  , i = 0
  , data = []
for (i = 1; i <= maxX; i += 0.1) {
  data.push(i.toFixed(1))
}

var w = 500
  , h = 500
  , margin = 50
  , y = d3.scale.linear().domain([minY, maxY]).range([h - margin, 0 + margin])
  , x = d3.scale.linear().domain([minX, maxX]).range([0 + margin, w - margin])
  , C = 4.7e-12
  , R = 1500

var gain = function (mhz) {
  var hz = mhz * 1000000
  var w = hz * 2 * Math.PI
  var vo = w * w * R * R * C * C
  var vi = 1 + vo
  var v = Math.sqrt(vo / vi)
  var db = 20 * (Math.log(v) / Math.log(10))
  return db
}

var g = d3.select('#high-pass-chart')
  .append('svg:svg')
  .attr('width', '100%')
  .attr('height', '33em')
  .attr('viewBox', '0 0 '+w+' '+h+'')

var line = d3.svg.line()
  .x(function(d, i) { return x(d) })
  .y(function(d) { return y(gain(d)) })

var xAxis = d3.svg.axis().scale(x).orient('bottom')
  .tickValues([1, 3, 5, 7, 9, 11, 13, 15])
  .tickFormat(function(d, i) { return Math.round(d)+' MHz' })

var yAxis = d3.svg.axis().scale(y).orient('left')
  .tickValues([0, -10, -20, -30, -40, -50, -60, -70])
  .tickFormat(function(d, i) { return d+' dB' })

g.append('svg:g')
  .attr('class', 'y axis')
  .attr('transform', 'translate('+margin+',0)')
  .call(yAxis)

g.append('svg:g')
  .attr('class', 'x axis')
  .attr('transform', 'translate(0,'+(h - margin)+')')
  .call(xAxis)

g.append('svg:path')
  .attr('style', 'stroke: deeppink;')
  .attr('d', line(data))
</script>

That doesn't look very promising for 7 MHz. If we crunch through the numbers,
we find a loss of about 11 dB. Remember that three decibels of loss corresponds
to a half loss of power. Because decibels is a logarithmic scale, you can
convert decibels to a loss multiplier by dividing by ten and raising ten to the
power of that result.

<p class="math">P = 10<sup>(dB / 10)</sup></p>

Interestingly, this formula explains why -40 dB was chosen as the cut off
point for a filter's stop band. It corresponds to a 10,000 times reduction in
power.  That's like taking a 60 watt light bulb and reducing it to the 6
milliwatt smoldering ember on the end of a match stick.

Plugging in 11 for dB, we can figure out how much power we're going to lose
at 7 MHz with the addition of our high-pass filter.

<p class="math">13 &asymp; 10<sup>(11 / 10)</sup></p>

Thirteen times! That seems like a lot. But there's a side effect to having
this capacitor in our filter. In addition to functioning as a high-pass filter,
it also functions as a coupling capacitor. It's going to remove any DC signals
we might be getting from the mixer and only let AC signals pass through. That's
good, because our band-pass filter was designed with AC signals in mind.

The chart below shows what happens to our band-pass filter after we add the
coupling capacitor to it. It looks very similar to the original band-pass filter
plot, just with all the values shifted down. That's actually another reason to
work with transmission loss in decibels instead of volts. You can compute the
total transmission loss of a series of chained filters by summing their
individual losses in decibels.

<div id="ideal-pass-chart" class="chart"></div>
<script type="text/javascript">
"use strict";

var minX = 1
  , maxX = 15
  , minY = -70
  , maxY = 0
  , i = 0
  , data = []
for (i = 1; i <= maxX; i += 0.1) {
  data.push(i.toFixed(1))
}

var w = 500
  , h = 500
  , margin = 50
  , y = d3.scale.linear().domain([minY, maxY]).range([h - margin, 0 + margin])
  , x = d3.scale.linear().domain([minX, maxX]).range([0 + margin, w - margin])
  , L = 3.14e-6
  , C = 150e-12
  , C37 = 4.7e-12
  , R = 1500

var c37gain = function (mhz) {
  var hz = mhz * 1000000
  var w = hz * 2 * Math.PI
  var vo = w * w * R * R * C37 * C37
  var vi = 1 + vo
  var v = Math.sqrt(vo / vi)
  var db = 20 * (Math.log(v) / Math.log(10))
  return db
}

var gain = function (mhz) {
  var hz = mhz * 1000000
  var w = hz * 2 * Math.PI
  var w2 = w * w
  var t = 1 - w2 * L * C
  var t2 = t * t
  var vo = w2 * L * L
  var vi = R * R * t2 + vo
  var v = Math.sqrt(vo / vi)
  var db = 20 * (Math.log(v) / Math.log(10))
  return c37gain(mhz) + db
}

var g = d3.select('#ideal-pass-chart')
  .append('svg:svg')
  .attr('width', '100%')
  .attr('height', '33em')
  .attr('viewBox', '0 0 '+w+' '+h+'')

var line = d3.svg.line()
  .x(function(d, i) { return x(d) })
  .y(function(d) { return y(gain(d)) })

var xAxis = d3.svg.axis().scale(x).orient('bottom')
  .tickValues([1, 3, 5, 7, 9, 11, 13, 15])
  .tickFormat(function(d, i) { return Math.round(d)+' MHz' })

var yAxis = d3.svg.axis().scale(y).orient('left')
  .tickValues([0, -10, -20, -30, -40, -50, -60, -70])
  .tickFormat(function(d, i) { return d+' dB' })

g.append('svg:g')
  .attr('class', 'y axis')
  .attr('transform', 'translate('+margin+',0)')
  .call(yAxis)

g.append('svg:g')
  .attr('class', 'x axis')
  .attr('transform', 'translate(0,'+(h - margin)+')')
  .call(xAxis)

g.append('svg:path')
  .attr('style', 'stroke: deeppink;')
  .attr('d', line(data))

g.append('svg:line')
  .attr('style', 'stroke: darkgray;')
  .attr('x1', x(2.8))
  .attr('y1', y(minY))
  .attr('x2', x(2.8))
  .attr('y2', y(maxY))

g.append('svg:line')
  .attr('style', 'stroke: darkgray;')
  .attr('x1', x(minX))
  .attr('y1', y(-40))
  .attr('x2', x(maxX))
  .attr('y2', y(-40))
</script>

Looking at the intersection of the vertical line at 2.8 MHz and the horizontal
line at -40 dB, we can see that we've pushed our unwanted signal into the stop
band. Yay!

There's just one question left to answer. If we can do all this mathematical
analysis, solving for losses at specific frequencies, why does the NorCal 40A
include a 50 pF variable capacitor in its band-pass filter design? Why not just
crunch the numbers and make it a fixed value?

## All the math is wrong! ##

It turns out that none of this math models reality at all. It's all based on
idealized circuits. When you buy a capacitor, even though it says 100 pF on it,
it's not actually 100 pF. There's some tolerance level. It might be 100 pF
plus or minus 10%. That means it's really got a range of 90 pF to 110 pF.

There's a point in Dave Richards's build of the [VK3YE Micro 40 DSB Transceiver][aa7ee]
where he says

> Pin 1 of Peter's LM386 is connected to ground via a 47uF cap and
> a 33 ohm resistor. I didn't have a 47uF, but I did have a 33uF. Given the wide
> tolerances of electrolytics, it probably doesn't matter much but I substituted
> a 33uF cap and a 47 ohm resistor.

When I first read that I was pretty shocked. What do you mean you dropped 14 uF
of capacitance? This is electronics. It's a practical application of physics.
It's science! You can't just go swapping values in and out and hoping you arrive
at something similar.

But as it turns out, you can. And you must. Because math is exact and the real
world is not. For example, take a look at the inductor I wound for the transmit
filter.

<img class="game art" width="640px" height"640px"
     src="/images/norcal-40a-transmit-filter-inductor.jpg"
     alt="A close up of the inductor on the NorCal 40A circuit board. There's a bump on the top where the wire doesn't lay flat and the turns aren't spaced evenly. The real world is a messy, imperfect, and beautiful place.",
   title="A close up of the inductor on the NorCal 40A circuit board. There's a bump on the top where the wire doesn't lay flat and the turns aren't spaced evenly. The real world is a messy, imperfect, and beautiful place." />

That's twenty-eight turns of No. 28 AWG magnet wire on a T37-2 core. Toroid
cores have an constant that lets you compute their inductance based on the
number of turns. Multiply the constant by the number of turns squared and divide
the result by a thousand to get the inductance in micro henries.

<p class="math">L =
<span class="fraction">
<span class="fup">A<sub>L</sub> &sdot; turns<sup>2</sup></span>
<span class="bar">/</span>
<span class="fdn">1000</span>
</span>
</p>

The constant for a T37-2 core is 4 &plusmn; 5%. Plugging that in for
A<sub>L</sub> and 28 for the number of turns, we can figure out the inductance.

<p class="math">3.14 uH &asymp;
<span class="fraction">
<span class="fup">4 &sdot; 28<sup>2</sup></span>
<span class="bar">/</span>
<span class="fdn">1000</span>
</span>
</p>

But it's not really 3.14 uH, because the math still assumes that the turns
are spaced evenly and the wire lies flat against the core. Looking at the
picture again, you can see that's not the case. I used [the chopstick trick][w6bul]
by Jim Bullington, W6BUL, to wind that toroid, and I still ended up having to
wind and rewind it several times before I was happy with the result.

The chart below is the band-pass filter for the NorCal 40A, but this time all
the part tolerances have been taken into consideration. You can use the sliders
below the chart to push the values around and watch the plot change.

<div id="real-pass-chart" class="chart"></div>
<div style="display: block; margin-bottom: 1.5em;">
  <label style="display: inline-block; width: 7em;">C<sub>37</sub> = <span id="c37-value">4.70</span> pF</label>
  <input style="display: inline-block;" id="c37-input" type="range" min="4.23" max="5.17" step="0.01" value="4.70"></input>
</div>
<div style="display: block; margin-bottom: 1.5em;">
  <label style="display: inline-block; width: 7em;">C<sub>38</sub> = <span id="c38-value">100</span> pF</label>
  <input style="display: inline-block;" id="c38-input" type="range" min="95" max="105" step="1" value="100"></input>
</div>
<div style="display: block; margin-bottom: 1.5em;">
  <label style="display: inline-block; width: 7em;">C<sub>39</sub> = <span id="c39-value">29</span> pF</label>
  <input style="display: inline-block;" id="c39-input" type="range" min="8" max="50" step="1" value="29"></input>
</div>
<div style="display: block; margin-bottom: 1.5em;">
  <label style="display: inline-block; width: 7em;">L<sub>6</sub> = <span id="l6-value">3.14</span> uH</label>
  <input style="display: inline-block;" id="l6-input" type="range" min="2.92" max="3.36" step="0.01" value="3.14"></input>
</div>
<script type="text/javascript">
"use strict";

var minX = 1
  , maxX = 15
  , minY = -70
  , maxY = 0
  , i = 0
  , data = []
for (i = 1; i <= maxX; i += 0.1) {
  data.push(i.toFixed(1))
}

var w = 500
  , h = 500
  , margin = 50
  , y = d3.scale.linear().domain([minY, maxY]).range([h - margin, 0 + margin])
  , x = d3.scale.linear().domain([minX, maxX]).range([0 + margin, w - margin])
  , L = 3.14e-6
  , C = 129e-12
  , C37 = 4.7e-12
  , R = 1500

var c37gain = function (mhz) {
  var hz = mhz * 1000000
  var w = hz * 2 * Math.PI
  var vo = w * w * R * R * C37 * C37
  var vi = 1 + vo
  var v = Math.sqrt(vo / vi)
  var db = 20 * (Math.log(v) / Math.log(10))
  return db
}

var gain = function (mhz) {
  var hz = mhz * 1000000
  var w = hz * 2 * Math.PI
  var w2 = w * w
  var t = 1 - w2 * L * C
  var t2 = t * t
  var vo = w2 * L * L
  var vi = R * R * t2 + vo
  var v = Math.sqrt(vo / vi)
  var db = 20 * (Math.log(v) / Math.log(10))
  return c37gain(mhz) + db
}

var g = d3.select('#real-pass-chart')
  .append('svg:svg')
  .attr('width', '100%')
  .attr('height', '33em')
  .attr('viewBox', '0 0 '+w+' '+h+'')

var line = d3.svg.line()
  .x(function(d, i) { return x(d) })
  .y(function(d) { return y(gain(d)) })

var xAxis = d3.svg.axis().scale(x).orient('bottom')
  .tickValues([1, 3, 5, 7, 9, 11, 13, 15])
  .tickFormat(function(d, i) { return Math.round(d)+' MHz' })

var yAxis = d3.svg.axis().scale(y).orient('left')
  .tickValues([0, -10, -20, -30, -40, -50, -60, -70])
  .tickFormat(function(d, i) { return d+' dB' })

g.append('svg:g')
  .attr('class', 'y axis')
  .attr('transform', 'translate('+margin+',0)')
  .call(yAxis)

g.append('svg:g')
  .attr('class', 'x axis')
  .attr('transform', 'translate(0,'+(h - margin)+')')
  .call(xAxis)

g.append('svg:path')
  .attr('class', 'reference')
  .attr('style', 'stroke: darkgray;')
  .attr('d', line(data))

g.append('svg:path')
  .attr('class', 'line')
  .attr('style', 'stroke: deeppink;')
  .attr('d', line(data))

function $(id) {
  return document.getElementById(id)
}

function cap(id) {
  return parseFloat($(''+id+'-input').value, 10)
}

function plot () {
  g.selectAll('path.line')
    .data([data])
    .attr('d', line)
  g.selectAll('path.base')
    .data([data])
    .attr('d', baseLine)
}


$('c37-input').oninput = function () {
  $('c37-value').innerHTML = parseFloat(this.value, 10).toFixed(2)
  C = (cap('c38') + cap('c39')) * 0.000000000001
  C37 = cap('c37') * 0.000000000001
  plot()
}

$('c38-input').oninput = function () {
  $('c38-value').innerHTML = parseInt(this.value)
  C = (cap('c38') + cap('c39')) * 0.000000000001
  C37 = cap('c37') * 0.000000000001
  plot()
}

$('c39-input').oninput = function () {
  $('c39-value').innerHTML = parseInt(this.value)
  C = (cap('c38') + cap('c39')) * 0.000000000001
  C37 = cap('c37') * 0.000000000001
  plot()
}

$('l6-input').oninput = function () {
  $('l6-value').innerHTML = parseFloat(this.value, 10).toFixed(2)
  L = parseFloat(this.value, 10) * 0.000001
  plot()
}
</script>

There's a reference plot in gray representing the behavior of the band-pass
filter with exact ideal values. Notice that you can push C<sub>38</sub> and
L<sub>6</sub> all the way to the left and there's still enough swing in
C<sub>39</sub> to bring the filter's behavior back in line with the ideal.
Likewise if you push them all the way to the right, you've got enough
variability to correct for that too.

So even though we can't model reality exactly with math, we can model it well
enough to get a feel for the behavior of a circuit. We can use it to predict
new behavior relative to existing behavior when we add new components or
substitute in new values. And we can use it get a deeper understanding of how
a radio does what it does.

Finally, here's one more shot of the assembled transmit filter. I really
like how the light caught the bottom edge of the case and highlighted the
bumpy metal texture.

<img class="game art" width="640px" height"1044px"
     src="/images/norcal-40a-case-texture.jpg"
     alt="A offset overview of the assembled transmit filter in the NorCal 40A. The light catches the bottom edge of the case and shows off the bumps in the texture.",
   title="A offset overview of the assembled transmit filter in the NorCal 40A. The light catches the bottom edge of the case and shows off the bumps in the texture." />

## Where we go from here ##

This is the second part in a multi-part series about building the NorCal
40A transceiver. Links to the other parts are below.

1. [Building my first HF radio][norcal-40a]
2. Learning how a transmit filter works
3. [Regulating voltage with junk box parts][voltage-regulator]

For the curious, photos where taken with an [iPhone 5][], cropped and resized
with [Acorn][], and compressed with [ImageOptim][]. Schematics where drawn with
[circuitikz][] and graphs where created with [D3][].


[book]: http://cambridge.org/us/academic/subjects/engineering/rf-and-microwave-engineering/electronics-radio "David Rutledge (Cambridge University Press): The Electronics of Radio"
[NorCal 40A]: http://www.fix.net/~jparker/wilderness/nc40a.htm "Bob Dyer, K6KK (Wilderness Radio): The NorCal 40A"
[rm40]: http://www.qrpme.com/?p=product&id=RM4 "Rex Harper, W1REX (QRPme): Rockmite ][ 40m Transceiver"
[aa7ee]: http://aa7ee.wordpress.com/2013/10/19/the-vk3ye-micro-40-dsb-transceiver/ "Dave Richards, AA7EE (Wordpress): The VK3YE Micro 40 DSB Transceiver"
[w6bul]: http://www.youtube.com/watch?v=GT44U10WqRA "Jim Bullington, W6BUL (YouTube): A Meditation On Winding Toroids - K6JEB"
[norcal-40a]: /2014/05/norcal-40a "Frank Mitchell: Building my first HF radio"
[voltage-regulator]: /2014/06/voltage-regulator "Frank Mitchell: Regulating voltage with junk box parts"
[iPhone 5]: http://support.apple.com/kb/sp655 "Various (Apple): iPhone 5 Technical Specification"
[Acorn]: http://flyingmeat.com/acorn/ "Gus &amp; Kirstin Mueller (Flying Meat): Acorn - The image editor for humans"
[ImageOptim]: http://imageoptim.com/ "@pornel (ImageOptim): Image compression made easy for Mac OS X"
[circuitikz]: http://www.ctan.org/pkg/circuitikz "Massimo Redaelli (CTAN): circuitikz - Draw electrical networks with TikZ"
[D3]: http://d3js.org/ "Mike Bostock (D3): Data-Driven Documents"
