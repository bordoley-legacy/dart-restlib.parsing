part of restlib.parsing;

class _OrParser<T> extends AbstractParser<T> {
  final _EitherParser<T,T> delegate;
  
  _OrParser(Parser<T> fst, Parser<T> snd):
    delegate = fst ^ snd;
  
  Option<T> doParse(final StringIterator itr) =>
      delegate.parseFrom(itr).map((final Either<T,T> either) =>
          either.value);
}