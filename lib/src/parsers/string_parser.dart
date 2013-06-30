part of restlib.parsing;

class _StringParser<String> extends AbstractParser<String> {
  final Option<String> retval;
  
  _StringParser(final String str) :
    retval = new Option(str);
  
  Option<String> doParse(final StringIterator itr) {
    final StringIterator expected = new StringIterator(retval.value);
    
    while(expected.moveNext()) { 
      if (itr.moveNext() && itr.current == expected.current) continue;
      return Option.NONE;
    }
    return retval;
  }
  
  String toString() => "${retval.value}";
}