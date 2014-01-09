NONE='\033[00m'
RED='\033[01;31m'
GREEN='\033[01;32m'
BOLD='\033[1m'
passed=0
failed=0

check() {
  runing=$1
  expected=$2
  got=$(sh -c ". ./list.sh; $runing")
  if [ "$got" = "$expected" ]; then
    passed=$(expr 1 + $passed)
  else
    echo "\
${BOLD}Runing:${NONE}\n$runing
${BOLD}Expected:${NONE}\n$expected
${BOLD}Got:${NONE}\n$got"
    failed=$(expr 1 + $failed)
  fi
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

check 'list "j e" "t u" "vo us"' 'j e
t u
vo us'

check 'list "j e" "t u" "vo us" | apply 1' 't u'

checktrue 'list 1 2 | contains 1'

checkfalse 'list 1 2 | contains 3'

check 'list 1 2 3 4 | drop 2' '3
4'

check 'list 1 2 | head' '1'

check 'list "j e" "t u" "vo us" | init' 'j e
t u'

checkfalse 'list 1 2 3 | isempty'

checktrue 'list 1 2 3 | nonempty'

checktrue 'echo -n | isempty'

checkfalse 'echo -n | nonempty'

check 'list 1 2 | last' '2'

check 'list 1 2 3 | length' '3'

check 'list 1 2 3 | mkstring' '1 2 3'

check 'list 1 2 3 | mkstring ,' '1,2,3'

check 'list 1 2 3 | reverse | mkstring' '3 2 1'


printresult
