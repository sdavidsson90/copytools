mvf() {
  if  mv -f $1 . 2> /dev/null ; then
  echo "success"
else
  echo "fail"
fi
}
