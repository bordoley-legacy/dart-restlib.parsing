part of parsing;

class _StringParser extends ParserBase<String> {
  final String retval;

  const _StringParser(this.retval);

  ParseResult<String> parseFrom(final IterableString str) {
    final CodePointIterator ref = new IterableString(retval).iterator;
    final CodePointIterator itr = str.iterator;

    while(ref.moveNext()) {
      if (!itr.moveNext()) {
        return new ParseResult.failure(str);
      }

      if (itr.current != ref.current) {
        return new ParseResult.failure(str);
      }
    }

    return new ParseResult.success(retval, str.substring(itr.index + 1));
  }

  String toString() =>
      "${retval}";
}