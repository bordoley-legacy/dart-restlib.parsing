part of restlib.parsing;

class _ListParser extends AbstractParser<PersistentList> implements Parser<PersistentList> {
  final PersistentList<Parser> _parsers;
  
  factory _ListParser.concat(final Parser fst, final Parser snd) {    
    PersistentList<Parser> parsers =
        (fst is _ListParser) ? fst._parsers : PersistentList.EMPTY.add(fst);
    parsers =
        (snd is _ListParser) ? parsers.addAll(snd._parsers) : parsers.add(snd);
    return new _ListParser(parsers);     
  }    
  
  const _ListParser(this._parsers);
  
  Option<PersistentList> doParse(final StringIterator itr) {
    PersistentList tokens = PersistentList.EMPTY;
    
    for(final Parser p in _parsers) {
      final Option parseResult = p.parseFrom(itr);
      if (parseResult.isEmpty) { 
        return Option.NONE;
      } else {
        tokens = tokens.add(parseResult.value);
      }     
    }
    
    return new Option(tokens);
  }
  
  String toString() =>
      "(" + _parsers.join(" + ") + ")";
}