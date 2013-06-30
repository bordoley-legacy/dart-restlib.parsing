part of restlib.parsing;

class _InRangeRuneMatcher extends RuneMatcher {
  final int start;
  final int end;
  
  const _InRangeRuneMatcher(this.start, this.end) : super._internal();
  
  bool matches(final int rune) => (rune >= start) && (rune <= end);
  
  String toString() =>
      "${new String.fromCharCode(start)} - ${new String.fromCharCode(end)}";
}
