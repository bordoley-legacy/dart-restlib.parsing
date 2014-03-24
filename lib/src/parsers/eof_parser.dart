part of parsing;

class _EofParser extends ParserBase {
  static const ParseSuccess SUCCESS =
      const _ParseSuccess(
          const Either.leftConstant(const Option.constant("")),
          IterableString.EMPTY);

  const _EofParser();

  Future<AsyncParseResult> parseAsync(Stream<IterableString> codepoints) {
    final ReplayStream<IterableString> stream = new ReplayStream(codepoints);
    stream.retain = true;

    return stream.firstWhere((final IterableString str) =>
        str.isNotEmpty, defaultValue: () =>
            IterableString.EMPTY).then((final IterableString str) {
              if (str.isEmpty) {
                return new AsyncParseResult.success("", new Stream.fromIterable([]));
              }

              final IterableString current = concatStrings(stream.values);
              stream.stopReplay;
              final StreamController controller = new StreamController();
              controller..add(current)..addStream(stream).then((_) => stream.retain = false);
              return new AsyncParseResult.failure(controller.stream);
            });
  }

  ParseResult parseFrom(final IterableString str) =>
      str.isEmpty ? SUCCESS : new ParseResult.failure(str);

  String toString() =>
      "EOF";
}