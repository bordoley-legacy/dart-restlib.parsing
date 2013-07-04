part of restlib.parsing;

class _EofParser extends AbstractParser<String> {
  static const EMPTY_STRING_OPTION = const Option.constant("");
  
  const _EofParser();

  Option<String> doParse(final StringIterator itr) =>
      itr.moveNext() ? Option.NONE : _EofParser.EMPTY_STRING_OPTION;
  
  String toString() => "EOF";
}