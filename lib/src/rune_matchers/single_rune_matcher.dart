part of parsing;

class _SingleRuneMatcher extends _AbstractRuneMatcher {
  final int _rune;

  const _SingleRuneMatcher(this._rune) : super();

  bool matches(final int rune) =>
      _rune == rune;

  String toString() =>
      "${new String.fromCharCode(_rune)}";
}
