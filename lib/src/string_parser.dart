part of restlib.parsing;

abstract class StringParser extends AbstractParser<String> {
  const StringParser._internal();
  
  StringParser operator|(final StringParser other) => 
      new _OrStringParser(this, other);
  
   Option<String> doParse(final StringIterator itr);    
}

class _OrStringParser extends StringParser { 
  factory _OrStringParser(final StringParser fst, final StringParser snd) {
    ImmutableSequence<StringParser> matchers = Persistent.EMPTY_SEQUENCE;
    matchers = (fst is _OrStringParser) ? 
        fst.matchers : matchers.add(fst);
    matchers = (snd is _OrStringParser) ? 
        matchers.addAll(snd.matchers) : matchers.add(snd);
        
    return new _OrStringParser._internal(matchers);     
  }
  
  final ImmutableSequence<StringParser> matchers;
  
  const _OrStringParser._internal(this.matchers) : super._internal();
  
  Option<String> doParse(final StringIterator itr) {
    for (final StringParser matcher in matchers) {
      final Option<String> retval = matcher.parseFrom(itr);
      if (retval.isNotEmpty) {
        return retval;
      }
    }
    
    return Option.NONE;
  }
}

class _SingleStringParser extends StringParser {
  final String str;
  
  const _SingleStringParser(this.str) : super._internal();
  
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