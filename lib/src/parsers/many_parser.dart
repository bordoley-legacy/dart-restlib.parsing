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

  String toString() =>
      "($delegate)*";
}