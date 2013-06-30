part of restlib.parsing;

class _SingleRuneMatcher extends RuneMatcher {
  final int _rune;
  
  const _SingleRuneMatcher(this._rune) :
    super._internal();
  
  bool matches(final int rune) => _rune == rune;
  
  String toString() => "${new String.fromCharCode(_rune)}";
}
