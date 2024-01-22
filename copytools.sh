# Identify clipboard tool
if command -v pbcopy &> /dev/null; then
  copy() { pbcopy }
  paste() { pbpaste }
elif command -v xsel &> /dev/null; then
  copy() { xsel -ib }
  paste() { xsel -ob }
else
  echo "It seems you don't have a supported clipboard tool!"
  return 1
fi

# Copy working directory
cpwd() {
  echo -n $(dirs) | copy && \
  echo -e "\e[1mCopied working directory!\e[0m"
}

# Copy file contents
cpfc() {
  filename=$(basename $1)
  cat $1 | copy && \
  echo -e "\e[1mCopied content of:\e[0m $filename"
}


# Copy filepath
cpfp() {
  filepath=$(realpath $1)
  echo $filepath | copy
  echo -e "\e[1mCopied the following to clipboard:\e[0m\n$filepath"
}


# Paste clipboard content to stdout
p() { paste }


# Execute clipboard content as command
pp() {
  echo -e "\e[1mClipboard content:\e[0m $(paste)"
  echo -en "\e[1mDo you want to execute this as a command? [Y/n]:\e[0m "
  local response=$(bash -c "read -n 1 response; echo \$response")
  if [ ! -z $response ]; then
    local RESPONSE=$response
  else
    local RESPONSE='Y'
  fi
  case $RESPONSE in
    [Yy])
      echo $(paste)
      if ! eval $(paste) 2>/dev/null; then
        echo "Not a valid command"
        return 1
      fi
      ;;
    [Nn])
      echo -e "\nNo action taken!"
      ;;
    *)
      echo -e "\nInvalid response!"
      return 1
      ;;
  esac
}

# Paste file to current location
pf() {
  FILENAME=$(basename $(paste))
  if [ -e $FILENAME ]; then
    echo -en "\e[1m$FILENAME already exists! Do you wish to overwrite? [Y/n]:\e[0m "
    local response=$(bash -c "read -n 1 response; echo \$response")
  fi
  if [ ! -z $response ]; then
    local RESPONSE=$response
  else
    local RESPONSE='Y'
  fi
  case $RESPONSE in
    [Yy]) 
        FILE=$(paste)
        cp -r $FILE . 2>/dev/null && \
        echo -e "\nSuccesfully pasted $FILENAME to current directory!" || \
        echo -e "\nSomething went wrong:" && \
        cp -r $FILE .
      ;;
    [Nn])
      echo -e "\nNo action taken!"
      ;;
    *)
      echo -e "\nInvalid response!"
      return 1
      ;;
  esac
}


# Move file to 
mvf() {
  FILENAME=$(basename $(paste))
  if [ -e $FILENAME ]; then
    echo -en "\e[1m$FILENAME already exists! Do you wish to overwrite? [Y/n]:\e[0m "
    local response=$(bash -c "read -n 1 response; echo \$response")
  fi
  if [ ! -z $response ]; then
    local RESPONSE=$response
  else
    local RESPONSE='Y'
  fi
  case $RESPONSE in
    [Yy]) 
        FILE=$(paste)
        mv -f $FILE . 2> /dev/null && \
        echo -e "\nSuccesfully moved $FILENAME to current directory!" || \
        echo -e "\nSomething went wrong"
      ;;
    [Nn])
      echo -e "\nNo action taken!"
      ;;
    *)
      echo -e "\nInvalid response!"
      return 1
      ;;
  esac
}
