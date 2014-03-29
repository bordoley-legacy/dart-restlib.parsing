part of parsing;

class _InRangeRuneMatcher extends _AbstractRuneMatcher {
  final int start;
  final int end;
  final String name;

  const _InRangeRuneMatcher(this.start, this.end, [this.name]) : super();

  RuneMatcher named(final String name) =>
      new _InRangeRuneMatcher(this.start, this.end, checkNotNull(name));

  bool matches(final int rune) =>
      (rune >= start) && (rune <= end);

  String toString() =>
      firstNotNull(name, "[${new String.fromCharCode(start)} - ${new String.fromCharCode(end)}]");
}
