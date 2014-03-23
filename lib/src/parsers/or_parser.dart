part of parsing;

class _OrParser<T> extends ParserBase<T> {
  final Iterable<Parser<T>> parsers;

  const _OrParser(this.parsers);

  ParseResult<T> parseFrom(final IterableString str) {
    bool eof = false;
    for (final Parser p in parsers) {
      final ParseResult result = p.parseFrom(str);
      if (result is ParseSuccess) {
        return result;
      }

      if (result.value is EndOfFileException) {
        eof = true;
      }
    }

    return eof ? new ParseResult.eof(str) : new ParseResult.failure(str);
  }
}