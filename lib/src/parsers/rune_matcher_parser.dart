part of restlib.parsing;

class _RuneMatcherParser extends AbstractParser<String> {
  final RuneMatcher matcher;
  
  const _RuneMatcherParser(this.matcher);
  
  Option<String> doParse(final StringIterator itr) =>
    (itr.moveNext() && matcher.matches(itr.current)) ? 
        new Option(new String.fromCharCode(itr.current)) : 
          Option.NONE;
  
  String toString() => 
      "$matcher";
}