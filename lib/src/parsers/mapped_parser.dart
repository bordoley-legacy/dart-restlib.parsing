part of restlib.parsing;

typedef dynamic _MapFunc(dynamic e);

class _MappedParser<T> extends AbstractParser<T> {
  final Parser<T> delegate;
  final _MapFunc f;
  
  _MappedParser(delegate, f(T t)):
    this.delegate = delegate,
    this.f = f;
  
  Option<T> doParse(final StringIterator itr) =>
    delegate.parseFrom(itr).map(f);
  
  String toString() => 
      "Mapped($delegate)";
}