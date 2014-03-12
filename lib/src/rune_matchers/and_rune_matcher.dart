part of parsing;

class _AndRuneMatcher extends _AbstractRuneMatcher {
  final RuneMatcher fst;
  final RuneMatcher snd;

  const _AndRuneMatcher(this.fst, this.snd) : super();

  bool matches(final int rune) =>
      fst.matches(rune) && snd.matches(rune);

  String toString() =>
      "($fst & $snd)";
}
