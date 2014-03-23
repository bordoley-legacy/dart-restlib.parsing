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

  ParseResult<T> parse(String str);

  T parseValue(String str);

  ParseResult<T> parseFrom(IterableString str);

  Parser<Iterable<T>> sepBy(Parser delim);

  Parser<Iterable<T>> sepBy1(Parser delim);
}

abstract class ParseResult<T> implements Either<T, FormatException> {
  factory ParseResult.success(final T result, final IterableString next) =>
      new _ParseSuccess(new Either.leftValue(checkNotNull(result)), checkNotNull(next));

  factory ParseResult.failure(final IterableString next) =>
      new _ParseFailure(
          new Either.rightValue(new FormatException()),
          checkNotNull(next));

  IterableString get next;
}

abstract class ParseSuccess<T> implements Left<T>, ParseResult<T> {}

abstract class ParseFailure implements Right<FormatException>, ParseResult {}

class _ParseSuccess<T> implements ParseSuccess<T> {
  final Left<T> delegate;
  final IterableString next;

  const _ParseSuccess(this.delegate, this.next);

  int get hashCode =>
      delegate.hashCode;

  Some<T> get left =>
      delegate.left;

  None get right =>
      delegate.right;

  T get value =>
      delegate.value;

  bool operator==(other) =>
      delegate == other;

  dynamic fold(onLeft(T left), onRight(dynamic right)) =>
      delegate.fold(onLeft, onRight);

  Either<dynamic, T> swap() =>
      delegate.swap();

  String toString() =>
      delegate.toString();
}

class _ParseFailure implements ParseFailure {
  final Right<FormatException> delegate;
  final IterableString next;

  _ParseFailure(this.delegate, this.next);

  int get hashCode =>
      delegate.hashCode;

  None get left =>
        delegate.left;

  Some<FormatException> get right =>
      delegate.right;

  FormatException get value =>
      delegate.value;

  bool operator==(other) =>
      delegate == other;

  dynamic fold(onLeft(dynamic left), onRight(FormatException right)) =>
      delegate.fold(onLeft, onRight);

  Either<FormatException, dynamic> swap() =>
      delegate.swap();

  String toString() =>
      delegate.toString();
}
