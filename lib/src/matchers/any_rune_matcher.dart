part of restlib.parsing;

class _AnyRuneMatcher extends RuneMatcher {
  const _AnyRuneMatcher() : super._internal();
  
  RuneMatcher operator &(RuneMatcher other) => other;
 
  RuneMatcher operator|(RuneMatcher other) => this;
  
  bool matches(int rune) => true;
  
  bool matchesAllOf(String val) => true;
  
  bool matchesNoneOf(String val) => false;
  
  RuneMatcher negate() => RuneMatcher.NONE;
  
  String toString() => "*";
}