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

  Parser<T> named(final String name);

  Parser<Option<T>> optional();

  Parser<T> orElse(T alternative);

  ParseResult<T> parse(String str);

  Future<AsyncParseResult<T>> parseAsync(Stream<List<int>> bytes, IterableString convert(List<int> bytes));

  T parseValue(String str);

  ParseResult<T> parseFrom(IterableString str);

  Parser<Iterable<T>> sepBy(Parser delim);

  Parser<Iterable<T>> sepBy1(Parser delim);
}

abstract class ParseResult<T> implements Either<T, FormatException> {
  factory ParseResult.success(final T result, final IterableString next) =>
      new _ParseSuccess(new Either.leftValue(checkNotNull(result)), checkNotNull(next));

  factory ParseResult.failure(final IterableString next, [final String message = ""]) =>
      new _ParseFailure(
          new Either.rightValue(new FormatException(message)),
          checkNotNull(next));

  factory ParseResult.eof(final IterableString next) =>
      new _ParseFailure(
                new Either.rightValue(new EndOfFileException()),
                checkNotNull(next));

  IterableString get next;
}

abstract class ParseSuccess<T> implements Left<T,FormatException>, ParseResult<T> {}

abstract class ParseFailure<T> implements Right<T,FormatException>, ParseResult<T> {}

class _ParseSuccess<T> implements ParseSuccess<T> {
  final Left<T, FormatException> delegate;
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

  Either<FormatException, T> swap() =>
      delegate.swap();

  String toString() =>
      delegate.toString();
}

class _ParseFailure<T> implements ParseFailure<T> {
  final Right<T, FormatException> delegate;
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

  Either<FormatException, T> swap() =>
      delegate.swap();

  String toString() =>
      delegate.toString();
}

class EndOfFileException extends FormatException {
  EndOfFileException() : super("Reached EOF");
}

abstract class AsyncParseResult<T> implements Either<T, FormatException> {
  factory AsyncParseResult.success(final T result, final Stream<List<int>> next) =>
      new _AsyncParseSuccess(new Either.leftValue(checkNotNull(result)), checkNotNull(next));

  factory AsyncParseResult.failure(final Stream<List<int>> next, [final String message = ""]) =>
      new _AsyncParseFailure(
          new Either.rightValue(new FormatException(message)),
          checkNotNull(next));


  Stream<List<int>> get next;
}

abstract class AsyncParseSuccess<T> implements Left<T,FormatException>, AsyncParseResult<T> {}

abstract class AsyncParseFailure<T> implements Right<T,FormatException>, AsyncParseResult<T> {}

class _AsyncParseSuccess<T> implements AsyncParseSuccess<T> {
  final Left<T, FormatException> delegate;
  final Stream<List<int>> next;

  const _AsyncParseSuccess(this.delegate, this.next);

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

  Either<FormatException, T> swap() =>
      delegate.swap();

  String toString() =>
      delegate.toString();
}

class _AsyncParseFailure<T> implements AsyncParseFailure<T> {
  final Right<T, FormatException> delegate;
  final Stream<List<int>> next;

  _AsyncParseFailure(this.delegate, this.next);

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

  Either<FormatException, T> swap() =>
      delegate.swap();

  String toString() =>
      delegate.toString();
}