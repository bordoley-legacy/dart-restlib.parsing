part of parsing;

typedef dynamic _MapFunc(dynamic e);
typedef Option _FlatMapFunc(dynamic e);

class _MappedParser<T> extends ParserBase<T> {
  final Parser<T> delegate;
  final _MapFunc f;

  _MappedParser(delegate, f(T t)):
    this.delegate = delegate,
    this.f = f;

  Option<T> doParse(final CodePointIterator itr) =>
    delegate.parseFrom(itr).left.map(f);

  Either<T, ParseException> parseFrom(final CodePointIterator itr) {
    final int startIndex = itr.index;
    final Option<T> result = delegate.parseFrom(itr).left.map(f);
    if (result is Some) {
      return new Either.leftConstant(result);
    }

    return new Either.rightValue(new ParseException(startIndex));
  }

  String toString() =>
      "Mapped($delegate)";
}

class _FlatMappedParser<T> extends ParserBase<T> {
  final Parser<T> delegate;
  final _FlatMapFunc f;

  _FlatMappedParser(delegate, Option f(T t)):
    this.delegate = delegate,
    this.f = f;

  Either<T, ParseException> parseFrom(final CodePointIterator itr) {
    final int startIndex = itr.index;
    final Option<T> result = delegate.parseFrom(itr).left.flatMap(f);
    if (result is Some) {
      return new Either.leftConstant(result);
    }

    return new Either.rightValue(new ParseException(startIndex));
  }

  String toString() =>
      "FlatMapped($delegate)";
}