# ==========================================
# Identify clipboard tool
if command -v pbcopy &> /dev/null; then  # MacOS
  copy() { 
    pbcopy
  }
  paste() { 
    pbpaste
  }
elif command -v xsel &> /dev/null; then  # Linux (X11)
  copy() { 
    xsel -ib
  }
  paste() { 
    xsel -ob
  }
elif command -v wl-copy &> /dev/null; then  # Linux (Wayland)
  copy() { 
    wl-copy
  }
  paste() { 
    wl-paste
  }
fi


# ==========================================
# Copy working directory
cpwd() {
  echo "$PWD/" | copy
  echo -e "\e[1mCopied working directory:\e[0m"
  paste
}


# ==========================================
# Copy file paths
cpfp() {

  # If no arguments are given; stop and return error
  [ -z "$1" ] && echo "No target files provided!" && return 1

  # Gather file paths and invalid form input
  for i in "$@"; do
    if [ -e "$i" ]; then
      file_path+="$(realpath $i)"
      file_path+=" "
    else
      invalid+="$i"
    fi
  done

  # Do the copy action and print copied filepaths
  if [ -n "$file_path" ]; then
    echo -n "$file_path" | copy &&
    echo -e "\e[1mCopied filepaths:\e[0m"
    for i in "${file_path[@]}"; do
      echo "$i" | tr ' ' '\n'
    done

    # If both valid and invalid input are to be printed; print newline before invalid
    [ -n "$invalid" ] && echo ""
  fi

  # Print invalid inputs
  if [ -n "$invalid" ]; then
    echo -e "\e[1mInvalid input:\e[0m"
    for i in "${invalid[@]}"; do
      echo "$invalid" | tr ' ' '\n'
    done
  fi

  unset file_path invalid
}


# ==========================================
# Copy file contents
cpfc() {
 
  # If no arguments are given; stop and return error
  [ -z "$1" ] && echo "No target files provided!" && return 1

  # Read in the file contents
  for i in "${@}"; do
    if [ -e "$i" ]; then
      file_path+="$i"
      file_path+=$'\n'
      file_contents+=$(cat "$i")
      file_contents+=$'\n'
    else
      invalid+="$i"
      invalid+=$'\n'
    fi
  done

  # Do the copy action and print paths of copied files
  if [ ! -z "$file_path" ]; then
    printf "%s" "$file_contents" | copy
    echo -e "\e[1mCopied file contents of:\e[0m"
    printf "%s" "$file_path"
    
    # If both valid and invalid input were given; print newline 
    [ -n "$invalid" ] && echo ""
  fi
  
  # Print invalid inputs
  if [ -n "$invalid" ]; then
    echo -e "\e[1mInvalid input:\e[0m"
    printf "%s" "$invalid"
  fi

  unset file_contents file_path invalid
}


# ==========================================
# Paste clipboard content to stdout
alias p=paste


# ==========================================
# Paste file(s) to current directory
pf() {
  # Print header if clipboard contains a valid filepath
  for i in $(paste); do
    if [ -e "$i" ]; then
      echo -e "\e[1mPasting files:\e[0m"
      break
    fi
    echo "Could not find any valid filepaths in clipboard!"
    return 1
  done

  for i in $(paste); do 

    if [ ! -e "$i" ]; then
      invalid+="$i"
      invalid+=" "
    else
      # Print filename
      echo -n "$i"

      # Check if filename exists in this location.
      # If so; ask if the existing file should be replaced.
      if [ -e $(basename "$i") ]; then

        echo -e "\n  A file with this name already exists in this location!"
        echo -n "  Do you wish to overwrite? [Y/n]: "

          response=$(bash -c "read -n 1 response; echo -n \$response")
          
          if [ -z "$response" ]; then 
            response="Y"
          fi

          while [[ ! $response =~ ^[YyNn]$ ]]; do
            echo -en "\n  Invalid response! Try again! [Y/n]: "
            response=$(bash -c "read -n 1 response; echo -n \$response")
            # If input is 'enter' - accept as 'Y':
            if [ -z "$response" ]; then
              response="Y"
            fi
          done

          case "$response" in
            [Yy])
              cp -r "$i" . 2> /dev/null && echo " [✓]" || echo " [x]"
              echo ""
              ;;
            [Nn])
              echo " [x]"
              echo ""
              ;;
          esac

        elif [ ! -e $(basename "$i") ]; then
        cp -r "$i" . 2> /dev/null && echo " [✓]" || echo " [x]"
      fi
    fi
  done
      
  if [ -n "$invalid" ]; then
    echo -e "\e[1mInvalid filepaths:\e[0m"
    echo "$invalid"
    unset invalid
  fi

  }


# ==========================================
# Move file(s) to current directory
mvf() {

  # Print header if clipboard contains a valid filepath
  for i in $(paste); do
    if [ -e "$i" ]; then
      echo -e "\e[1mMoving files:\e[0m"
      break
    fi
    echo "Could not find any valid filepaths in clipboard!"
    return 1
  done

  for i in $(paste); do 

    if [ ! -e "$i" ]; then
      invalid+="$i"
      invalid+=" "
    else
      # Print filename
      echo -n "$i"

      # Check if filename exists in this location.
      # If so; ask if the existing file should be replaced.
      if [ -e $(basename "$i") ]; then

        echo -e "\n  A file with this name already exists in this location!"
        echo -n "  Do you wish to overwrite? [Y/n]: "

          response=$(bash -c "read -n 1 response; echo -n \$response")
          
          if [ -z "$response" ]; then 
            response="Y"
          fi

          while [[ ! $response =~ ^[YyNn]$ ]]; do
            echo -en "\n  Invalid response! Try again! [Y/n]: "
            response=$(bash -c "read -n 1 response; echo -n \$response")
            # If input is 'enter' - accept as 'Y':
            if [ -z "$response" ]; then
              response="Y"
            fi
          done

          case "$response" in
            [Yy])
              cp -r "$i" . 2> /dev/null && rm -rf "$i" && echo " [✓]" || echo " [x]"
              echo ""
              ;;
            [Nn])
              echo " [x]"
              echo ""
              ;;
          esac

        elif [ ! -e $(basename "$i") ]; then
        cp -r "$i" . 2> /dev/null && rm -rf "$i" && echo " [✓]" || echo " [x]"
      fi
    fi
  done
      
  if [ -n "$invalid" ]; then
    echo -e "\e[1mInvalid filepaths:\e[0m"
    echo "$invalid"
    unset invalid
  fi

  echo "" | copy
}
