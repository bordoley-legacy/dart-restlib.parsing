part of parsing;

class _ManyRuneParser extends AbstractParser<IterableString> {
  final RuneMatcher matcher;

  const _ManyRuneParser(this.matcher);

  Option<IterableString> doParse(final CodePointIterator itr) {
    final int startIndex = itr.index;

    while(itr.moveNext() && matcher.matches(itr.current));
    final int endIndex = itr.index;
    final IterableString result = itr.iterable.substring(startIndex + 1, endIndex);

    itr.movePrevious();

    return new Option(result);
  }

  String toString() =>
      "($matcher)*";
}