part of parsing;

class _FollowedByParser<T> extends ParserBase<T> {
  final Parser<T> parser;
  final Parser next;
  final String name;

  const _FollowedByParser(this.parser, this.next, [this.name]);

  Parser<T> named(final String name) =>
      new _FollowedByParser(this.parser, this.next, checkNotNull(name));

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

  Future<AsyncParseResult<Tuple>> parseAsync(final Stream<List<int>> bytes, IterableString convert(List<int> bytes)) {
    final ReplayStream<List<int>> stream1 = new ReplayStream(bytes);

    return parser.parseAsync(stream1, convert).then((final AsyncParseResult<T> result) =>
        result.fold(
            (final T value) {
              final ReplayStream<List<int>> stream2 = new ReplayStream(result.next);

              return next.parseAsync(stream2, convert).then((final AsyncParseResult<T> nextResult) =>
                  nextResult.fold(
                      (_) {
                        stream1.disableReplay();
                        return new AsyncParseResult.success(value, stream2.replay());
                      }, (_) {
                        stream2.disableReplay();
                        return new AsyncParseResult.failure(stream1.replay());
                      }));
            }, (_) => result));
  }

  String toString() =>
      firstNotNull(name, "$parser.followedBy($next)");
}