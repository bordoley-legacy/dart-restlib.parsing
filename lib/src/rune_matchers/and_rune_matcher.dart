part of parsing;

class _AndRuneMatcher extends _AbstractRuneMatcher {
  final RuneMatcher fst;
  final RuneMatcher snd;
  final String name;

  const _AndRuneMatcher(this.fst, this.snd, [this.name]);

  RuneMatcher named(final String name) =>
      new _AndRuneMatcher(this.fst, this.snd, checkNotNull(name));

  bool matches(final int rune) =>
      fst.matches(rune) && snd.matches(rune);

  String toString() =>
      firstNotNull(name, "($fst & $snd)");
}
