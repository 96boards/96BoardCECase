#Things still  need to be done to 96BoardCECase.scad
##Overview  

I need to fix the 96Boards logo so that it can emboss the surface of a case.
The code for the logo is at the bottom of the file but not enabled yet.  I
tried to use it as vent holes but saw the error of that really rapidly, the
center of some letters fall out, duh.  So I need to set up the code to do
embossing only if you want the logo.

The other area of improvement is the screw holes, right now they assume a
tapered head screw and a hex nut at the bottom.  I want to making a nut on
the bottom optional and also make it work for non tapered head screws to
just have a cylinder to drop the screw into.  Anyway more options would be
nice.

As more mezzanine boards come out I want to add options to print cases that
will hold them as well.

As usual, patches are welcome.

