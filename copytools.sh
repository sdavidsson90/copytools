# ==========================================
# Identify clipboard tool
if command -v pbcopy &> /dev/null; then   # MacOS
  copy() { 
    pbcopy
  }
  paste() { 
    pbpaste
  }
elif command -v xsel &> /dev/null; then   # Linux
  copy() { 
    xsel -ib
  }
  paste() { 
    xsel -ob
  }
fi


# ==========================================
# Copy working directory
cpwd() {
  echo "$(pwd)/" | copy && \
  echo -e "\e[1mCopied working directory:\e[0m"
  paste
}


# ==========================================
# Copy filepath
cpfp() {
  IFS=$'\n'
  filepaths=""
  ignored=""
  for i in "$@"; do
    if [ -e "$i" ]; then
      file=$(realpath "$i")
      file=$(echo "$file\n")
      filepaths+=$(echo -e "\n$file")
    else
      ignored+=$(echo "$i \n")
    fi
  done
  echo -e "${filepaths[@]}"|copy
  if [ ! -z $filepaths ]; then
    echo -en "\e[1mCopied filepaths:\e[0m"
    echo $filepaths
  fi
  if [ ! -z $ignored ]; then
    echo -e "\n\e[1mInvalid input:\e[0m"
    for i in $ignored; do
      echo -e "$i \n"
    done
  fi
}


# ==========================================
# Copy file contents
cpfc() {
  cat "$@" | copy && \
  echo -en "\e[1mCopied content of: \e[0m"
  echo $@
}


# ==========================================
# Paste
p() { 
  echo $(paste)
}


# ==========================================
# Paste file to current location
pf() {
  filepaths="$(paste)"
  echo -e "\e[1mPasting files:\e[0m"
  for FILE in $(echo $filepaths); do
    FILENAME=$(basename "$FILE")
    echo -n "$FILE"
    if [ -e "$FILENAME" ]; then
      echo -en "\n  This file already exists! Do you wish to overwrite? [Y/n]:"
      local response=$(bash -c "read -n 1 response; echo \$response")
    fi
    if [ ! -z $response ]; then
      local RESPONSE=$response
    else
      local RESPONSE='Y'
    fi
    case $RESPONSE in
      [Yy])
        cp -r $FILE . 2>/dev/null && \
          echo " ✓" || \
          echo " ✘"
        ;;
      [Nn])
        echo " ✘"
        ;;
      *)
        echo -e "\nInvalid response!"
        return 1
        ;;
    esac
  done
}


# ==========================================
# Move file to current directory
mvf() {
  filepaths="$(paste)"
  echo -e "\e[1mMoving files:\e[0m"
  for FILE in $(echo $filepaths); do
    FILENAME=$(basename "$FILE")
    echo -n "$FILE"
    if [ -e "$FILENAME" ]; then
      echo -en "\n  This file already exists! Do you wish to overwrite? [Y/n]:"
      local response=$(bash -c "read -n 1 response; echo \$response")
    fi
    if [ ! -z $response ]; then
      local RESPONSE=$response
    else
      local RESPONSE='Y'
    fi
    case $RESPONSE in
      [Yy])
        cp -r $FILE . 2>/dev/null && \
        rm -rf $FILE && \
          echo " ✓" || \
          echo " ✘"
        ;;
      [Nn])
        echo " ✘"
        ;;
      *)
        echo -e "\nInvalid response!"
        return 1
        ;;
    esac
  done
}
