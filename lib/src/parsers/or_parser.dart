part of parsing;

class _OrParser<T> extends AbstractParser<T> {
  final Parser<T> fst;
  final Parser<T> snd;

  const _OrParser(this.fst, this.snd);

  Option<T> doParse(final CodePointIterator itr) =>
      fst.parseFrom(itr).fold(
          (final T result) => new Option(result),
          (final ParseError error) => snd.parseFrom(itr).left);
}