# def list: List[String]
list() {
  if [ $# -eq 1 ]; then
    echo "$@" | tr ' ' '\n'
  else
    for i in "$@"; do echo $i; done
  fi
}

# def apply(n: Int): A
apply() {
  for x in $(seq 0 "$1"); do read x; done
  echo "$x"
}

# def cons(x: String): List[String]
cons() {
  echo "$@"
  cat
}

# def contains(elem: String): Boolean
contains() {
  while read x; do
    test "$x" = "$@" && return 0
  done
  return 1
}

# def count(p: String => Boolean): Int
count() {
  i=0
  f=$(__desugar_function_1 "$@")
  while read x; do
    eval "$f" && i=$(expr "$i" + 1)
  done
  echo "$i"
}

# def drop(n: Int): List[String]
drop() {
  sed "1,$1d"
}

# def dropwhile(pred: String => Boolean): List[String]
dropwhile() {
  f=$(__desugar_function_1 "$@")
  while read x; do
    eval "$f" || break
  done
  echo "$x"
  cat
}

# def exists(pred: String => Boolean): Boolean
exists() {
  f=$(__desugar_function_1 "$@")
  while read x; do
    eval "$f" && return 0
  done
  return 1
}

# def filter(pred: String => Boolean): List[String]
filter() {
  f=$(__desugar_function_1 "$@")
  while read x; do
    eval "$f" && echo "$x"
  done
}

# def filternot(pred: String => Boolean): List[String]
filternot() {
  f=$(__desugar_function_1 "$@")
  while read x; do
    eval "$f" || echo "$x"
  done
}

# def find(pred: String => Boolean): String
find() {
  f=$(__desugar_function_1 "$@")
  while read x; do
    eval "$f" && echo "$x" && break
  done
}

# def fold(z: String, op: (String, String) => String): String
fold() {
  foldleft "$@"
}

# def foldleft(z: String, op: (String, String) => String): String
foldleft() {
  x="$1"
  shift 1
  f=$(__desugar_function_2 "$@")
  while read y; do
    x=$(eval "$f")
  done
  echo "$x"
}

# def foldright(z: String, op: (String, String) => String): String
foldright() {
  reverse | foldleft $(__swap_args "$@")
}

# def forall(pred: String => Boolean): Boolean
forall() {
  f=$(__desugar_function_1 "$@")
  while read x; do
    eval "$f" || return 1
  done
  return 0
}

# def head: String
head() {
  read x
  echo "$x"
}

# def init: List[String]
init() {
  sed '$d'
}

# def isempty: Boolean
isempty() {
  ! read x
}

# def last: String
last() {
  sed '$!d'
}

# def length: Int
length() {
  wc -l 2>/dev/null || awk 'END{ print NR }'
}

# def map(f: String => String): String
map() {
  f=$(__desugar_function_1 "$@")
  while read x; do
    eval "$f"
  done
}

# def mkstring(sep: String=" "): String
mkstring() {
  arg="$@"
  sep=${arg:= }
  read x
  printf "$x"
  while read x; do
    printf "$sep$x"
  done
  echo ''
}

# def nonempty: Boolean
nonempty() {
  read x
}

# def reduce(op: (String, String) => String): String
reduce() {
  reduceleft "$@"
}

# def reduceleft(op: (String, String) => String): String
reduceleft() {
  read x
  foldleft "$x" "$@"
}

# def reduceright(op: (String, String) => String): String
reduceright() {
  reverse | reduceleft $(__swap_args "$@")
}

# def reverse: List[String]
reverse() {
  tac 2> /dev/null || sed '1!G;h;$!d'
}

# def tail: List[String]
tail() {
  read x
  cat
}

# def take(n: Int): List[String]
take() {
  sed "1,$1!d"
}

# def takeright(n: Int): List[String]
takeright() {
  reverse | take "$@" | reverse
}

# def takewhile(pred: String => Boolean): List[String]
takewhile() {
  f=$(__desugar_function_1 "$@")
  while read x; do
    eval "$f" || break
    echo "$x"
  done
}

# def updated(index: Int, elem: String): List[String]
updated() {
  for x in $(seq 1 "$1"); do
    read x
    echo "$x"
  done
  read x
  echo "$2"
  cat
}

# def zipwithindex: List[(Int, String)]
zipwithindex() {
  awk '{ print FNR " " $0 }'
}

__number_of_underscores() {
  echo "$@" | awk -F_ '{ print NF-1 }'
}

__desugar_function_1() {
  if [ $(__number_of_underscores "$@") -eq 1 ]; then
    echo "$@" | sed 's/_1\?/$x/g'
  else
    echo "$@" | sed 's/_1/${x}/g'
  fi
}

__desugar_function_2() {
  if [ $(__number_of_underscores "$@") -eq 2 ]; then
    echo "$@" | sed '
      s/_1/${x}/g
      s/_2/${y}/g
      s/_/${x}/
      s/_/${y}/'
  else
    echo "$@" | sed '
      s/_1/${x}/g
      s/_2/${y}/g'
  fi
}

__swap_args() {
  __desugar_function_2 "$@" | sed -e '
    s/${x}/${z}/g
    s/${y}/${x}/g
    s/${z}/${y}/g'
}
