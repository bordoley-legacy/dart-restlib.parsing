part of parsing;

class _OrRuneMatcher extends _AbstractRuneMatcher {
  final RuneMatcher fst;
  final RuneMatcher snd;

  const _OrRuneMatcher(this.fst, this.snd) : super();

  bool matches(final int rune) =>
      fst.matches(rune) || snd.matches(rune);

  String toString() =>
      "($fst | $snd)";
}