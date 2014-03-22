part of parsing;

class _StringParser extends ParserBase<String> {
  final IterableString str;
  final Left<String> retval;

  const _StringParser(this.str, this.retval);

  Either<String, ParseException> parseFrom(final CodePointIterator itr) {
    final CodePointIterator ref = str.iterator;

    while(ref.moveNext()) {
      if (!itr.moveNext()) {
        return new Either.rightValue(new ParseException(itr.index));
      }

      if (itr.current != ref.current) {
        return new Either.rightValue(new ParseException(itr.index));
      }
    }
    return retval;
  }

  String toString() =>
      "${str}";
}