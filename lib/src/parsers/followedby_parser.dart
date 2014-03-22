part of parsing;

class _FollowedByParser<T> extends ParserBase<T> {
  final Parser<T> parser;
  final Parser next;

  const _FollowedByParser(this.parser, this.next);

  Either<T, ParseException> parseFrom(final CodePointIterator itr) {
    final Either<T, ParseException> parseResult = parser.parseFrom(itr);
    return parseResult.fold(
        (_)  {
          final int startPos = itr.index;
          final Either<dynamic, ParseException> nextResult = next.parseFrom(itr);
          return nextResult.fold(
              (_) {
                itr.index = startPos;
                return parseResult;
              }, (_) => nextResult);
        }, (_) => parseResult);
  }

  String toString() =>
      "$parser.followedBy($next)";
}