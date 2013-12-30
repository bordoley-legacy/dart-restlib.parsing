part of restlib.parsing;

class _ListParser extends AbstractParser<ImmutableSequence> implements Parser<ImmutableSequence> {
  final ImmutableSequence<Parser> _parsers;
  
  factory _ListParser.concat(final Parser fst, final Parser snd) {    
    ImmutableSequence<Parser> parsers =
        (fst is _ListParser) ? fst._parsers : Persistent.EMPTY_SEQUENCE.add(fst);
    parsers =
        (snd is _ListParser) ? parsers.addAll(snd._parsers) : parsers.add(snd);
    return new _ListParser(parsers);     
  }    
  
  const _ListParser(this._parsers);
  
  Option<ImmutableSequence> doParse(final StringIterator itr) {
    ImmutableSequence tokens = Persistent.EMPTY_SEQUENCE;
    
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