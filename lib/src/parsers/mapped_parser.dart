part of parsing;

typedef dynamic _MapFunc(dynamic e);
typedef Option _FlatMapFunc(dynamic e);

class _MappedParser<T> extends ParserBase<T> {
  final Parser<T> delegate;
  final _MapFunc f;
  final String name;

  const _MappedParser(this.delegate, f(T t), [this.name]):
    this.f = f;

  Parser<T> named(final String name) =>
      new _MappedParser(this.delegate, this.f, checkNotNull(name));

  ParseResult<T> parseFrom(final IterableString str) {
    final ParseResult delegateResult = delegate.parseFrom(str);

    return (delegateResult is ParseFailure) ?
        delegateResult :
          delegateResult.left.map(f)
            .map((final T result) =>
                new ParseResult.success(result, delegateResult.next))
            .orCompute(() =>
                new ParseResult.failure(str));
  }

  Future<AsyncParseResult<T>> parseAsync(final Stream<List<int>> bytes, IterableString convert(List<int> bytes)) {
    final ReplayStream<List<int>> stream = new ReplayStream(bytes);

    return delegate.parseAsync(stream, convert).then((final AsyncParseResult result) =>
          result is AsyncParseFailure ?
              result :
                result.left.map(f)
                  .map((final T value) {
                    stream.disableReplay();
                    return new AsyncParseResult.success(value, result.next);
                  }).orCompute(() {
                    return new AsyncParseResult.failure(stream.replay());
                  }));
  }

  String toString() =>
      firstNotNull(name, "Mapped($delegate)");
}

class _FlatMappedParser<T> extends ParserBase<T> {
  final Parser<T> delegate;
  final _FlatMapFunc f;
  final String name;

  _FlatMappedParser(this.delegate, Option f(T t), [this.name]):
    this.f = f;

  Parser<T> named(final String name) =>
      new _FlatMappedParser(this.delegate, this.f, checkNotNull(name));

  ParseResult<T> parseFrom(final IterableString str) {
    final ParseResult delegateResult = delegate.parseFrom(str);

    return (delegateResult is ParseFailure) ?
        delegateResult :
          delegateResult.left.flatMap(f)
            .map((final T result) =>
                new ParseResult.success(result, delegateResult.next))
            .orCompute(() =>
                new ParseResult.failure(str));
  }

  Future<AsyncParseResult<T>> parseAsync(final Stream<List<int>> bytes, IterableString convert(List<int> bytes)) {
    final ReplayStream<List<int>> stream = new ReplayStream(bytes);

    return delegate.parseAsync(stream, convert).then((final AsyncParseResult result) =>
          result is AsyncParseFailure ?
              result :
                result.left.flatMap(f)
                  .map((final T value) {
                    stream.disableReplay();
                    return new AsyncParseResult.success(value, result.next);
                  }).orCompute(() {
                    return new AsyncParseResult.failure(stream.replay());
                  }));
  }

  String toString() =>
      firstNotNull(name, "FlatMapped($delegate)");
}