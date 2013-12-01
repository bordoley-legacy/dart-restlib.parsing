part of restlib.parsing;

class _ListParser extends AbstractParser<PersistentSequence> implements Parser<PersistentSequence> {
  final PersistentSequence<Parser> _parsers;
  
  factory _ListParser.concat(final Parser fst, final Parser snd) {    
    PersistentSequence<Parser> parsers =
        (fst is _ListParser) ? fst._parsers : PersistentSequence.EMPTY.add(fst);
    parsers =
        (snd is _ListParser) ? parsers.addAll(snd._parsers) : parsers.add(snd);
    return new _ListParser(parsers);     
  }    
  
  const _ListParser(this._parsers);
  
  Option<PersistentSequence> doParse(final StringIterator itr) {
    PersistentSequence tokens = PersistentSequence.EMPTY;
    
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