part of parsing;

class _ManyRuneParser extends ParserBase<IterableString> {
  final RuneMatcher matcher;

  const _ManyRuneParser(this.matcher);

  ParseResult<IterableString> parseFrom(final IterableString str) {
    final CodePointIterator itr = str.iterator;
    while(itr.moveNext() && matcher.matches(itr.current));
    final IterableString result = itr.iterable.substring(0, itr.index + 1);
    return new ParseResult.success(result, str.substring(itr.index + 1));
  }

  String toString() =>
      "($matcher)*";
}