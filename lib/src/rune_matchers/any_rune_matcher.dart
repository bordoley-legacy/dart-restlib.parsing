part of parsing;

class _AnyRuneMatcher extends RuneMatcher {
  const _AnyRuneMatcher() : super._internal();
  
  RuneMatcher operator &(final RuneMatcher other) => 
      other;
 
  RuneMatcher operator|(final RuneMatcher other) => 
      this;
  
  Option<int> doParse(final StringIterator itr) =>
      (itr.moveNext()) ? new Option(itr.current) : Option.NONE;
  
  bool matches(final int rune) => 
      true;
  
  bool matchesAllOf(final String val) => 
      true;
  
  bool matchesNoneOf(final String val) => 
      false;
  
  RuneMatcher negate() => 
      NONE;
  
  String toString() => 
      "*";
}