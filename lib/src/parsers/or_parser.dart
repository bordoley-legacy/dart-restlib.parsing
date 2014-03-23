part of parsing;

class _OrParser<T> extends ParserBase<T> {
  final Iterable<Parser<T>> parsers;

  const _OrParser(this.parsers);

  ParseResult<T> parseFrom(final IterableString str) {
    for (final Parser p in parsers) {
      final ParseResult result = p.parseFrom(str);
      if (result is ParseSuccess) {
        return result;
      }
    }

    return new ParseResult.failure(str);
  }
}