part of parsing;

class _RecurseParser<T> extends ParserBase<T> {
  final Function delegate;
  final String name;

  _RecurseParser(Parser<T> delegate(), [this.name]) :
    this.delegate = delegate;

  Parser<T> named(final String name) =>
      new _RecurseParser(delegate, checkNotNull(name));

  ParseResult<T> parseFrom(final IterableString str) =>
      delegate().parseFrom(str);

  Future<AsyncParseResult<T>> parseAsync(final Stream<List<int>> bytes, IterableString convert(List<int> bytes)) =>
      delegate().parseAsync(bytes, convert);

  String toString() =>
      firstNotNull(name, "rec(${delegate()})");
}