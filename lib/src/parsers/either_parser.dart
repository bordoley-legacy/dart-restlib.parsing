part of restlib.parsing;

class _EitherParser<T1, T2> extends AbstractParser<Either<T1, T2>> {
  final Parser<T1> fst;
  final Parser<T2> snd;
  
  const _EitherParser(this.fst, this.snd);
  
  Option<Either<T1, T2>> doParse(final StringIterator itr) {
    final Option retval = fst.parseFrom(itr).map((final T1 e) => 
            new Either.leftValue(e));
    
    return retval.isNotEmpty ? retval : 
      snd.parseFrom(itr)
        .map((final T2 e) => 
          new Either.rightValue(e));
  }
  
  String toString() => 
      "($fst | $snd)";
}