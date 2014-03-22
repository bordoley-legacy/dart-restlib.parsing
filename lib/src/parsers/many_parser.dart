part of parsing;

class _ManyParser<T> extends ParserBase<Iterable<T>> {
  final Parser<T> delegate;

  const _ManyParser(this.delegate);

  Either<Iterable<T>, ParseException> parseFrom(final CodePointIterator itr) {
    ImmutableSequence<T> retval = EMPTY_SEQUENCE;

    while(true) {
      final int startIndex = itr.index;
      final Option<T> result = delegate.parseFrom(itr).left;

      if (result is None) {
        itr.index = startIndex;
        break;
      }

      retval = retval.add(result.value);
    }

    return new Either.leftValue(retval);
  }

  String toString() =>
      "($delegate)*";
}