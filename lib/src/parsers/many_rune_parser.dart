part of parsing;

class _ManyRuneParser extends ParserBase<IterableString> {
  final RuneMatcher matcher;
  final String name;

  const _ManyRuneParser(this.matcher, [this.name]);

  Parser<IterableString> named(final String name) =>
      new _ManyRuneParser(this.matcher, checkNotNull(name));

  ParseResult<IterableString> parseFrom(final IterableString str) {
    final CodePointIterator itr = str.iterator;
    while(itr.moveNext() && matcher.matches(itr.current));
    itr.movePrevious();
    return new ParseResult.success(
        str.substring(0, itr.index + 1), str.substring(itr.index + 1));
  }

  String toString() =>
      firstNotNull(name, "($matcher)*");
}