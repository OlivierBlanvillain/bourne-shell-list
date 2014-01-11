__number_of_underscores() {
  echo $@ | awk -F_ '{ print NF-1 }'
}

__desugar_function_1() {
  if [ $(__number_of_underscores $@) -eq 1 ]; then
    echo $@ | sed 's/_1\?/${x}/g'
  else
    echo $@ | sed 's/_1/${x}/g'
  fi
}

__desugar_function_2() {
  if [ $(__number_of_underscores $@) -eq 2 ]; then
    echo $@ | sed '
      s/_1/${x}/g
      s/_2/${y}/g
      s/_/${x}/
      s/_/${y}/'
  else
    echo $@ | sed '
      s/_1/${x}/g
      s/_2/${y}/g'
  fi
}

__swap_args() {
  __desugar_function_2 $@ | sed -e '
    s/${x}/${z}/g
    s/${y}/${x}/g
    s/${z}/${y}/g'
}

# Constructs a list from arguments
# def list: List[String]
list() {
  for i in "$@"; do echo "$i"; done
}

# Selects an element by its index in the list.
# def apply(n: Int): A
apply() {
  for x in $(seq 0 $1); do read x; done
  echo "$x"
}

# Tests whether this list contains a given value as an element.
# def contains(elem: String): Boolean
contains() {
  while read x; do
    test "$x" = "$1" && return 0
  done
  return 1
}

# Counts the number of elements in the list which satisfy a predicate.
# def count(p: String => Boolean): Int
count() {
  i=0
  f=$(__desugar_function_1 $@)
  while read x; do
    eval test $f && i=$(expr $i + 1)
  done
  echo $i
}

# Selects all elements except first `n` ones.
# def drop(n: Int): List[String]
drop() {
  tail -n$1
}

# Drops longest prefix of elements that satisfy a predicate.
# def dropwhile(pred: String => Boolean): List[String]
dropwhile() {
  f=$(__desugar_function_1 $@)
  while read x; do
    eval test $f || break
  done
  echo $x
  cat
}

# Tests whether a predicate holds for some of the elements of this list.
# def exists(pred: String => Boolean): Boolean
exists() {
  f=$(__desugar_function_1 $@)
  while read x; do
    eval test $f && return 0
  done
  return 1
}

# Selects all elements of this list which satisfy a predicate.
# def filter(pred: String => Boolean): List[String]
filter() {
  f=$(__desugar_function_1 $@)
  while read x; do
    eval test $f && echo $x
  done
}

# Selects all elements of this list which do not satisfy a predicate.
# def filternot(pred: String => Boolean): List[String]
filternot() {
  f=$(__desugar_function_1 $@)
  while read x; do
    eval test $f || echo $x
  done
}

# Finds the first element of the list satisfying a predicate.
# def find(pred: String => Boolean): String
find() {
  f=$(__desugar_function_1 $@)
  while read x; do
    eval test $f && echo $x && break
  done
}

# Folds the elements of this list using the specified associative binary
# operator.
# def fold(z: String, op: (String, String) => String): String
fold() {
  foldleft $@
}

# Applies a binary operator to a start value and all elements of this list,
# going left to right.
# def foldleft(z: String, op: (String, String) => String): String
foldleft() {
  x=$1
  shift 1
  f=$(__desugar_function_2 $@)
  while read y; do
    x=$(eval $f)
  done
  echo $x
}

# Applies a binary operator to all elements of this list and a start value,
# going right to left.
# def foldright(z: String, op: (String, String) => String): String
foldright() {
  reverse | foldleft $(__swap_args $@)
}

# Tests whether a predicate holds for all elements of this list.
# def forall(pred: String => Boolean): Boolean
forall() {
  f=$(__desugar_function_1 $@)
  while read x; do
    ! eval test $f && return 1
  done
  return 0
}

# Selects the first element of this list.
# Uses /usr/bin/head when called with arguments.
# def head: String
head() {
  if [ $# -eq 0 ]; then
    read x
    echo "$x"
  else
    /usr/bin/head $@
  fi
}

# Selects all elements except the last.
# def init: List[String]
init() {
  sed '$d'
}

# Tests whether the list is empty.
# def isempty: Boolean
isempty() {
  ! read x
}

# Selects the last element.
# def last: String
last() {
  # Conflict!
  tail -n1
}

# The length of the list.
# def length: Int
length() {
  wc -l # || awk 'END{print NR}'
}

# Builds a new collection by applying a function to all elements of this
# list.
# def map(f: String => String): String
map() {
  f=$(__desugar_function_1 $@)
  while read x; do
    eval $f
  done
}

# Displays all elements of this list in a string using a separator string.
# def mkstring(sep: String = " "): String
mkstring() {
  char=$1
  tr '\n' "${char:= }" | sed 's/.$//'
}

# Tests whether the list is not empty.
# def nonempty: Boolean
nonempty() {
  read x
}

# Reduces the elements of this list using the specified associative binary
# operator.
# def reduce(op: (String, String) => String): String
reduce() {
  reduceleft $@
}

# Applies a binary operator to all elements of this list going left to
# right.
# def reduceleft(op: (String, String) => String): String
reduceleft() {
  read x
  foldleft $x $@
}

# Applies a binary operator to all elements of this list, going right to
# left.
# def reduceright(op: (String, String) => String): String
reduceright() {
  reverse | reduceleft $(__swap_args $@)
}

# Returns new list with elements in reversed order.
# def reverse: List[String]
reverse() {
  tac 2> /dev/null || sed '1!G;h;$!d'
}

# Selects all elements except the first.
# Uses /usr/bin/tail when called with arguments.
# def tail: List[String]
tail() {
  if [ $# -eq 0 ]; then
    read x
    cat
  else
    /usr/bin/tail $@
  fi
}

# Selects first `n` elements.
# def take(n: Int): List[String]
take() {
  head -n$1
}

# Selects last n elements.
# def takeright(n: Int): List[String]
takeright() {
  tail -n$1
}

# Takes longest prefix of elements that satisfy a predicate.
# def takewhile(pred: String => Boolean): List[String]
takewhile() {
  while read x; do
    eval test $(__desugar_function_1 $@) || break
    echo $x
  done
}

# A copy of this list with one single replaced element.
# def updated(index: Int, elem: String): List[String]
updated() {
  for x in $(seq 1 $1); do
    read x
    echo "$x"
  done
  echo "$2"
  read x
  cat
}

# Zips this list with its indices.
# def zipwithindex: List[(String, Int)]
zipwithindex() {
  awk '{ print $0 " " FNR }'
}
