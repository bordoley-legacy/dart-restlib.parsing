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
      many().map((final Iterable<T> e) =>
          e.isEmpty ? null : e);

  Parser map(dynamic f(T value)) =>
      new _MappedParser(this, f);

  Parser<Option<T>> optional() =>
      new _OptionalParser(this);

  Parser<T> orElse(final T alternative) =>
    optional().map((final Option<T> opt) =>
        opt.orElse(alternative));

  Either<T, ParseError> parse(final String str) =>
      (this + EOF)
        .map((final Pair<T, String> e) => e.e0)
        .parseFrom(new IterableString(str).iterator);

  Either<T, ParseError> parseFrom(final CodePointIterator itr) {
    final int startIndex = itr.index;
    return doParse(itr)
        .map((final T result) => new Either.leftValue(result))
        .orCompute(() {
          final Either<T, ParseError> result = new Either.rightValue(new ParseError(itr.index));
          itr.index = startIndex;
          return result;
        });
  }

  T parseValue(final String str) =>
      computeIfEmpty(parse(str).left, () =>
          throw new ArgumentError("Failed to parse $str")).first;

  Parser<Iterable<T>> sepBy(final Parser delim) {
    final Parser safeDelim = delim.flatMap((_) => const Option.constant(""));
    final Parser<T> safeParser = this.map((final T value) => value);
    final Parser<Iterable<T>> additional =
        (safeDelim + safeParser)
          .map((final Pair<dynamic, T> e) => e.e1)
          .many();

    return (safeParser + additional)
              .map((final Pair<T, Iterable<T>> e) =>
                  EMPTY_SEQUENCE.add(e.e0).addAll(e.e1));
  }

  Parser<Iterable<T>> sepBy1(final Parser delim) =>
    sepBy(delim).map((final Iterable<T> e) =>
        e.isEmpty ? null : e);
}