part of parsing;

class _TupleParser extends ParserBase<Tuple> implements Parser<Tuple> {
  final ImmutableSequence<Parser> _parsers;

  factory _TupleParser(final Parser fst, final Parser snd) {
    ImmutableSequence<Parser> parsers =
        (fst is _TupleParser) ? fst._parsers : EMPTY_SEQUENCE.add(fst);
    parsers =
        (snd is _TupleParser) ? parsers.addAll(snd._parsers) : parsers.add(snd);
    return new _TupleParser._(parsers);
  }

  const _TupleParser._(this._parsers);

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

    Future retval;
    for (final Parser p in _parsers) {
      if (isNull(retval)) {
        retval = p.parseAsync(stream, convert);
      } else {
        retval = retval.then((final AsyncParseResult result) =>
            result.fold(
                (final value) {
                  tokens.add(value);
                  return p.parseAsync(result.next, convert);
                }, (final FormatException e) =>
                    new AsyncParseResult.failure(stream.replay())));
      }
    }

    return retval.then((final AsyncParseResult result) =>
        result.fold(
            (final value) {
              tokens.add(value);
              stream.disableReplay();
              return new AsyncParseResult.success(Tuple.create(tokens), result.next);
            }, (_) => result));
  }

  String toString() =>
      "(" + _parsers.join(" + ") + ")";
}