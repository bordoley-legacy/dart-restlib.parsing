part of parsing;

class _OptionalParser<T> extends ParserBase<Option<T>> {
  final Parser<T> delegate;
  final String name;

  const _OptionalParser(this.delegate, [this.name]);

  Parser<Option<T>> named(final String name) =>
      new _OptionalParser(this.delegate, checkNotNull(name));

  ParseResult<Option<T>> parseFrom(final IterableString str) {
    final ParseResult<T> result = delegate.parseFrom(str);
    return (result is ParseSuccess) ?
        new ParseResult.success(result.left, result.next) :
          new ParseResult.success(Option.NONE, result.next);
  }


  Future<AsyncParseResult<Option<T>>> parseAsync(final Stream<List<int>> bytes, IterableString convert(List<int> bytes)) =>
      delegate.parseAsync(bytes, convert).then((final AsyncParseResult<T> result) =>
          (result is AsyncParseSuccess) ?
              new AsyncParseResult.success(result.left, result.next) :
                new AsyncParseResult.success(Option.NONE, result.next));

  String toString() =>
      firstNotNull(name, "Optional($delegate)");
}