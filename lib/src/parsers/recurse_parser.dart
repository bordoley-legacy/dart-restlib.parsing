part of parsing;

class _RecurseParser<T> extends ParserBase<T> {
  final Function delegate;

  _RecurseParser(Parser<T> delegate()) :
    this.delegate = delegate;

  Either<T, ParseException> parseFrom(final CodePointIterator itr) =>
      delegate().parseFrom(itr);

  String toString() =>
      "rec(${delegate()})";
}