# Coderunner

This is a perl implementation of a code runner. The perl script located at

```
coderunner/coderunner.pl
```

can take files as input and execute them with the correct interpreter.

Note that the files inputted into the script **require extensions** in order to
work.

# Usage

## Dependencies

You will need to install the JSON Package from CPAN for the script to work.

## With Vim

```vim
nnoremap (keys) (path to coderunner.pl) %:p
```
