part of restlib.parsing;

class _StringParser extends AbstractParser<String> {
  final String str;
  
  const _StringParser(this.str);
  
  Option<String> doParse(final StringIterator itr) {
    final int startIndx = itr.index + 1;
    final int endIndx = startIndx + str.length;
    
    if (endIndx >= itr.string.length) {
      return Option.NONE;
    } 
    
    if (str == itr.string.substring(startIndx, endIndx)) {
      itr.index = endIndx - 1;
      return new Option(str);
    } else {
      return Option.NONE;
    }
  }
  
  String toString() => 
      "${str}";
}