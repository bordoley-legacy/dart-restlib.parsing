part of parsing;

class _OrRuneMatcher extends _AbstractRuneMatcher {
  final Iterable<RuneMatcher> matchers;

  const _OrRuneMatcher(this.matchers) : super();

  bool matches(final int rune) =>
      matchers.any((final RuneMatcher matcher) =>
          matcher.matches(rune));

  String toString() =>
      "(" + matchers.join(" | ") + ")";
}