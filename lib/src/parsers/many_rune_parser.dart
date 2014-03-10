part of parsing;

class _ManyRuneParser extends AbstractParser<IterableString> {
  final RuneMatcher matcher;

  const _ManyRuneParser(this.matcher);

  Option<IterableString> doParse(final CodePointIterator itr) {
    final int startIndex = itr.index;
    String result;

    if (itr is StringIterator) {
      while(itr.moveNext() && matcher.matches(itr.current));
      final int endIndex = itr.index;
      result = itr.iterable.toString().substring(startIndex + 1, endIndex);
    } else if (itr.iterable is List<int>) {
      final int endIndex = itr.index;
      result = new String.fromCharCodes(subList(itr.iterable, startIndex + 1, startIndex + 1 + endIndex));
    } else {
      final List<int> buffer = [];
      while(itr.moveNext() && matcher.matches(itr.current)) {
        buffer.add(itr.current);
      }
      result = new String.fromCharCodes(buffer);
    }
    itr.movePrevious();

    return new Option(new IterableString(result));
  }

  String toString() =>
      "($matcher)*";
}