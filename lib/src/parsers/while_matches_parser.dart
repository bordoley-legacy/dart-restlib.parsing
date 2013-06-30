part of restlib.parsing;

class _WhileMatchesParser<String> extends AbstractParser<String> {
  final RuneMatcher matcher;
  
  const _WhileMatchesParser(this.matcher);
  
  Option<String> doParse(final StringIterator itr) {
    final int startIndex = itr.index;
    
    while(itr.moveNext() && matcher.matches(itr.current));
    
    final int endIndex = itr.index;
    itr.movePrevious();
    
    return (endIndex > (startIndex + 1)) ? 
        new Option(itr.string.substring(startIndex + 1, endIndex)) : Option.NONE;
  }
  
  String toString() => "*$matcher";
}