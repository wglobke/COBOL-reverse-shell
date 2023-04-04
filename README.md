# COBOL-reverse-shell
Reverse shell for GnuCOBOL, written in the IBM COBOL standard.
This is essentially a COBOL wrapper for the C system library, to which the GnuCOBOL runtime allows easy access.

Compile on the command line with

  <tt>cobc -x -std=IBM reverseshell.cob</tt>
  
The flag -x will create an executable "reverseshell", and the flag -std=IBM makes sure we use IBM COBOL as the language (the different COBOL dialects

The IP address and port of the listener are hard-coded as decimal values in the variables

  <tt>sin_port</tt> as 1234,
  
  sin_addr as 167772173.
  
Replace these by your own values. Note that you do not have to reverse the byte order to Big Endian (as is required by the socket call), because this is done automatically when GnuCOBOL compiles the program.

It is interesting to see the corresponding C-code, which can be obtained by

  cobc -C -std=IBM reverseshell.cob
  
which creates three files,

  reverseshell.c.h    # global variables
  
  reverseshell.c.l.h  # local variables
  
  reverseshell.c      # program as a library
  
These files are particularly helpful when debugging function calls to the C-library.
