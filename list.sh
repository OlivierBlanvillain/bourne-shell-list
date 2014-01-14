_head=$(which head 2>/dev/null)
_last=$(which last 2>/dev/null)
_tail=$(which tail 2>/dev/null)
_zip=$(which zip 2>/dev/null)
_diff=$(which diff 2>/dev/null)

# Core functions

cons() {
  echo "$@"
  cat
}

drop() {
  $_tail -n +$(($1 + 1)) 2>/dev/null || sed "1,$1d"
}

equals() {
  for y in "$@"; do
    read x
    test "$x" = "$y" || return 1
  done
  return 0
}

filter() {
  f=$(_desugar_function_1 "$@")
  while read x; do
    eval "$f" && echo "$x"
  done
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

head() {
  read x
  echo "$x"
}

length() {
  wc -l 2>/dev/null || awk 'END{ print NR }'
}

indices() {
  i=0
  while read y; do
    echo "$i"
    i=$(($i + 1))
  done
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

reverse() {
  tac 2>/dev/null || sed '1!G;h;$!d'
}

tail() {
  read x
  cat
}

take() {
  _head -n -$1 2>/dev/null || sed "1,$1!d"
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

# Annex functions

append() {
  list "$@"
  cat
}

apply() {
  drop "$1" | head
}

contains() {
  filter [ _ = "$@" ] | nonempty
}

count() {
  filter "$@" | length
}

diff() {
  filter "! \$(list \"$@\" | contains _)"
}

distinct() {
  sort | uniq
}

dropright() {
  reverse | drop "$@" | reverse
}

dropwhile() {
  arg=$(cat)
  echo "$arg" | drop $(echo "$arg" | indexof $(echo "$arg" | filternot "$@" | head))
}

endswith() {
  takeright $(list "$@" | length) | equals "$@"
}

exists() {
  filter "$@" | nonempty
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

foldright() {
  reverse | foldleft $(_swap_args "$@")
}

forall() {
  filternot "$@" | isempty
}

indexof() {
  _indexes_of_with_index "$@" | head | _second
}

indexwhere() {
  arg=$(cat)
  echo "$arg" | indexof $(echo "$arg" | filter "$@" | head)
}

init() {
  reverse | tail | reverse
}

intersect() {
  filter "list \"$@\" | contains _" | distinct
}

isdefinedat() {
  [ "$(length)" -gt "$1" ]
}

isempty() {
  equals ''
}

last() {
  reverse | head
}

lastindexof() {
  _indexes_of_with_index "$@" | last | _second
}

lastindexwhere() {
  arg=$(cat)
  echo "$arg" | lastindexof $(echo "$arg" | filter "$@" | head)
}

max() {
  sort | last
}

maxby() {
  arg=$(cat)
  echo "$arg" | map "$@" | zip $(echo "$arg") | max | _second
}

min() {
  sort | head
}

minby() {
  arg=$(cat)
  echo "$arg" | map "$@" | zip $(echo "$arg") | min | _second
}

mkstring() {
  reduce echo _$@_
}

nonempty() {
  ! isempty
}

padto() {
  arg=$(cat)
  echo "$arg"
  seq 1 $(expr "$1" - $(echo "$arg" | length)) | map echo "$2"
}

prefixlength() {
  takewhile "$@" | length
}

reduce() {
  reduceleft "$@"
}

reduceleft() {
  arg=$(cat)
  echo "$arg" | tail | foldleft "$(echo "$arg" | head)" "$@"
}

reduceright() {
  reverse | reduceleft $(_swap_args "$@")
}

sameelements() {
  distinct | equals $(list "$@" | distinct)  
}

slice() {
  take "$2" | drop "$1"
}

sortby() {
  arg=$(cat)
  echo "$arg" | map "$@" | zip $(echo "$arg") | sort | map 'echo "_1" | _second'
}

sorted() {
  sort
}

startswith() {
  take $(list "$@" | length) | equals "$@"
}

takeright() {
  reverse | take "$@" | reverse
}

takewhile() {
  arg=$(cat)
  echo "$arg" | take $(echo "$arg" | indexof $(echo "$arg" | filternot "$@" | head))
}

tostring() {
  mkstring ' '
}

union() {
  append "$@" | distinct
}

updated() {
  arg=$(cat)
  echo "$arg" | take "$1"
  echo "$2"
  echo "$arg" | drop "$1" | tail
}

zipwithindex() {
  arg=$(cat)
  echo "$arg" | zip $(echo "$arg" | indices )
}

# Implementation functions

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
  zipwithindex | filter [ '"$(echo _1 | _first)"' = "$@" ]
}

_first() {
  sed 's/\([^ ]*\).*/\1/'
}

_second() {
  sed 's/[^ ]* //'
}
