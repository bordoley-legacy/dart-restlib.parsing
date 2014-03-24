part of parsing;

class _ManyParser<T> extends ParserBase<Iterable<T>> {
  final Parser<T> delegate;

  const _ManyParser(this.delegate);

  ParseResult<Iterable<T>> parseFrom(final IterableString str) {
    ImmutableSequence<T> retval = EMPTY_SEQUENCE;
    IterableString next = str;
    ParseResult<T> result;

    while((result = delegate.parseFrom(next)) is ParseSuccess) {
      retval = retval.add(result.value);
      next = result.next;
    }

    return new ParseResult.success(retval, result.next);
  }

  Future<AsyncParseResult<Iterable<T>>> doParseAsync(final Parser<T> parser, Stream<IterableString> codepoints, final ImmutableSequence acc) =>
      parser.parseAsync(codepoints).then((final AsyncParseResult result) =>
          result.fold(
              (final T value) =>
                  doParseAsync(parser, result.next, acc.add(value)),
              (_) =>
                  new AsyncParseResult.success(acc, result.next)));

  Future<AsyncParseResult<Iterable<T>>> parseAsync(Stream<IterableString> codepoints) =>
      doParseAsync(delegate, codepoints, EMPTY_SEQUENCE);

  String toString() =>
      "($delegate)*";
}