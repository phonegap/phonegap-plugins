GapFile
==========

https://github.com/tonyhursh/gapfile

What it does:

Gives you single, simple function calls for:

Reading, writing, deleting, and appending files.
Reading, creating, and deleting directories.
Checking for the existence of a file.

For example, writing to a file is done like this:

GapFile.writeFile("/test.txt", "Hello, world!\n",writeSuccess,writeFail);

Or in a subdirectory:

GapFile.writeFile("/mydir/test.txt", "Hello, world!\n",writeSuccess,writeFail);

That's it. The other functions are similarly straightforward.

 