# COPY TOOLS

#### What problem does this solve?
These functions will allow you to copy something and drop it off somewehere else.

#### What functions are there?
- `cpwd`: copy working directory
- `cpfc`: copy file contents
- `cpfp`: copy file path
- `p`: paste from clipboard as string
- `pp`: paste string from clipboard and execute as command
- `pfp`: paste file path

#### How do I use them? 
Assuming that $LOCATION is the location of the script on your system
Add this line to your `.bashrc`/`.zshrc`:

```
source $LOCATION/copytools.sh
```

### Compatibility
This is a simple shell script compatible with:
- ZSH
- Bash
- MacOS
- Linux Desktops (using X11) - not headless servers
