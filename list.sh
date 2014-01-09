# Constructs a list from a string where elements are space separated
# def list: List[String]
list() {
  for i in "$@"; do
    echo "$i"
  done
}

# Selects an element by its index in the list.
# def apply(n: Int): A
apply() {
  :
}

# Returns a new list containing the elements from the left hand operand
# followed by the elements from the right hand operand.
# def cons(that: List[String]): List[String]
cons() {
  :
}

# Tests whether this list contains a given value as an element.
# def contains(elem: String): Boolean
contains() {
  :
}

# Counts the number of elements in the list which satisfy a predicate.
# def count(p: String => Boolean): Int
count() {
  :
}

# Selects all elements except first `n` ones.
# def drop(n: Int): List[String]
drop() {
  :
}

# Drops longest prefix of elements that satisfy a predicate.
# def dropwhile(pred: String => Boolean): List[String]
dropwhile() {
  :
}

# Tests whether a predicate holds for some of the elements of this list.
# def exists(pred: String => Boolean): Boolean
exists() {
  :
}

# Selects all elements of this list which satisfy a predicate.
# def filter(pred: String => Boolean): List[String]
filter() {
  :
}

# Selects all elements of this list which do not satisfy a predicate.
# def filternot(pred: String => Boolean): List[String]
filternot() {
  :
}

# Finds the first element of the list satisfying a predicate.
# def find(pred: String => Boolean): String
find() {
  # Conflict!
  :
}

# Folds the elements of this list using the specified associative binary
# operator.
# def fold(z: String)(op: (String, String) => String): String
fold() {
  # Conflict!
  :
}

# Applies a binary operator to a start value and all elements of this list,
# going left to right.
# def foldleft(z: String)(op: (String, String) => String): String
foldleft() {
  :
}

# Applies a binary operator to all elements of this list and a start value,
# going right to left.
# def foldright(z: String)(op: (String, String) => String): String
foldright() {
  :
}

# Tests whether a predicate holds for all elements of this list.
# def forall(pred: String => Boolean): Boolean
forall() {
  :
}

# Applies a function `f` to all elements of this list.
# def foreach[U](f: String => U): Unit
foreach() {
  :
}

# Selects the first element of this list.
# def head: String
head() {
  # Conflict!
  :
}

# Selects all elements except the last.
# def init: List[String]
init() {
  :
}

# Tests whether the list is empty.
# def isempty: Boolean
isempty() {
  :
}

# Selects the last element.
# def last: String
last() {
  # Conflict!
  :
}

# The length of the list.
# def length: Int
length() {
  :
}

# Builds a new collection by applying a function to all elements of this
# list.
# def map(f: String => String): String
map() {
  :
}

# Displays all elements of this list in a string using a separator string.
# def mkstring(sep: String): String
mkstring() {
  :
}

# Displays all elements of this list in a string.
# def mkstring: String
mkstring() {
  :
}

# Tests whether the list is not empty.
# def nonempty: Boolean
nonempty() {
  :
}

# Reduces the elements of this list using the specified associative binary
# operator.
# def reduce(op: (String, String) => String): String
reduce() {
  :
}

# Applies a binary operator to all elements of this list going left to
# right.
# def reduceleft(op: (String, String) => String): String
reduceleft() {
  :
}

# Applies a binary operator to all elements of this list, going right to
# left.
# def reduceright(op: (String, String) => String): String
reduceright() {
  :
}

# Returns new list with elements in reversed order.
# def reverse: List[String]
reverse() {
  :
}

# The size of this list.
# def size: Int
size() {
  # Conflict!
  :
}

# Selects all elements except the first.
# def tail: List[String]
tail() {
  # Conflict!
  :
}

# Selects first `n` elements.
# def take(n: Int): List[String]
take() {
  :
}

# Selects last n elements.
# def takeright(n: Int): List[String]
takeright() {
  :
}

# Takes longest prefix of elements that satisfy a predicate.
# def takewhile(pred: String => Boolean): List[String]
takewhile() {
  :
}

# A copy of this list with one single replaced element.
# def updated(index: Int, elem: String): List[String]
updated() {
  :
}

# Returns a list formed from this list and another iterable collection by
# combining corresponding elements in pairs.
# def zip(that: List[String]): List[(String, String)]
zip() {
  # Conflict!
  :
}

# Zips this list with its indices.
# def zipwithindex: List[(String, Int)]
zipwithindex() {
  :
}
