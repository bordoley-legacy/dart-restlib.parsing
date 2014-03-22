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

  Either<Tuple, ParseException> parseFrom(final CodePointIterator itr) {
    final MutableSequence tokens = new GrowableSequence();

    for(final Parser p in _parsers) {
      final Either<dynamic, ParseException> parseResult = p.parseFrom(itr);

      if (parseResult is Right) {
        return parseResult;
      }

      tokens.add(parseResult.value);
    }

    return new Either.leftValue(Tuple.create(tokens));
  }

  String toString() =>
      "(" + _parsers.join(" + ") + ")";
}