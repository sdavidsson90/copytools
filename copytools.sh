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
  echo -n "$PWD/" | copy
  echo -e "\e[1mCopied working directory:\e[0m"
  paste
}


# ==========================================
cpfp() {

  if [ -z "$1" ]; then
    echo "No arguments given!"
    return 1
  fi

  # Prepare the copying
  for i in "$@"; do
    if [ -e "$i" ]; then
      file_path+=$(realpath "$i")
      file_path+=" "
    else
      ignored+=$i
      ignored+=" "
    fi
  done

  # Print actions
  if [ ! -z "$file_path" ]; then
    echo "$file_path" | copy &&
    echo -e "\e[1mCopied filepaths:\e[0m"
    echo -n "$file_path" | tr ' ' '\n'

    #  Print newline before printing invalid input
    if [ -n "$ignored" ]; then
      echo ""
    fi
  fi

  if [ -n "$ignored" ]; then
    echo -e "\e[1mInvalid input:\e[0m"
    echo -n "$ignored" | tr ' ' '\n'
  fi

  unset file_path ignored
}


# ==========================================
# Copy file contents
cpfc() {
 
  # Only proceed if a target file is provided
  if [ -z "$1" ]; then
    echo "No arguments given!"
    return 1
  fi

  # Read in the file contents
  for i in "${@}"; do
    if ! file -Ib "$i" | grep 'binary' > /dev/null 2>&1; then
      file_name+="$i"
      file_name+=$'\n'
      file_contents+=$(cat "$i")
      file_contents+=$'\n'
    else
      ignored+="$i"
      ignored+=$'\n'
    fi
  done

  # file_contents=$(printf "%s" "$file_contents")

  # Do the copy action and verify the paths of the copied files
  if [ ! -z "$file_contents" ]; then
    printf "%s" "$file_contents" | copy
    echo -e "\e[1mCopied file contents of:\e[0m"
    printf "%s" "$file_name"
    
    # If both valid and invalid input were given; print newline 
    if [ -n "$ignored" ]; then
      echo -e " "
    fi
  fi
  
  # Print invalid inputs
  if [ -n "$ignored" ]; then
    echo -e "\e[1mInvalid input:\e[0m"
    printf "%s" "$ignored"
  fi

  unset file_contents file_name ignored
}


# ==========================================
# Paste
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
      ignored+="$i"
      ignored+=" "
    else
      # Print filename
      echo -n "$i"

      # Check if filename exists in this location.
      # If so; ask if the existing file should be replaced.
      if [ -e $(basename "$i") ]; then

        echo -e "\n  A file with this name already exists in this location!"
        echo -n "  Do you wish to overwrite? [Y/n]: "

          response=$(bash -c "read -n 1 response; echo -n \$response")
          
          if [ -z $response ]; then 
            response="Y"
          fi

          while [[ ! $response =~ ^[YyNn]$ ]]; do
            echo -en "\n  Invalid response! Try again! [Y/n]: "
            response=$(bash -c "read -n 1 response; echo -n \$response")

            # If input is 'enter' accept as 'Y'
            if [ -z "$response" ]; then 
              response="Y"
            fi
          done

          case $response in
            [Yy])
              cp "$i" . 2> /dev/null && echo " [✓]" || echo " [x]"
              echo ""
              ;;
            [Nn])
              echo " [x]"
              echo ""
              ;;
          esac

          unset response

        elif [ ! -e $(basename "$i") ]; then
        cp "$i" . 2> /dev/null && echo " [✓]" || echo " [x]"
      fi
    fi
  done
      
  if [ -n "$ignored" ]; then
    echo -e "\e[1mInvalid filepaths:\e[0m"
    echo "$ignored"
    unset ignored
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
      ignored+="$i"
      ignored+=" "
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

            # If input is 'enter' accept as 'Y'
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
      
  if [ -n "$ignored" ]; then
    echo -e "\e[1mInvalid filepaths:\e[0m"
    echo "$ignored"
    unset ignored
  fi
}

