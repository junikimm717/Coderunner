# Coderunner

This is a perl implementation of a script executor
(AKA a "run" button). The perl script located at

```
coderunner/coderunner.pl
```
can take files as input and execute them with the correct interpreter.

Note that the files inputted into the script **require extensions** in order to
work.

# Languages

All languages executable through the code runner should be scripts or capable
of being run like scripts (such as haskell). You can check all of the supported
languages in coderunner/language.json

# Usage

## Dependencies

You will need to install the JSON Package from CPAN for the script to work.

## With Vim

The intention of this script is that it is coupled with a vim binding.

```vim
nnoremap (keys) (path to coderunner.pl) %:p
```
