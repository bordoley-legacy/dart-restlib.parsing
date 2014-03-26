part of parsing;

class _EofParser extends ParserBase {
  static const ParseSuccess SUCCESS =
      const _ParseSuccess(
          const Either.leftConstant(const Option.constant("")),
          IterableString.EMPTY);

  const _EofParser();

  Future<AsyncParseResult> parseAsync(Stream<List<int>> bytes, IterableString convert(List<int> bytes)) {
    final ReplayStream<List<int>> stream = new ReplayStream(bytes);
    return stream.any((final List<int> bytes) => bytes.isNotEmpty)
        .then((final bool result) {
          if (result) {
            return new AsyncParseResult.failure(stream.replay());
          }

          stream.disableReplay();
          return new AsyncParseResult.success("", new Stream.fromIterable([]));
        });
  }

  ParseResult parseFrom(final IterableString str) =>
      str.isEmpty ? SUCCESS : new ParseResult.failure(str);

  String toString() =>
      "EOF";
}