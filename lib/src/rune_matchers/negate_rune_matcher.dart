part of parsing;

class _NegateRuneMatcher extends _AbstractRuneMatcher {
  final RuneMatcher delegate;
  final String name;

  const _NegateRuneMatcher(this.delegate, [this.name]);

  RuneMatcher named(final String name) =>
      new _NegateRuneMatcher(this.delegate, checkNotNull(name));

  bool matches(final int rune) =>
      !delegate.matches(rune);

  String toString() =>
      firstNotNull(name, "~($delegate)");
}