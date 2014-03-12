part of parsing;

class _AnyOfRuneMatcher extends _AbstractRuneMatcher {
  final String _runes;
  final Set<int> _runeSet;

  _AnyOfRuneMatcher(final String runes) :
    this._runes = runes,
    this._runeSet = runes.runes.toSet(),
    super();

  bool matches(final int rune) =>
      _runeSet.contains(rune);

  String toString() =>
      "anyOf($_runes)";
}