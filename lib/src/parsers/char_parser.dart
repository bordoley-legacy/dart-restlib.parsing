part of restlib.parsing;

class _CharParser extends AbstractParser<String> {
  final int char;
  final Option<String> charAsString; 
  
  const _CharParser(this.char, this.charAsString);

  Option<String> doParse(final StringIterator itr) =>
      (itr.moveNext() && itr.current == char) ? 
          charAsString : Option.NONE;
  
  String toString() => 
      charAsString.value;
}