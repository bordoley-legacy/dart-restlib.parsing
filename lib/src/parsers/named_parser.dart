part of parsing;

class _NamedParser<T> extends ParserBase<T> {
  final Parser<T> delegate;
  final String name;

  const _NamedParser(this.delegate, this.name);

  Parser<T> named(final String name) =>
      new _NamedParser(delegate, checkNotNull(name));

  ParseResult<T> parseFrom(final IterableString str) =>
      delegate.parseFrom(str);

  String toString() =>
      name;

}