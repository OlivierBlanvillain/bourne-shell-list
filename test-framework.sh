# $ cat mycode.sh
# fun() {
#   echo hello $@ | (rev 2>/dev/null || sed '
#     /\n/!G;s/\(.\)\(.*\n\)/&\2\1/;//D;s/.//')
# }

# $ cat mytests.sh
# . ./test-framework.sh
# testing 'mycode.sh'
# withfallbackfor 'rev'
# onshells 'posh bash zsh'
# check 'fun world' 'dlrow hello'
# check 'fun world' 'dlrow olleh'

# $ sh mytests.sh
# Running on posh:
# fun world
# Expected:
# dlrow hello
# Got:
# dlrow olleh
# ============= 1 failed, 1 passed =============

# The following utilities are safe (should not be in withfallbackfor):
# awk cat cmp cp diff echo egrep expr false grep install-info ln ls
# mkdir mv printf pwd rm rmdir sed sleep sort tar test touch tr true
# http://www.gnu.org/software/make/manual/html_node/Utilities-in-Makefiles

trap printresult 0

NONE='\033[00m'
BOLD='\033[1m'
RED='\033[01;31m'
GREEN='\033[01;32m'
shells='sh'
passed=0
failed=0

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

checktrue() {
  check "$1 && echo true || echo false" "true"
}

checkfalse() {
  check "$1 && echo true || echo false" "false"
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
