part of parsing;

typedef dynamic _MapFunc(dynamic e);
typedef Option _FlatMapFunc(dynamic e);

class _MappedParser<T> extends ParserBase<T> {
  final Parser<T> delegate;
  final _MapFunc f;

  _MappedParser(delegate, f(T t)):
    this.delegate = delegate,
    this.f = f;

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
      "Mapped($delegate)";
}

class _FlatMappedParser<T> extends ParserBase<T> {
  final Parser<T> delegate;
  final _FlatMapFunc f;

  _FlatMappedParser(delegate, Option f(T t)):
    this.delegate = delegate,
    this.f = f;

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
      "FlatMapped($delegate)";
}