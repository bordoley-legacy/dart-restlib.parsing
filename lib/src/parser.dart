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
        .map((final Iterable e) =>
          e.first)
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

abstract class Parser<T> {
  Parser<Tuple> operator+(Parser other);

  Parser<Either<T,dynamic>> operator^(Parser other);

  Parser<T> operator|(final Parser<T> other);

  Parser flatMap(Option f(T value));

  Parser<T> followedBy(Parser p);

  /// p* in EBNF.
  Parser<Iterable<T>> many();

  /// p+ in EBNF.
  Parser<Iterable<T>> many1();

  Parser map(dynamic f(T value));

  Parser<Option<T>> optional();

  Parser<T> orElse(final T alternative);

  Option<T> parse(String str);

  T parseValue(String str);

  // Parse a value from the CodePointIterator. If EOF is reached, Option.NONE is returned and
  // the iterator is not reset. If parsing fails before reaching EOF, the iterator is reset to the start point.
  Option<T> parseFrom(CodePointIterator itr);

  Parser<Iterable<T>> sepBy(Parser delim);

  Parser<Iterable<T>> sepBy1(Parser delim);
}