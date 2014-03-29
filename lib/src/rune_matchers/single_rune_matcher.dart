part of parsing;

class _SingleRuneMatcher extends _AbstractRuneMatcher {
  final int _rune;
  final String name;

  const _SingleRuneMatcher(this._rune, [this.name]);

  bool matches(final int rune) =>
      _rune == rune;

  String toString() =>
      firstNotNull(name, "${new String.fromCharCode(_rune)}");
}
