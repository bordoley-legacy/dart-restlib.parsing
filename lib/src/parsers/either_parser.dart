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

  String toString() =>
      "($fst | $snd)";
}