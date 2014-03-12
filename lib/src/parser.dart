part of parsing;

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

  Option<T> parseFrom(CodePointIterator itr);

  Parser<Iterable<T>> sepBy(Parser delim);

  Parser<Iterable<T>> sepBy1(Parser delim);
}

abstract class ParseResultNone implements None {
  static const ParseResultNone NONE_REACHED_EOF = const _ParseResultNone(true);
  static const ParseResultNone NONE = const _ParseResultNone(false);

  bool get reachedEof;
}

class _ParseResultNone extends IterableBase implements None, ParseResultNone {
  final bool reachedEof;

  const _ParseResultNone(this.reachedEof);

  Iterator get iterator => Option.NONE.iterator;

  get nullableValue => Option.NONE.nullableValue;

  get value => Option.NONE.value;

  Option flatMap(Option f(element)) => Option.NONE.flatMap(f);

  Option map(f(element)) => Option.NONE.map(f);

  dynamic orCompute(dynamic call()) => Option.NONE.orCompute(call);

  dynamic orElse(final dynamic alternative) => Option.NONE.orElse(alternative);

  Option skip(final int n) => Option.NONE.skip(n);

  Option skipWhile(bool test(value)) => Option.NONE.skipWhile(test);

  Option takeWhile(bool test(value)) => Option.NONE.takeWhile(test);

  Option where(bool f(element)) => Option.NONE.where(f);
}
