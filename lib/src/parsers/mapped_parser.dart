part of parsing;

typedef dynamic _MapFunc(dynamic e);
typedef Option _FlatMapFunc(dynamic e);

class _MappedParser<T> extends AbstractParser<T> {
  final Parser<T> delegate;
  final _MapFunc f;

  _MappedParser(delegate, f(T t)):
    this.delegate = delegate,
    this.f = f;

  Option<T> doParse(final CodePointIterator itr) =>
    delegate.parseFrom(itr).map(f);

  String toString() =>
      "Mapped($delegate)";
}

class _FlatMappedParser<T> extends AbstractParser<T> {
  final Parser<T> delegate;
  final _FlatMapFunc f;

  _FlatMappedParser(delegate, Option f(T t)):
    this.delegate = delegate,
    this.f = f;

  Option<T> doParse(final CodePointIterator itr) =>
    delegate.parseFrom(itr).flatMap(f);

  String toString() =>
      "FlatMapped($delegate)";
}