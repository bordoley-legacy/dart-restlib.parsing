part of parsing;

abstract class Parser<T> {
  Parser<Tuple> operator+(Parser other);

  Parser<Either<T,dynamic>> operator^(Parser other);

  Parser<T> operator|(Parser<T> other);

  Parser flatMap(Option f(T value));

  Parser<T> followedBy(Parser p);

  /// p* in EBNF.
  Parser<Iterable<T>> many();

  /// p+ in EBNF.
  Parser<Iterable<T>> many1();

  Parser map(dynamic f(T value));

  Parser<Option<T>> optional();

  Parser<T> orElse(T alternative);

  Either<T, ParseError> parse(String str);

  T parseValue(String str);

  Either<T, ParseError> parseFrom(CodePointIterator itr);

  Parser<Iterable<T>> sepBy(Parser delim);

  Parser<Iterable<T>> sepBy1(Parser delim);
}

abstract class ParseError {
  factory ParseError(int errorPosition) {
    checkArgument(errorPosition > -1);
    return new ParseError(errorPosition);
  }

  int get errorPosition;
}

class _ParseError {
  final int errorPosition;

  _ParseError(this.errorPosition);
}