part of parsing;

class _InRangeRuneMatcher extends _AbstractRuneMatcher {
  final int start;
  final int end;

  const _InRangeRuneMatcher(this.start, this.end) : super();

  bool matches(final int rune) =>
      (rune >= start) && (rune <= end);

  String toString() =>
      "[${new String.fromCharCode(start)} - ${new String.fromCharCode(end)}]";
}
