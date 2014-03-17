part of parsing;

class _EitherParser<T1, T2> extends AbstractParser<Either<T1, T2>> {
  final Parser<T1> fst;
  final Parser<T2> snd;

  const _EitherParser(this.fst, this.snd);

  Option<Either<T1, T2>> doParse(final CodePointIterator itr) =>
      fst.parseFrom(itr)
        .fold((final T1 result) =>
                  new Option(new Either.leftValue(result)),
              (final ParseError error) =>
                  snd.parseFrom(itr).fold(
                      (final T2 result) => new Option(new Either.rightValue(result)),
                      (final ParseError error) => Option.NONE));

  String toString() =>
      "($fst | $snd)";
}