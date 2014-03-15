part of parsing;

abstract class AbstractParser<T> implements Parser<T> {
  const AbstractParser();

  Parser<Tuple> operator+(final Parser other) =>
      new _ListParser.concat(this, other);

  Parser<Either<T,dynamic>> operator^(final Parser other) =>
      new _EitherParser(this, other);

  Parser<T> operator|(final Parser<T> other) =>
      new _OrParser(this, other);

  Parser flatMap(Option f(T value)) =>
      new _FlatMappedParser(this, f);

  Parser<T> followedBy(final Parser p) =>
      new _FollowedByParser(this, p);

  Option<T> doParse(CodePointIterator itr);

  Parser<Iterable<T>> many() =>
      new _ManyParser(this);

  Parser<Iterable<T>> many1() =>
      many().map((final Iterable e) =>
          e.isEmpty ? null : e);

  Parser map(dynamic f(T value)) =>
      new _MappedParser(this, f);

  Parser<Option<T>> optional() =>
      new _OptionalParser(this);

  Parser<T> orElse(final T alternative) =>
    optional().map((final Option<T> opt) =>
        opt.orElse(alternative));

  Option<T> parse(final String str) =>
      (this + EOF)
        .map((final Pair<T, String> e) => e.e0)
        .parseFrom(new IterableString(str).iterator);

  Option<T> parseFrom(final CodePointIterator itr) {
    final int startIndex = itr.index;
    final Option<T> token = doParse(itr);

    if (!itr.moveNext()) {
      return Option.NONE;
    }

    itr.movePrevious();
    if (token.isEmpty) {
      itr.index = startIndex;
    }
    return token;
  }

  T parseValue(final String str) =>
      computeIfEmpty(parse(str), () =>
          throw new ArgumentError("Failed to parse $str")).first;

  Parser<Iterable<T>> sepBy(final Parser delim) {
    final Parser<T> safeParser = this.map((final T value) => value);
    final Parser<Iterable<T>> additional =
        (delim + safeParser)
          .map((final Iterable e) =>
              e.last) // Make sure its the last elements since delim can be a list parser
          .many();

    return (safeParser + additional)
              .map((final Iterable e) =>
                  // FIXME: PersistentList should support push since it implements Stack
                  [e.elementAt(0)]..addAll(e.elementAt(1)));
  }

  Parser<Iterable<T>> sepBy1(final Parser delim) =>
    sepBy(delim).map((final Iterable<T> e) =>
        e.isEmpty ? null : e);
}