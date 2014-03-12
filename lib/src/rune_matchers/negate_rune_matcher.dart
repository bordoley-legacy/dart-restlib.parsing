part of parsing;

class _NegateRuneMatcher extends _AbstractRuneMatcher {
  final RuneMatcher delegate;

  const _NegateRuneMatcher(this.delegate) : super();

  bool matches(final int rune) =>
      !delegate.matches(rune);

  String toString() =>
      "~($delegate)";
}