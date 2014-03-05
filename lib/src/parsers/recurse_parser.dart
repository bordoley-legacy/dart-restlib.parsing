part of parsing;

class _RecurseParser<T> extends AbstractParser<T> {
  final delegate;
  
  _RecurseParser(Parser<T> delegate()) :
    this.delegate = delegate;  
  
  Option<T> doParse(final StringIterator itr) =>
      delegate().parseFrom(itr);
  
  String toString() =>
      "rec(${delegate()})";
}