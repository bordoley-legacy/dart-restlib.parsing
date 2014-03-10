part of parsing;

class _StringParser extends AbstractParser<String> {
  final IterableString str;
  final Option<String> retval;

  const _StringParser(this.str, this.retval);

  Option<String> doParse(final IndexedIterator<int> itr) {
    final Iterator<int> ref = str.iterator;

    while(ref.moveNext()) {
      if (!itr.moveNext()) {
        return Option.NONE;
      }

      if (itr.current != ref.current) {
        return Option.NONE;
      }
    }
    return retval;
  }

  String toString() =>
      "${str}";
}