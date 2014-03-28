part of parsing;

abstract class ParserBase<T> implements Parser<T> {
  const ParserBase();

  Parser<Tuple> operator+(final Parser other) =>
      new _TupleParser(this, other);

  Parser<Either<T,dynamic>> operator^(final Parser other) =>
      new _EitherParser(this, other);

  Parser<T> operator|(final Parser<T> other) =>
      new _OrParser([this, other]);

  Parser flatMap(Option f(T value)) =>
      new _FlatMappedParser(this, f);

  Parser<T> followedBy(final Parser p) =>
      new _FollowedByParser(this, p);

  Parser<Iterable<T>> many() =>
      new _ManyParser(this);

  Parser<Iterable<T>> many1() =>
      many().map((final Iterable<T> e) =>
          e.isEmpty ? null : e);

  Parser map(dynamic f(T value)) =>
      new _MappedParser(this, f);

  Parser<Option<T>> optional() =>
      new _OptionalParser(this);

  Parser<T> orElse(final T alternative) =>
    optional().map((final Option<T> opt) =>
        opt.orElse(alternative));

  ParseResult<T> parse(final String str) {
    final Parser<T> safeParser = this.map((final T result) => result);
    return (safeParser + EOF)
        .map((final Pair<T, String> e) => e.e0)
        .parseFrom(new IterableString(str));
  }

  Future<AsyncParseResult<T>> parseAsync(final Stream<List<int>> bytes, IterableString convert(List<int> bytes)) {
    final Completer<AsyncParseResult<T>> completer = new Completer();
    final ReplayStream<List<int>> stream = new ReplayStream(bytes);
    Option<StreamController> controller = Option.NONE;

    stream.listen(
        (final List<int> data) =>
            controller
              .map((final StreamController next) =>
                  next.add(data))
              .orCompute(() {
                final ParseResult<T> result = parseFrom(convert(concatLists(stream.values)));
                result.fold(
                    (final T value) {
                        stream.disableReplay();

                        final StreamController next = new StreamController()..add(result.next.bytes);
                        controller = new Option(next);

                        completer.complete(
                            new AsyncParseResult.success(
                                value, next.stream));
                    },
                    (final FormatException e) {
                      if (e is! EndOfFileException) {
                        completer.complete(
                            new AsyncParseResult.failure(stream.replay()));
                      }
                    });
              }),
        onError: (e, st) {
          controller.map((final StreamController controller) => controller.addError(e,st));
          if (!completer.isCompleted){
            stream.disableReplay();
            completer.completeError(e, st);
          }
        }, onDone: () {
          if (!completer.isCompleted) {
            completer.complete(
                new AsyncParseResult.failure(stream.replay()));
          }
          controller.map((final StreamController controller) => controller.close());
        }, cancelOnError: true
    );

    return completer.future;
  }

  ParseResult<T> parseFrom(IterableString str);

  T parseValue(final String str) =>
      computeIfEmpty(parse(str).left, () =>
          throw new ArgumentError("Failed to parse $str")).first;

  Parser<Iterable<T>> sepBy(final Parser delim) {
    final Parser safeDelim = delim.flatMap((_) => const Option.constant(""));
    final Parser<T> safeParser = this.map((final T value) => value);
    final Parser<Iterable<T>> additional =
        (safeDelim + safeParser)
          .map((final Pair<dynamic, T> e) => e.e1)
          .many();

    return (safeParser + additional)
              .map((final Pair<T, Iterable<T>> e) =>
                  EMPTY_SEQUENCE.add(e.e0).addAll(e.e1));
  }

  Parser<Iterable<T>> sepBy1(final Parser delim) =>
    sepBy(delim).map((final Iterable<T> e) =>
        e.isEmpty ? null : e);
}