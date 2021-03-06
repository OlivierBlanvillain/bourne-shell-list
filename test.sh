. ./test-framework.sh

testing ./list.sh
withfallbackfor wc tac head tail
onshells dash posh ash bash mksh pdksh ksh zsh   

check 'list "a a" "b b" | mkstring ,' 'a a,b b'
check 'list "a a" "b b" | map list _ | mkstring ,' 'a,a,b,b'
check 'list "j e" "t u" "vo us" | apply 1' 't u'
check 'list 1 2 | cons a b | mkstring ", "' 'a b, 1, 2'
checktrue 'list 1 2 | contains 1'
checkfalse 'list 1 2 | contains 3'
check 'list 1 2 3 4 | drop 2 | tostring' '3 4'
check 'list 1 2 3 4 | dropright 1 | tostring' '1 2 3'
check 'list 1 2 | head' '1'
check 'list "j e" "t u" "vo us" | init | tostring' 'j e t u'
checkfalse 'list 1 2 3 | isempty'
checktrue 'list 1 2 3 | nonempty'
checktrue 'echo -n | isempty'
checkfalse 'echo -n | nonempty'
check 'list 1 2 | last' '2'
check 'list 1 2 3 | length' '3'
check 'list 1 2 3 | tostring' '1 2 3'
check 'list 1 2 3 | mkstring ,' '1,2,3'
check 'list 1 2 3 | reverse | tostring' '3 2 1'
check 'list 1 2 3 | take 2 | tostring' '1 2'
check 'list 1 2 3 | tail | tostring' '2 3'
check 'list 1 2 3 | takeright 2 | tostring' '2 3'
check 'list 1 2 3 | map echo s_ | tostring' 's1 s2 s3'
check 'list 1 2 3 | map echo s_1 | tostring' 's1 s2 s3'
check 'list 1 2 3 | updated 1 g | tostring' '1 g 3'
check 'list a b c | zipwithindex | mkstring ", "' 'a 0, b 1, c 2'
check 'list 1 2 3 4 | filter test _ -ge 3 | tostring' '3 4'
check 'list 1 2 3 4 | filternot test _ -ge 3 | tostring' '1 2'
checktrue 'list 1 2 3 4 | exists test _ = 3'
checkfalse 'list 1 2 3 4 | exists test _ = 5'
check 'list 1 2 3 4 | count test _ -ge 2' '3'
check 'list 1 2 3 4 | dropwhile test _ -le 2 | tostring' '3 4'
checktrue 'list 1 2 3 4 | forall test _ -ge 1'
checkfalse 'list 1 2 3 4 | forall test _ -ge 2'
check 'list 1 2 3 4 | takewhile test _ -le 2 | tostring' '1 2'
check 'list 1 2 3 4 | find test _ -ge 2' '2'
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
check 'list 1 2 3 | zip $(list a b c) | mkstring ", "' '1 a, 2 b, 3 c'
check 'list 1 2 3 | zip $(list a b) | mkstring ", "' '1 a, 2 b, 3'
check 'list 1 2 | zip $(list a b c) | mkstring ", "' '1 a, 2 b, c'
check 'list 2 1 2 3 | distinct | tostring' '1 2 3'
checktrue 'list 1 2 3 | endswith $(list 2 3)'
checkfalse 'list 1 2 3 | endswith $(list 1 2)'
checktrue 'list 1 2 3 | equals $(list 1  2  3)'
checkfalse 'list 1 2 3 | equals $(list 1 3 2)'
check 'list "a a" "b b" | flatmap echo _s | mkstring ,' 'a,as,b,bs'
check 'list "a a" "b b" | flatten | mkstring ,' 'a,a,b,b'
check 'list "a a" "b b" | indices | mkstring ,' '0,1'
checktrue 'list 1 2 3 | isdefinedat 2'
checkfalse 'list 1 2 3 | isdefinedat 3'
check 'list 2 3 1 | max' '3'
check 'list 2 3 1 | min' '1'
check 'list 2 3 1 | maxby expr _ % 3' '2'
check 'list 2 3 1 | minby expr _ % 3' '3'
check 'list 1 | padto 3 a | tostring' '1 a a'
check 'list 1 2 3 2 | diff $(list 3 4 3) | tostring' '1 2 2'
checktrue 'list 2 1 2 3 | endswith $(list 1 2 3)'
checkfalse 'list 2 1 2 3 | endswith $(list 2 1 2)'
check 'list a b c b | indexof b' '1'
check 'list a b c | indexwhere test _ = b' '1'
check 'list a b c b | lastindexof b' '3'
check 'list a b c b | lastindexwhere test _ = b' '3'
check 'list c d | append a b | tostring' 'a b c d'
check 'list 1 1 3 1 | prefixlength test _ -le 2' '2'
checktrue 'list 2 1 2 3 | sameelements $(list 1 2 3)'
checkfalse 'list 2 1 2 3 | sameelements $(list 1 4 3)'
check 'list a b c d e | slice 1 3 | tostring' 'b c'
check 'list a c c e b | sorted | tostring' 'a b c c e'
check 'list aas cd css e b | sortby echo "\${#x}" | tostring' 'b e cd aas css'
checktrue 'list 2 1 2 3 | startswith $(list 2 1 2)'
checkfalse 'list 2 1 2 3 | startswith $(list 1 2 3)'
check 'list 2 1 2 3 | intersect $(list 2 1 4) | tostring' '1 2'
check 'list 2 1 2 3 | union $(list 2 1 4) | mkstring ,' '1,2,3,4'

check '
quicksort() {
  arg=$(cat)
  len=$(list $arg | length)
  if [ 2 -gt $len ]; then
    list $arg
  else
    pivot=$(list $arg | apply $(($len / 2)))
    list $arg | filter [ _ -lt $pivot ] | quicksort | cat
    list $arg | filter [ _ -eq $pivot ]
    list $arg | filter [ _ -gt $pivot ] | quicksort
  fi
}
echo 3 81 76 49 33 58 90 6 100 33 87 48 11 16 21 34 | quicksort | tostring
' '3 6 11 16 21 33 33 34 48 49 58 76 81 87 90 100'
