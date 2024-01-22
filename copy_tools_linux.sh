# Copy working directory
cpwd() {
  printf $(dirs) | pbcopy
}


# Copy file contents
cpfc() {
  filename=$(basename $1)
  echo -e "\e[1mCopied content of:\e[0m $filename"
  cat $1 | pbcopy
}


# Copy filepath
cpfp() {
  filepath=$(realpath -z $1)
  echo -n $filepath | pbcopy
  echo -e "\e[1mCopied to clipboard:\e[0m $filepath"
}


# Paste as string
p() {
  echo -en "\e[1mClipboard content: \e[0m"
  content=$(pbpaste)
  if [ -z $content ]; then
    echo "[empty]"
  else
    echo $content
  fi
}


# Execute string in copybuffer as command
pp() {
  echo -e "\e[1mClipboard content:\e[0m $(pbpaste)"
  echo -en "\e[1mDo you want to execute this as a command? [Y/n]:\e[0m "
  local response=$(bash -c "read -n 1 response; echo \$response")
  if [ ! -z $response ]; then
    local RESPONSE=$response
  else
    local RESPONSE='Y'
  fi
  case $RESPONSE in
    [Yy])
      echo $(pbpaste)
      if ! eval $(pbpaste) 2>/dev/null; then
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


# Paste to directory
pfp() {
  FILENAME=$(basename $(pbpaste))
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
        FILE=$(pbpaste)
        cp -r $FILE . 2>/dev/null && \
        echo -e "\nPasted to current directory!" || \
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
