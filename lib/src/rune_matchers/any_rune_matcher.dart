part of parsing;

class _AnyRuneMatcher extends _AbstractRuneMatcher {
  const _AnyRuneMatcher() : super();

  RuneMatcher operator &(final RuneMatcher other) =>
      other;

  RuneMatcher operator|(final RuneMatcher other) =>
      this;

  Option<int> doParse(final CodePointIterator itr) =>
      (itr.moveNext()) ? new Option(itr.current) : Option.NONE;

  bool matches(final int rune) =>
      true;

  bool matchesAllOf(final String val) =>
      true;

  bool matchesNoneOf(final String val) =>
      false;

  RuneMatcher negate() =>
      NONE;

  String toString() =>
      "*";
}