part of parsing;

class _OrParser<T> extends ParserBase<T> {
  final Iterable<Parser<T>> parsers;

  const _OrParser(this.parsers);

  Either<T, ParseException> parseFrom(final CodePointIterator itr) {
    final int startIndex = itr.index;

    for (final Parser p in parsers) {
      itr.index = startIndex;
      final Either<T, ParseException> result = p.parseFrom(itr);
      if (result is Left) {
        return result;
      }
    }

    return new Either.rightValue(new ParseException(itr.index));
  }
}