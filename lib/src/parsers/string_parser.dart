part of parsing;

class _StringParser extends ParserBase<String> {
  final String retval;
  final String name;

  const _StringParser(this.retval, [this.name]);

  Parser<String> named(final String name) =>
      new _StringParser(this.retval, name);

  ParseResult<String> parseFrom(final IterableString str) {
    final CodePointIterator ref = new IterableString(retval).iterator;
    final CodePointIterator itr = str.iterator;

    while(ref.moveNext()) {
      if (!itr.moveNext()) {
        return new ParseResult.eof(str);
      }

      if (itr.current != ref.current) {
        return new ParseResult.failure(str);
      }
    }

    return new ParseResult.success(retval, str.substring(itr.index + 1));
  }

  String toString() =>
      firstNotNull(name, "${retval}");
}