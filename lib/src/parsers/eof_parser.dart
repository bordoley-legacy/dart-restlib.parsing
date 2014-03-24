part of parsing;

class _EofParser extends ParserBase {
  static const ParseSuccess SUCCESS =
      const _ParseSuccess(
          const Either.leftConstant(const Option.constant("")),
          IterableString.EMPTY);

  const _EofParser();

  Future<AsyncParseResult> parseAsync(Stream<IterableString> codepoints) {
    final Completer<AsyncParseResult<T>> completer = new Completer();
    final ReplayStream<IterableString> stream = new ReplayStream(codepoints);

    StreamSubscription subscription;
    subscription = stream.listen(
        (_) {
          final IterableString current = concatStrings(stream.values);
          if (current.isNotEmpty) {
            stream.stopReplay();
            final StreamController<IterableString> controller = new StreamController();
            controller..add(current)..addStream(stream).then((_) => subscription.cancel());
            completer.complete(new AsyncParseResult.failure(controller.stream));
          }
        }, onError: (e, st) {
          stream.stopReplay();
          subscription.cancel();
          completer.completeError(e, st);
        }, onDone: () {
          if (!completer.isCompleted) {
            stream.stopReplay();
            subscription.cancel();
            completer.complete(new AsyncParseResult.success("", new Stream.fromIterable([])));
          }
        });

    return completer.future;
  }

  ParseResult parseFrom(final IterableString str) =>
      str.isEmpty ? SUCCESS : new ParseResult.failure(str);

  String toString() =>
      "EOF";
}