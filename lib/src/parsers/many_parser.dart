part of parsing;

class _ManyParser<T> extends ParserBase<Iterable<T>> {
  final Parser<T> parser;
  final String name;

  const _ManyParser(this.parser, [this.name]);

  Parser<Iterable<T>> named(final String name) =>
      new _ManyParser(this.parser, checkNotNull(name));

  ParseResult<Iterable<T>> parseFrom(final IterableString str) {
    ImmutableSequence<T> retval = EMPTY_SEQUENCE;
    IterableString next = str;
    ParseResult<T> result;

    while((result = parser.parseFrom(next)) is ParseSuccess) {
      retval = retval.add(result.value);
      next = result.next;
    }

    return new ParseResult.success(retval, result.next);
  }

  Future<AsyncParseResult<Iterable<T>>> doParseAsync(final Stream<List<int>> bytes, IterableString convert(List<int> bytes), final ImmutableSequence acc) =>
      parser.parseAsync(bytes, convert).then((final AsyncParseResult result) =>
          result.fold(
              (final T value) =>
                  doParseAsync(result.next, convert, acc.add(value)),
              (_) =>
                  new AsyncParseResult.success(acc, result.next)));

  Future<AsyncParseResult<Iterable<T>>> parseAsync(Stream<List<int>> bytes, IterableString convert(List<int> bytes)) =>
      doParseAsync(bytes, convert, EMPTY_SEQUENCE);

  String toString() =>
      firstNotNull(name, "($parser)*");
}