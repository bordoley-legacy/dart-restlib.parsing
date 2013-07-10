part of restlib.parsing;

class _OrRuneMatcher extends RuneMatcher {
  final RuneMatcher fst;
  final RuneMatcher snd;
 
  const _OrRuneMatcher(this.fst, this.snd) : super._internal();
  
  bool matches(final int rune) => 
      fst.matches(rune) || snd.matches(rune);
  
  String toString() => 
      "($fst | $snd)";
}