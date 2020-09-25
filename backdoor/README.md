# backdoor analysis

This example uses the Super Secure Safe (TM) IP version 2.0.

There has been some rumors on the internet about this version containing a
secret bypass code that allows the goverment to inspect all safes.

Here we use Yosys to formally disprove these rumors, because surely there cannot
be any truth to these allegations?

If there is a backdoor the `make` command will fail and you can find the backdoor
code using `make wave`.

## Files

The notable files are:

 * [safe.sv](safe.sv) The Super Secure Safe (TM) IP code
 * [tb.sv](tb.sv) The testbench driving the test
