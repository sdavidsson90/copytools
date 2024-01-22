# COPY TOOLS

#### What problem does this solve?
These functions will allow you to copy something and drop it off somewehere else.

#### What functions are there?
- `cpwd`: copy working directory
- `cpfc`: copy file contents
- `cpfp`: copy file path
- `p`: paste clipboard content as string
- `pp`: execute clipboard content as a command
- `pfp`: paste file path

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
