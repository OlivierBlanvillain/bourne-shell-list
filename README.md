**bourne-shell-list** brings the semantics of [Scala's lists][1] into any POSIX compilent shell. For example:

    quicksort() {
      a=$(cat)
      l=$(list $a | length)
      if [ 2 -gt $l ]; then
        list $a
      else
        pivot=$(list $a | apply $(($l / 2)))
        list $a | filter [ _ -lt $pivot ] | quicksort | cat
        list $a | filter [ _ -eq $pivot ]
        list $a | filter [ _ -gt $pivot ] | quicksort
      fi
    }

See [the manual][2] for the complete list of commands and additional examples. The library is fully tested on 8 shells. I use a home made testing framework which is probably more useful than the library.

### Install:

Download `list.sh` and source it in your `~/.whatevershrc`.  
Quick-and-dirty: `. <(curl -fsL http://goo.gl/cIDiZ7)`

### Run the tests:
    
    sh test.sh
    
### Compile the manual:

    gem install ronn
    ronn --style=toc --html -/man.ronn --pipe > index.html

[1]: http://www.scala-lang.org/api/current/index.html#scala.collection.immutable.List
[2]: http://olivierblanvillain.github.io/bourne-shell-list/
