# COBOL-reverse-shell
Reverse shell for GnuCOBOL, written in the IBM COBOL standard.
This is essentially a COBOL wrapper for the C system library, to which the GnuCOBOL runtime allows easy access.

Compile on the command line with

  <tt>cobc -x -std=IBM reverseshell.cob</tt>
  
The flag -x will create an executable "reverseshell", and the flag -std=IBM makes sure we use IBM COBOL as the language (the different COBOL dialects are obscenely incompatible with one another, so it is likely this code will not run with any other).

The <tt>sockaddr</tt> structure for the connect call is built according to the BSD/macOS convention, with fields <tt>sin_len</tt>, <tt>sin_family</tt>, <tt>sin_port</tt> and <tt>sin_addr</tt>. Since one cannot define single byte values in IBM COBOL, I combine <tt>sin_len</tt> and <tt>sin_family</tt> into a two-byte entry called <tt>sin_len_sin_family</tt>. It must have the value 0x0002.
The IP address and port of the listener are hard-coded as decimal values in the variables

  <tt>sin_port</tt> as 1234,
  
  <tt>sin_addr</tt> as 167772173.
  
Replace these by your own values. Note that you do not have to reverse the byte order to Big Endian (as is required by the socket call), because this is done automatically when GnuCOBOL compiles the program. This also mean we can assign

  <tt>sin_len_sin_family</tt> as 2

since this will be byte-swapped by IBM COBOL and thus be put in the correct order for the <tt>sockaddr</tt> structure.

It is interesting to see the corresponding C-code. This can be obtained by

  <tt>cobc -C -std=IBM reverseshell.cob</tt>
  
which creates three files,

   <tt>reverseshell.c.h</tt>     global variables
  
   <tt>reverseshell.c.l.h</tt>   local variables
  
   <tt>reverseshell.c</tt>       program as a library
  
These files are particularly helpful when debugging function calls to the C-library.

Of course this is a silly idea. :)

