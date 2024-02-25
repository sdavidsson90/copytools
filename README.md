# COPY TOOLS

#### What problem does this solve?
These functions will allow you to copy something and drop it off somewehere else. 

The idea is that you should not have to spell out the full path to a file in a single command, but navigate to the file, do the copy action, navigate to a desired location and do the paste action.

#### How would I do that?
- `cpfp`: copy file path
- `pf`: paste file to current working directory
- `mvf`: move file to current working directory

#### Additional functions
- `cpwd`: copy working directory
- `cpfc`: copy file contents
- `p`: paste clipboard content to stdout
- `px`: execute clipboard content as a command

#### How do I use them? 
Assuming that $LOCATION is the location of the script on your system, add this line to your `.bashrc`/`.zshrc`:

```
source $LOCATION/copytools.sh
```

### Compatibility
This shell script is compatible with:
- Operating systems: 
    - MacOS
    - Linux desktops with X11 (headless Linux servers are not supported)
- Shells: 
    - Bash
    - ZSH
