part of parsing;

class _OptionalParser<T> extends ParserBase<Option<T>> {
  final Parser<T> delegate;

  const _OptionalParser(this.delegate);

  ParseResult<Option<T>> parseFrom(final IterableString str) {
    final ParseResult<T> result = delegate.parseFrom(str);
    return (result is ParseSuccess) ?
        new ParseResult.success(result.left, result.next) :
          new ParseResult.success(Option.NONE, result.next);
  }

  String toString() =>
      "Optional($delegate)";
}