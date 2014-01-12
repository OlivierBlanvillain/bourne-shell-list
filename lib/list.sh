_tail=$(which tail)
_head=$(which head)

list() {
  if [ $# -eq 1 ]; then
    echo "$@" | tr ' ' '\n'
  else
    for i in "$@"; do echo $i; done
  fi
}

apply() {
  for x in $(seq 0 "$1"); do read x; done
  echo "$x"
}

cons() {
  echo "$@"
  cat
}

contains() {
  while read x; do
    test "$x" = "$@" && return 0
  done
  return 1
}

count() {
  i=0
  f=$(_desugar_function_1 "$@")
  while read x; do
    eval "$f" && i=$(($i + 1))
  done
  echo "$i"
}

drop() {
  $_tail -n +$(($1 + 1)) 2>/dev/null \
  || sed "1,$1d"
}

dropwhile() {
  f=$(_desugar_function_1 "$@")
  while read x; do
    eval "$f" || break
  done
  echo "$x"
  cat
}

exists() {
  f=$(_desugar_function_1 "$@")
  while read x; do
    eval "$f" && return 0
  done
  return 1
}

filter() {
  f=$(_desugar_function_1 "$@")
  while read x; do
    eval "$f" && echo "$x"
  done
}

filternot() {
  f=$(_desugar_function_1 "$@")
  while read x; do
    eval "$f" || echo "$x"
  done
}

find() {
  f=$(_desugar_function_1 "$@")
  while read x; do
    eval "$f" && echo "$x" && break
  done
}

fold() {
  foldleft "$@"
}

foldleft() {
  x="$1"
  shift 1
  f=$(_desugar_function_2 "$@")
  while read y; do
    x=$(eval "$f")
  done
  echo "$x"
}

foldright() {
  reverse | foldleft $(_swap_args "$@")
}

forall() {
  f=$(_desugar_function_1 "$@")
  while read x; do
    eval "$f" || return 1
  done
  return 0
}

head() {
  read x
  echo "$x"
}

init() {
  sed '$d'
}

isempty() {
  ! read x
}

last() {
  tail -n 1 2>/dev/null \
  || sed '$!d'
}

length() {
  wc -l 2>/dev/null \
  || awk 'END{ print NR }'
}

map() {
  f=$(_desugar_function_1 "$@")
  while read x; do
    eval "$f"
  done
}

mkstring() {
  arg="$@"
  sep=${arg:=" "}
  read x
  printf "$x"
  while read x; do
    printf "$sep$x"
  done
  printf "\n"
}

nonempty() {
  read x
}

reduce() {
  reduceleft "$@"
}

reduceleft() {
  read x
  foldleft "$x" "$@"
}

reduceright() {
  reverse | reduceleft $(_swap_args "$@")
}

reverse() {
  tac 2>/dev/null \
  || sed '1!G;h;$!d'
}

tail() {
  read x
  cat
}

take() {
  _head -n -$1 2>/dev/null \
  || sed "1,$1!d"
}

takeright() {
  reverse | take "$@" | reverse
}

takewhile() {
  f=$(_desugar_function_1 "$@")
  while read x; do
    eval "$f" || break
    echo "$x"
  done
}

updated() {
  for x in $(seq 1 "$1"); do
    read x
    echo "$x"
  done
  read x
  echo "$2"
  cat
}

zipwithindex() {
  awk '{ print FNR " " $0 }'
}

_number_of_underscores() {
  echo "$@" | awk -F_ '{ print NF-1 }'
}

_desugar_function_1() {
  if [ $(_number_of_underscores "$@") -eq 1 ]; then
    echo "$@" | sed 's/_1\?/$x/g'
  else
    echo "$@" | sed 's/_1/${x}/g'
  fi
}

_desugar_function_2() {
  if [ $(_number_of_underscores "$@") -eq 2 ]; then
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

_swap_args() {
  _desugar_function_2 "$@" | sed -e '
    s/${x}/${z}/g
    s/${y}/${x}/g
    s/${z}/${y}/g'
}
