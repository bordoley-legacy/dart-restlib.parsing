part of parsing;

class _OrRuneMatcher extends _AbstractRuneMatcher {
  final Iterable<RuneMatcher> matchers;
  final String name;

  const _OrRuneMatcher(this.matchers, [this.name]);

  RuneMatcher named(final String name) =>
      new _OrRuneMatcher(this.matchers, checkNotNull(name));

  bool matches(final int rune) =>
      matchers.any((final RuneMatcher matcher) =>
          matcher.matches(rune));

  String toString() =>
      firstNotNull(name, matchers.join(" | "));
}