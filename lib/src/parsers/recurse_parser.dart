part of parsing;

class _RecurseParser<T> extends ParserBase<T> {
  final Function delegate;

  _RecurseParser(Parser<T> delegate()) :
    this.delegate = delegate;

  ParseResult<T> parseFrom(final IterableString str) =>
      delegate().parseFrom(str);

  Future<AsyncParseResult<T>> parseAsync(final Stream<List<int>> bytes, IterableString convert(List<int> bytes)) =>
      delegate().parseAsync(bytes, convert);

  String toString() =>
      "rec(${delegate()})";
}