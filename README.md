# A Calculator in Assembly

When the program is invoked with a valid operation and 2 valid signed long integers, the result of the corresponding operation is printed to the terminal. An error message is printed if the operation cannot be performed, that is, when it would result in an operating system exception. There is only one line of output and that line only contains a single long integer or an error message.

The four valid operations are:

- +: add
- -: subtract
- *: multiply
- /: divide

The first argument is always a single character (which might or might not be a valid operation) and the 2nd and 3rd argument are valid long integers.

A sample of the output from the program looks something like this:

```
$ ./calculator - 50 51
-1
```