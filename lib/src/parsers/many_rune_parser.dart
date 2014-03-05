part of parsing;

class _ManyRuneParser extends AbstractParser<IterableString> {
  final RuneMatcher matcher;
  
  const _ManyRuneParser(this.matcher);
  
  Option<IterableString> doParse(final StringIterator itr) {
    final int startIndex = itr.index;
    
    while(itr.moveNext() && matcher.matches(itr.current));
    
    final int endIndex = itr.index;
    itr.movePrevious();
    
    return new Option(new IterableString(itr.string.substring(startIndex + 1, endIndex)));
  }
  
  String toString() => 
      "($matcher)*";
}