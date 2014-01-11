NONE='\033[00m'
BOLD='\033[1m'
RED='\033[01;31m'
GREEN='\033[01;32m'
passed=0
failed=0

check() {
  shells='ash bash dash ksh mksh pdksh posh zsh'
  f='tail head tac wc'
  runing=$1
  expected=$2
  for shell in $shells; do
    got=$($shell -c ". ./list.sh; $runing")
    if [ "$got" = "$expected" ]; then
      passed=$(expr 1 + $passed)
    else
      echo "\
${BOLD}-Running on $shell:${NONE}\n$runing
${BOLD}-Expected:${NONE}\n$expected
${BOLD}-Got:${NONE}\n$got"
      failed=$(expr 1 + $failed)
    fi
  done
}

checktrue() {
  check "($1 && echo true) || echo false" "true"
}

checkfalse() {
  check "($1 && echo true) || echo false" "false"
}

printresult() {
  linewidth=$(stty size | awk '{print $2}')
  if [ $failed = 0 ]; then
    message=" $passed passed "
    echo -n $GREEN
  else
    message=" $failed failed, $passed passed "
    echo -n $RED
  fi
  nequals="$(seq 1 $((($linewidth - $(expr length "$message")) / 2)))"
  echo -n $BOLD
  for i in $nequals; do echo -n =; done
  echo -n "$message"
  for i in $nequals; do echo -n =; done
  echo $NONE
}

check 'list "j e" "t u" "vo us" | apply 1' 't u'
checktrue 'list 1 2 | contains 1'
checkfalse 'list 1 2 | contains 3'
check 'list 1 2 3 4 | drop 2 | mkstring' '3 4'
check 'list 1 2 | head' '1'
check 'list "j e" "t u" "vo us" | init | mkstring' 'j e t u'
checkfalse 'list 1 2 3 | isempty'
checktrue 'list 1 2 3 | nonempty'
checktrue 'echo -n | isempty'
checkfalse 'echo -n | nonempty'
check 'list 1 2 | last' '2'
check 'list 1 2 3 | length' '3'
check 'list 1 2 3 | mkstring' '1 2 3'
check 'list 1 2 3 | mkstring ,' '1,2,3'
check 'list 1 2 3 | reverse | mkstring' '3 2 1'
check 'list 1 2 3 | take 2 | mkstring' '1 2'
check 'list 1 2 3 | tail | mkstring' '2 3'
check 'list 1 2 3 | takeright 2 | mkstring' '2 3'
check 'list 1 2 3 | map echo s_ | mkstring' 's1 s2 s3'
check 'list 1 2 3 | map echo s_1 | mkstring' 's1 s2 s3'
check 'list 1 2 3 | updated 1 g | mkstring' '1 g 3'
check 'list a b c | zipwithindex | mkstring' 'a 1 b 2 c 3'
check 'list 1 2 3 4 | filter _ -ge 3 | mkstring' '3 4'
check 'list 1 2 3 4 | filternot _ -ge 3 | mkstring' '1 2'
checktrue 'list 1 2 3 4 | exists _ = 3'
checkfalse 'list 1 2 3 4 | exists _ = 5'
check 'list 1 2 3 4 | count _ -ge 2' '3'
check 'list 1 2 3 4 | dropwhile _ -le 2 | mkstring' '3 4'
checktrue 'list 1 2 3 4 | forall _ -ge 1'
checkfalse 'list 1 2 3 4 | forall _ -ge 2'
check 'list 1 2 3 4 | takewhile _ -le 2 | mkstring' '1 2'
check 'list 1 2 3 4 | find _ -ge 2' '2'
check 'list 4 2 4 | foldleft 64 expr _1 / _2' '2'
check 'list 4 2 4 | foldleft 64 expr _ / _' '2'
check 'list 34 56 12 4 23 | foldleft 7 expr _1 / _2' '0'
check 'list 34 56 12 4 23 | foldleft 7 expr _ / _' '0'
check 'list 34 56 12 4 23 | fold 7 expr _ / _' '0'
check 'list 34 56 12 4 23 | foldright 7 expr _1 / _2' '8'
check 'list 34 56 12 4 23 | foldright 7 expr _ / _' '8'
check 'list 64 4 2 4 | reduceleft expr _ / _' '2'
check 'list 64 4 2 4 | reduceleft expr _ / _' '2'
check 'list 7 34 56 12 4 23 | reduceleft expr _1 / _2' '0'
check 'list 7 34 56 12 4 23 | reduceleft expr _ / _' '0'
check 'list 7 34 56 12 4 23 | reduce expr _ / _' '0'
check 'list 34 56 12 4 23 7 | reduceright expr _1 / _2' '8'
check 'list 34 56 12 4 23 7 | reduceright expr _ / _' '8'

printresult
