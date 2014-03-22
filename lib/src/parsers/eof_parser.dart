part of parsing;

class _EofParser extends ParserBase<String> {
  static const Left<String> RETVAL = const Either.leftConstant(const Option.constant(""));

  const _EofParser();

  Either<String, ParseException> parseFrom(final CodePointIterator itr) =>
      itr.moveNext() ? new Either.rightValue(new ParseException(itr.index)) : RETVAL;

  String toString() =>
      "EOF";
}