# Known shells:
# ash bash csh dash fish ksh mksh pdksh posh scsh sh tcsh zsh

# Known shell:
# awk cat cmp cp diff echo egrep expr false grep install-info ln ls
# mkdir mv printf pwd rm rmdir sed sleep sort tar test touch tr true

NONE='\033[00m'
BOLD='\033[1m'
RED='\033[01;31m'
GREEN='\033[01;32m'
dis=''
for d in $disabled; do
  dis="$dis$d() {
    without_$d
  }
  "
done
passed=0
failed=0

check() {
  runing=$1
  expected=$2
  for d in "$dis" ''; do
    for shell in $shells; do
      got=$($shell -c "$d . $target; $runing")
      if [ ! "$got" = "$expected" ]; then
        echo "\
${BOLD}Running on $shell:${NONE}
$runing
${BOLD}Expected:${NONE}
$expected
${BOLD}Got:${NONE}
$got"
        failed=$(expr 1 + $failed)
        return 1
      fi
    done
  done
  passed=$(expr 1 + $passed)
}

checktrue() {
  check "($1 && echo true) || echo false" "true"
}

checkfalse() {
  check "($1 && echo true) || echo false" "false"
}

printresult() {
  linewidth=$(stty size | awk '{ print $2 }')
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
