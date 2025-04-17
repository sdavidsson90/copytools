# copytools.sh

These functions will allow you to copy something and drop it off somewhere else.

The idea is that you should not have to spell out the full path(s) of a file in a single command, but navigate to the file, do the copy action, navigate to a desired location and do the paste action.

The beauty is that the functions work with the system clipboard. A copy action done in the command line will be accessible in a GUI app (and vice versa).

#### List of available functions

- `cpwd`: copy working directory
- `cpfc`: copy file contents
- `cpfp`: copy file path
- `p`: print clipboard content to stdout
- `pf`: paste file to current working directory
- `mvf`: move file to current working directory

#### Setup

Assuming that `$LOCATION` is the location of the script on your system, add this line to your `.bashrc`/`.zshrc`:

```
source $LOCATION/copytools.sh
```

### Compatibility

Bash and ZSH on either MacOS or Linux.
Headless Linux servers are not supported.
