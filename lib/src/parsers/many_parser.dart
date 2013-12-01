part of restlib.parsing;

class _ManyParser<T> extends AbstractParser<Iterable<T>> {
  final Parser<T> delegate;
  
  const _ManyParser(this.delegate);
  
  Option<Iterable<T>> doParse(final StringIterator itr) {
    PersistentSequence<T> retval = PersistentSequence.EMPTY;
    
    Option<T> t = Option.NONE;
    while ((t = delegate.parseFrom(itr)).isNotEmpty) {
      retval = retval.add(t.value);
    }

    return new Option(retval);
  }
  
  String toString() => 
      "($delegate)*";
}