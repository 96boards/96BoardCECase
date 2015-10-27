#96BoardCECase.scad
##Overview  

This is a quick case designed in OpenScad for 96Boards CE standard.  
There are lots of options most are generally set by true or false.  It 
can output a case for the normal size or the expanded size CE bosard.
It currently supports adding a UART board within the case.  And it allows 
you to expose the low or high speed connectors. 

The only thing you need to download is the 96BoardCECase.scad file, the
.stl files are 3D print file examples of what the cases could look like.  
Or if the sample cases are exactly what you need you can download them 
directly.

One of the cool things about the 96Boards CE project is that all of the
boards us the same pins for the Low Speed Expansion Connector so you can
plug any expansion board into any 96Board.  We can add the expansion board
here and make up custome case for that combination.

##Install the source code  
So to install 96BoardCECase.scad you need to do the following:

 Make sure you have the latest copy of OpenScad installed
**$ git clone https://github.com/96Boards/96BoardCECase.git**  
**$ $cd 96BoardCECase
 Start OpenSCAD and open the file 96BoardCECase.scad in the editor 

The code so far has been tested with a flat case,  a curved rectangular 
case and a overall curved case.

##License

This 96BoardCECase.scad is free software; you can redistribute it
and/or modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; version 2.0 of the
License.

This library is distributed in the hope that it will be useful, 
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU 
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public 
License along with this library; if not, write to the Free Software 
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA

