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
    stream1.retain = true;

    parser.parseAsync(stream1).then((final AsyncParseResult<T> result) =>
        result.fold(
            (final T value) {
              final ReplayStream stream2 = new ReplayStream(result.next);
              stream2.retain = true;

              return next.parseAsync(stream2).then((final AsyncParseResult<T> nextResult) =>
                  nextResult.fold(
                      (_) {
                        stream1.retain = false;
                        stream1.stopReplay;

                        final IterableString current = concatStrings(stream2.values);
                        stream2.stopReplay;
                        final StreamController controller = new StreamController();
                        controller..add(current)..addStream(stream2).then((_) => stream2.retain = false);
                        return new AsyncParseResult.success(value, controller.stream);
                      }, (_) {
                        stream2.retain = false;
                        stream2.stopReplay;

                        final IterableString current = concatStrings(stream1.values);
                        stream1.stopReplay;

                        final StreamController controller = new StreamController();
                        controller..add(current)..addStream(stream1).then((_) => stream1.retain = false);
                        return new AsyncParseResult.failure(controller.stream);
                      }));
            }, (_) => result));
  }

  String toString() =>
      "$parser.followedBy($next)";
}