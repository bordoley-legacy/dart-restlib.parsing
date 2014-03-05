part of parsing;

class _AndRuneMatcher extends RuneMatcher {
  final RuneMatcher fst;
  final RuneMatcher snd;
 
  const _AndRuneMatcher(this.fst, this.snd) : super._internal();
  
  bool matches(final int rune) => 
      fst.matches(rune) && snd.matches(rune);
  
  String toString() => 
      "($fst & $snd)";
}
