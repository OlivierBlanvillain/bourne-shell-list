# Shell script test framework. Usage:

# $ cat mycode.sh
# fun() {
#   echo hello $@ | (rev 2>/dev/null || sed '
#     /\n/!G;s/\(.\)\(.*\n\)/&\2\1/;//D;s/.//')
# }

# $ cat mytests.sh
# . ./test-framework.sh
# testing mycode.sh
# withfallbackfor rev
# onshells posh bash zsh
# check 'fun world' 'dlrow hello'
# check 'fun world' 'dlrow olleh'

# $ sh mytests.sh
# Running on posh:
# fun world
# Expected:
# dlrow hello
# Got:
# dlrow olleh
# ===================== 1 failed, 1 passed in 0.2 seconds =====================

# http://www.gnu.org/software/make/manual/html_node/Utilities-in-Makefiles
# gives a list of utilities usable when writing portable code:
# awk cat cmp cp diff echo egrep expr false grep install-info ln ls
# mkdir mv printf pwd rm rmdir sed sleep sort tar test touch tr true

trap printresult 0

_date_in_centisecond() {
  echo $(($(date +'%s * 1000 + %-N / 1000000'))) | sed 's/.$//'
}

NONE='\033[00m'
BOLD='\033[1m'
RED='\033[01;31m'
GREEN='\033[01;32m'
shells='sh'
startat=$(_date_in_centisecond)

testing() {
  target=". ./$@;"
}

onshells() {
  shells="$@"
}

withfallbackfor() {
  disables=''
  fallbacks="$@"
  for disable in $@; do
    disables="$disables $disable() {
      without_$disable
    }
    "
  done
}

passed=0
failed=0

check() {
  runing=$1
  expected=$2
  for disable in off on; do
    if [ $disable = on ]; then
      disable="$disables"
      dis=" with \"$fallbacks\" disabled"
    else
      disable=''
      dis=''
    fi
    for shell in $shells; do
      got=$($shell -c "$disable $target $runing")
      if [ ! "$got" = "$expected" ]; then
        echo "\
${BOLD}Running on $shell$dis:${NONE}
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

printresult() {
  deltat=$(($(_date_in_centisecond) - $startat))
  linewidth=$(stty size | awk '{ print $2 }')
  if [ $failed = 0 ]; then
    failedmessage=""
    echo -n $GREEN
  else
    failedmessage=" $failed failed,"
    echo -n $RED
  fi
  duration="$(($deltat / 100)).$(($deltat % 100))" 
  message="$failedmessage $passed passed in $duration seconds "
  nequals="$(seq 1 $((($linewidth - $(expr length "$message")) / 2)))"
  echo -n $BOLD
  for i in $nequals; do echo -n =; done
  echo -n "$message"
  for i in $nequals; do echo -n =; done
  echo $NONE
}

checktrue() {
  check "$1 && echo true || echo false" "true"
}

checkfalse() {
  check "$1 && echo true || echo false" "false"
}
