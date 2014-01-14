_head=$(which head 2>/dev/null)
_last=$(which last 2>/dev/null)
_tail=$(which tail 2>/dev/null)
_zip=$(which zip 2>/dev/null)
_diff=$(which diff 2>/dev/null)

append() {
  list "$@"
  cat
}

apply() {
  drop "$1" | head
}

cons() {
  echo "$@"
  cat
}

contains() {
  filter test _ = "$@" | nonempty
}

count() {
  filter "$@" | length
}

diff() {
  filter "! \$(list  \"$@\" | contains _)"
}

distinct() {
  sort | uniq
}

drop() {
  $_tail -n +$(($1 + 1)) 2>/dev/null || sed "1,$1d"
}

dropright() {
  reverse | drop "$@" | reverse
}

dropwhile() {
  f=$(_desugar_function_1 "$@")
  while read x; do
    eval "$f" || break
  done
  echo "$x"
  cat
}

endswith() {
  takeright $(list "$@" | length) | equals "$@"
}

equals() {
  for y in "$@"; do
    read x
    test "$x" = "$y" || return 1
  done
  return 0
}

exists() {
  filter "$@" | nonempty
}

filter() {
  f=$(_desugar_function_1 "$@")
  while read x; do
    eval "$f" && echo "$x"
  done
}

filternot() {
  filter "! $@"
}

find() {
  filter "$@" | head
}

flatmap() {
  map "$@" | flatten
}

flatten() {
  map list _
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
  filternot "$@" | isempty
}

head() {
  read x
  echo "$x"
}

indexof() {
  _indexes_of_with_index "$@" | head | _second
}

indexwhere() {
  arg=$(cat)
  list "$arg" | indexof $(list "$arg" | filter "$@" | head)
}

indices() {
  i=0
  map 'echo $i; i=$(($i+1))'
}

init() {
  reverse | tail | reverse
}

intersect() {
  filter "list \"$@\" | contains _" | distinct
}

isdefinedat() {
  test "$(length)" -gt "$1"
}

isempty() {
  ! nonempty
}

last() {
  reverse | head
}

lastindexof() {
  _indexes_of_with_index "$@" | last | _second
}

lastindexwhere() {
  arg=$(cat)
  list "$arg" | lastindexof $(list "$arg" | filter "$@" | head)
}

length() {
  wc -l 2>/dev/null || awk 'END{ print NR }'
}

list() {
  if [ $# -eq 1 ]; then
    echo "$@" | tr ' ' '\n'
  else
    for i in "$@"; do echo $i; done
  fi
}

map() {
  f=$(_desugar_function_1 "$@")
  while read x; do
    eval "$f"
  done
}

max() {
  sort | last
}

maxby() {
  arg=$(cat)
  list "$arg" | map "$@" | zip $(echo "$arg") | max | _second
}

min() {
  sort | head
}

minby() {
  arg=$(cat)
  list "$arg" | map "$@" | zip $(echo "$arg") | min | _second
}

mkstring() {
  reduce echo _$@_
}

nonempty() {
  read x
}

padto() {
  arg=$(cat)
  echo "$arg"
  seq 1 $(expr "$1" - $(list "$arg" | length)) | map echo "$2"
}

prefixlength() {
  takewhile "$@" | length
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
  tac 2>/dev/null || sed '1!G;h;$!d'
}

sameelements() {
  distinct | equals $(list "$@" | distinct)  
}

slice() {
  take "$2" | drop "$1"
}

sortby() {
  arg=$(cat)
  echo "$arg" | map "$@" | zip $(echo "$arg") | sort | map 'echo _1 | _second'
}

sorted() {
  sort
}

startswith() {
  take $(list "$@" | length) | equals "$@"
}

tail() {
  read x
  cat
}

take() {
  _head -n -$1 2>/dev/null || sed "1,$1!d"
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

tostring() {
  mkstring ' '
}

union() {
  append "$@" | distinct
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

zip() {
  for y in "$@"; do
    if read x; then
      echo "$x $y"
    else
      echo "$y"
    fi
  done
  cat
}

zipwithindex() {
  arg=$(cat)
  list "$arg" | zip $(list "$arg" | indices )
}
_number_of_underscores() {
  echo "$@" | awk -F_ '{ print NF-1 }'
}

_desugar_function_1() {
  if [ $(_number_of_underscores "$@") -eq 1 ]; then
    echo "$@" | sed 's/_1\?/${x}/g'
  else
    echo "$@" | sed 's/_1/${x}/g'
  fi
}

_desugar_function_2() {
  if [ $(_number_of_underscores "$@") -le 2 ]; then
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

_indexes_of_with_index() {
  zipwithindex | filter test '"$(echo _1 | _first)"' = "$@"
}

_first() {
  sed 's/\([^ ]*\).*/\1/'
}

_second() {
  sed 's/[^ ]* //'
}
