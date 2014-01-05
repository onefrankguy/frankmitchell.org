<!--
title: Tuning in to AM radio for free
created: 5 January 2014 - 7:44 am
updated: 5 January 2014 - 12:35 pm
post: 5 January 2014
slug: crystal-radio
tags: radio
-->

<!--
He snakes a long green wire up into the branches of a corkscrew willow and tucks
himself into a fork in its roots. Flimsy cardboard supports a scatterd
collection of scavenged electronics. Penciled names and symbols match the parts
with the ones from his 200-in-1 Electronic Projects Kit. He does not know how
they work, but when he moves the aligator clip across the wire coils, he hears
Art Bell, coast to coast.

The antenna in a crystal radio converts the energy in the electromagnetic
radiation that reaches it into a small amount of AC current. Because the radio
has no external power source (like a battery) you want the conversion to be as
efficient as possible. Ideally, you'd use a tuned antenna. A half wave dipole
antenna tuned for 630 AM is about 743 feet long. Because getting a hold of that
much wire when you're ten years old is tricky, I used the longest wire I
had and stuck it up as high in that tree as I could climb.
-->

Pretend for a moment that you're sitting on the beach in Monterey, California
and you've got 1,486 feet of copper wire sticking straight up into the sky. You
put a balloon at the end of the wire to keep it up there, and you burried the
other end in the ground. This is your full wave dipole antenna, and it's going
to pick up 630 AM when KIDD broadcasts _Coast to Coast_.

But if you connect a pizoelectric earphone to your antenna, you won't hear a
thing. Your antenna's picking up both sides of that AM radio wave and the
positive and negative aspects are canceling each other out, resulting in zero
sound. What you need is a way to filter out half that signal, converting the
AC current to a pulsating DC one.

In old crystal radios, a galena crystal and a thin piece of wire formed a cat's
whisker detector. This is a Schottky diode, a semiconducting diode that opposes
the flow of current in one direction. They where sensitive to pressure and
vibration and had to be readjusted every time they were used. Since you're
sitting on a beach where there's probably a lot of people wondering around,
you'd better use a modern germanium diode instead. Go ahead a connect it in
series with your earphone, and you should be able to hear Art Bell.

Unfortunately, Art's not coming in too well, and you're getting a lot of choppy
audio on the line. That DC current still has radio frequency pulses from the
AM carrier on it, and because that earphone of yours has about 20,000 ohms of
inductance, a lot of the signal isn't making it through. Fortunately, we can fix
that with a bypass capacitor. Put a 0.001 microfarad capacitor in parallel with
your earphone and it'll clean up your audio signal.

Now that you've got a solid audio signal, you're probably hearing some hiss on
the line. The hissing is caused by high frequencies your earphone can't
reproduce. We can cut it out with a low-pass filter. Put a 47 kilo-ohm resistor
in parallel with your bypass capacitor and the hiss should vanish.


[]: http://www.amazon.com/All-About-Radio-Harry-Helms/dp/1878707043 "Harry Helms (Amazon): All About Ham Radio"
[]: http://www.hamradiolicenseexam.com/ "John W1AI (Ham Test Online): Online courses for the ham radio exams"
