part of restlib.parsing;

class _NegateRuneMatcher extends RuneMatcher {
  final RuneMatcher delegate;
  
  const _NegateRuneMatcher(this.delegate) : super._internal();
  
  bool matches(final int rune) => 
      !delegate.matches(rune);
  
  String toString() => 
      "~($delegate)";
}