part of parsing;

class _TupleParser extends ParserBase<Tuple> implements Parser<Tuple> {
  factory _TupleParser(final Parser fst, final Parser snd) {
    ImmutableSequence<Parser> parsers =
        (fst is _TupleParser) ? fst._parsers : EMPTY_SEQUENCE.add(fst);
    parsers =
        (snd is _TupleParser) ? parsers.addAll(snd._parsers) : parsers.add(snd);
    return new _TupleParser._(parsers);
  }

  final ImmutableSequence<Parser> _parsers;
  final String name;

  const _TupleParser._(this._parsers, [this.name]);

  Parser<Tuple> named(final String name) =>
      new _TupleParser._(this._parsers, checkNotNull(name));

  ParseResult<Tuple> parseFrom(final IterableString str) {
    final MutableSequence tokens = new GrowableSequence();

    IterableString next = str;
    for (final Parser p in _parsers) {
      final ParseResult result = p.parseFrom(next);
      if (result is ParseFailure) {
        return result.value is EndOfFileException ?
            new ParseResult.eof(str) : new ParseResult.failure(str);
      }

      tokens.add(result.value);
      next = result.next;
    }

    return new ParseResult.success(Tuple.create(tokens), next);
  }

  Future<AsyncParseResult<Tuple>> parseAsync(final Stream<List<int>> bytes, IterableString convert(List<int> bytes)) {
    final MutableSequence tokens = new GrowableSequence();
    final ReplayStream<List<int>> stream = new ReplayStream(bytes);

    Future<AsyncParseResult<Tuple>> retval;
    Iterator<Parser> parserItr = _parsers.iterator;

    Future<AsyncParseResult<Tuple>> doNextParser(final AsyncParseResult result) =>
        result.fold(
            (final value) {
              tokens.add(value);

              if (parserItr.moveNext()) {
                return parserItr.current.parseAsync(result.next, convert).then(doNextParser);
              } else {
                stream.disableReplay();
                return new Future.value(new AsyncParseResult.success(Tuple.create(tokens), result.next));
              }
            }, (final FormatException e) {
              return new Future.value(new AsyncParseResult.failure(stream.replay()));
            });

    if (parserItr.moveNext()) {
      retval = parserItr.current.parseAsync(stream, convert).then(doNextParser);
    } else {
      retval = new Future.error("No parsers");
    }

    return retval;
  }

  String toString() =>
      firstNotNull(name, "(" + _parsers.join(" + ") + ")");
}