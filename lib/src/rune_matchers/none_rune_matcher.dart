part of parsing;

class _NoneRuneMatcher extends _AbstractRuneMatcher {
  const _NoneRuneMatcher() : super();

  RuneMatcher operator&(final RuneMatcher other) =>
      this;

  RuneMatcher operator|(final RuneMatcher other) =>
      other;

  Option<int> doParse(final CodePointIterator itr) =>
      Option.NONE;

  bool matches(final int rune) =>
      false;

  bool matchesAllOf(final String val) =>
      false;

  bool matchesNoneOf(final String val) =>
      true;

  RuneMatcher negate() =>
      ANY;

  String toString() =>
      "none";
}
