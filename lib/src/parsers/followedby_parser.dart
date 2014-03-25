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

  Future<AsyncParseResult<Tuple>> parseAsync(Stream<IterableString> codepoints) {
    final ReplayStream stream1 = new ReplayStream(codepoints);

    parser.parseAsync(stream1).then((final AsyncParseResult<T> result) =>
        result.fold(
            (final T value) {
              final ReplayStream stream2 = new ReplayStream(result.next);

              return next.parseAsync(stream2).then((final AsyncParseResult<T> nextResult) =>
                  nextResult.fold(
                      (_) {
                        stream1.replay(replayEvents:false).listen(null).cancel();
                        return new AsyncParseResult.success(value, stream2.replay());
                      }, (_) {
                        stream2.replay(replayEvents:false).listen(null).cancel();
                        return new AsyncParseResult.failure(stream1.replay());
                      }));
            }, (_) => result));
  }

  String toString() =>
      "$parser.followedBy($next)";
}