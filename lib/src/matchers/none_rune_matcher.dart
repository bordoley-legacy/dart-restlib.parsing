part of restlib.parsing;

class _NoneRuneMatcher extends RuneMatcher {
  const _NoneRuneMatcher() : super._internal();
  
  RuneMatcher operator&(RuneMatcher other) => this; 
  
  RuneMatcher operator|(RuneMatcher other) => other;
  
  bool matches(int rune) => false;
  
  bool matchesAllOf(String val) => false;

  bool matchesNoneOf(String val) => true;
  
  RuneMatcher negate() => RuneMatcher.ANY;
  
  String toString() => "";
}
