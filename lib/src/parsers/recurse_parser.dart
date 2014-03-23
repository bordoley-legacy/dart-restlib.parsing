part of parsing;

class _RecurseParser<T> extends ParserBase<T> {
  final Function delegate;

  _RecurseParser(Parser<T> delegate()) :
    this.delegate = delegate;

  ParseResult<T> parseFrom(final IterableString str) =>
      delegate().parseFrom(str);

  String toString() =>
      "rec(${delegate()})";
}