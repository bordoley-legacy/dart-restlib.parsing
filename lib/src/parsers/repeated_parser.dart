part of restlib.parsing;

class _RepeatedParser<T> extends AbstractParser<Iterable<T>> {
  final Parser<T> delegate;
  final int min;
  final int max;
  
  const _RepeatedParser(this.delegate, this.min, this.max);
  
  Option<T> doParse(final StringIterator itr) {
    final List<T> retval = [];
    for (int i = 0; i < max; i++) {
      retval.add(parseFrom(itr));
    }
    
    return (retval.length > min) ? new Option(retval) : Option.NONE; 
  }
  
  String toString() => "$delegate[$min, $max]";
}