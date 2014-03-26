part of parsing;

class _EitherParser<T1, T2> extends ParserBase<Either<T1, T2>> {
  final Parser<T1> fst;
  final Parser<T2> snd;

  const _EitherParser(this.fst, this.snd);

  ParseResult<Either<T1, T2>> parseFrom(final IterableString str) {
    final ParseResult<T1> fstResult = fst.parseFrom(str);
    if (fstResult is ParseSuccess) {
      return new ParseResult.success(new Either.leftValue(fstResult.value), fstResult.next);
    }

    final ParseResult<T2> sndResult = snd.parseFrom(str);
    if (sndResult is ParseSuccess) {
      return new ParseResult.success(new Either.rightValue(sndResult.value), sndResult.next);
    }

    return (fstResult.value is EndOfFileException ||
        sndResult.value is EndOfFileException) ?
            new ParseResult.eof(str) : new ParseResult.failure(str);
  }

  Future<AsyncParseResult<Either<T1, T2>>> parseAsync(Stream<List<int>> bytes, IterableString convert(List<int> bytes)) =>
    fst.parseAsync(bytes, convert).then((final AsyncParseResult<T1> result1) =>
        result1.fold(
            (final T1 value) => new AsyncParseResult.success(new Either.leftValue(value), result1.next),
            (_) => snd.parseAsync(result1.next, convert)
                    .then((final AsyncParseResult<T2> result2) =>
                        result2.fold(
                            (final T2 value) => new AsyncParseResult.success(new Either.leftValue(value), result2.next),
                            (_) => result2))));

  String toString() =>
      "($fst | $snd)";
}