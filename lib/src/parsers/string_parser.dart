part of parsing;

class _StringParser extends ParserBase<String> {
  final IterableString str;
  final String retval;

  const _StringParser(this.str, this.retval);

  ParseResult<String> parseFrom(final IterableString str) {
    final CodePointIterator ref = this.str.iterator;
    final CodePointIterator itr = str.iterator;

    while(ref.moveNext()) {
      if (!itr.moveNext()) {
        return new ParseResult.failure(str);
      }

      if (itr.current != ref.current) {
        return new ParseResult.failure(str);
      }
    }

    return new ParseResult.success(retval, str.substring(itr.index));
  }

  String toString() =>
      "${str}";
}