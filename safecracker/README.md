# safe cracker

This example uses the Super Secure Safe (TM) IP version 1.0.

Your company bought the highly expensive IP but due to GDPR concerns all emails
older than 24h are deleted. When you come back from the weekend you have forgotten
the passcode to the IP, and testing all the 65 535 possible combinations will
take too long.

You learn that Yosys [can be used to break into safes](https://www.youtube.com/watch?v=kli2CLd3cuY)
and decide to give it a try.

Using the `make` command Yosys will try to find a code path that results
in that the safe is unlocked. Upon completion you can use `make wave` to
see the successful path and thus the code.

For reference there is also `make modelsim` and `make riviera` to do the same
using randomized input.

## Files

The notable files are:

 * [safe.sv](safe.sv) The Super Secure Safe (TM) IP code
 * [tb.sv](tb.sv) The testbench driving the test
