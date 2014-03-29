part of parsing;

class _AnyOfRuneMatcher extends _AbstractRuneMatcher {
  factory _AnyOfRuneMatcher(final String runes) =>
      new _AnyOfRuneMatcher._(runes.runes.toSet(), "anyOf($runes)");

  final Set<int> _runeSet;
  final String name;

  _AnyOfRuneMatcher._(this._runeSet, this.name);

  bool matches(final int rune) =>
      _runeSet.contains(rune);

  String toString() =>
      name;
}