part of parsing;

class _OptionalParser<T> extends ParserBase<Option<T>> {
  static const Left<None> EMPTY_RESULT  = const Either.leftConstant(const Option.constant(Tuple.NONE));

  final Parser<T> delegate;

  const _OptionalParser(this.delegate);

  Either<Option<T>, ParseException> parseFrom(final CodePointIterator itr) {
    final startIndex = itr.index;
    final Either<T, ParseException> result = delegate.parseFrom(itr);
    if (result is Left) {
      return new Either.leftValue(result.left);
    }

    itr.index = startIndex;
    return EMPTY_RESULT;
  }


  String toString() =>
      "Optional($delegate)";
}