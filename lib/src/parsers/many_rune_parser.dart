part of parsing;

class _ManyRuneParser extends ParserBase<IterableString> {
  final RuneMatcher matcher;

  const _ManyRuneParser(this.matcher);

  Either<IterableString, ParseException> parseFrom(final CodePointIterator itr) {
    final int startIndex = itr.index;

    while(itr.moveNext() && matcher.matches(itr.current));
    final int endIndex = itr.index;
    final IterableString result = itr.iterable.substring(startIndex + 1, endIndex);

    itr.movePrevious();

    return new Either.leftValue(result);
  }

  String toString() =>
      "($matcher)*";
}