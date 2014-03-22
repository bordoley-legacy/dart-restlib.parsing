part of parsing;

class _EitherParser<T1, T2> extends ParserBase<Either<T1, T2>> {
  final Parser<T1> fst;
  final Parser<T2> snd;

  const _EitherParser(this.fst, this.snd);

  Either<Either<T1,T2>, ParseException> parseFrom(final CodePointIterator itr) {
    final int startIndex = itr.index;

    final Either<T1,ParseException> fstResult = fst.parseFrom(itr);
    if (fstResult is Left) {
      return new Either.leftValue(fstResult);
    }

    itr.index = startIndex;
    final Either<T2, ParseException> sndResult = snd.parseFrom(itr);
    if (sndResult is Left) {
      return new Either.leftValue(sndResult.swap());
    }

    return new Either.rightValue(new ParseException(startIndex));
  }

  String toString() =>
      "($fst | $snd)";
}