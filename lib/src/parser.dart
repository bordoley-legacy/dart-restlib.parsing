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

  Either<T, ParseException> parse(String str);

  T parseValue(String str);

  Either<T, ParseException> parseFrom(CodePointIterator itr);

  Parser<Iterable<T>> sepBy(Parser delim);

  Parser<Iterable<T>> sepBy1(Parser delim);
}

class ParseException {
  final int errorPosition;

  ParseException(this.errorPosition);
}