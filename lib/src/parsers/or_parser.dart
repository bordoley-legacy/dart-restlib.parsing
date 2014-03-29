part of parsing;

class _OrParser<T> extends ParserBase<T> {
  final Iterable<Parser<T>> parsers;
  final String name;

  const _OrParser(this.parsers, [this.name]);

  Parser<T> named(final String name) =>
      new _OrParser(parsers, checkNotNull(name));

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

  Future<AsyncParseResult<T>> parseAsync(final Stream<List<int>> bytes, IterableString convert(List<int> bytes)) {
    Future<AsyncParseResult<T>> retval;

    for (final Parser p in parsers) {
      if (isNull(retval)) {
        retval = p.parseAsync(bytes, convert);
      } else {
        retval = retval.then((final AsyncParseResult result) =>
            result.fold(
                (_) => result,
                (_) => p.parseAsync(result.next, convert)));
      }
    }
    return retval;
  }

  String toString() =>
      firstNotNull(name, parsers.join("|"));
}