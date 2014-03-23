part of parsing;

class _FollowedByParser<T> extends ParserBase<T> {
  final Parser<T> parser;
  final Parser next;

  const _FollowedByParser(this.parser, this.next);

  ParseResult parseFrom(final IterableString str) {
    final ParseResult<T> parseResult = parser.parseFrom(str);
    return parseResult.fold(
        (_) {
          final ParseResult nextResult = next.parseFrom(parseResult.next);
          return nextResult.fold(
              (_) => parseResult,
              (final FormatException e) =>
                  e is EndOfFileException ?
                      new ParseResult.eof(str) : new ParseResult.failure(str));
        }, (_) => parseResult);
  }

  String toString() =>
      "$parser.followedBy($next)";
}