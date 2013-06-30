part of restlib.parsing;

final Parser<String> EMPTY = stringParser("");

Parser<String> charParser(final String char) =>
    runeParser(new RuneMatcher.isChar(char));

Parser<String> runeParser(final RuneMatcher matcher) =>
    new _RuneMatcherParser(matcher);

Parser<String> whileMatchesParser(final RuneMatcher matcher) =>
  new _WhileMatchesParser(matcher);

Parser<String> stringParser(final String string) => 
    new _StringParser(string);

abstract class AbstractParser<T> implements Parser<T> {
  const AbstractParser();
  
  Parser<Iterable> operator+(final Parser other) => 
      new _ListParser.concat(this, other);
  
  Parser<Either<T,dynamic>> operator|(final Parser other) =>
      new _OrParser(this, other);      
  
  Option<T> doParse(StringIterator itr);
  
  Parser<Iterable<T>> many() => 
      new _ManyParser(this);

  Parser<Iterable<T>> many1() =>
      many().map((final Iterable e) => 
          e.isEmpty ? null : e);
  
  Parser map(dynamic f(T value)) =>
      new _MappedParser(this, f);      
  
  Option<T> parse(final String str) =>
      parseFrom(new StringIterator(str));
  
  Option<T> parseFrom(StringIterator itr) {
    final int startIndex = itr.index;
    final Option<T> token = doParse(itr);
    if (token.isEmpty) {
      itr.index = startIndex;
    }
    return token; 
  }
  
  Parser<Iterable<T>> sepBy(final Parser delim) {
    final Parser<Iterable<T>> additional =
        (delim + this)
          .map((final Iterable e) =>
              e.elementAt(1))
          .many();
          
    return (this + additional)
              .map((final Iterable e) =>
                  // FIXME: PersistentList should support push since it implements Stack
                  [e.elementAt(0)]..addAll(e.elementAt(1)));
  }
  
  Parser<Iterable<T>> sepBy1(final Parser delim) =>
    sepBy(delim).map((final Iterable<T> e) => 
        e.isEmpty ? null : e);
  
  Parser<Iterable<T>> times({final int min:0, final int max:null}) =>
      isNull(max) ?
          many().map((final Iterable<T> e) =>
              e.length > min ? e : null) :
                new _RepeatedParser(this,min, max);
}          
 
abstract class Parser<T> {    
  Parser<Iterable> operator+(Parser other);
  
  Parser<Either<T,dynamic>> operator|(Parser other);
  
  /// p.many() is equivalent to p* in EBNF.
  Parser<Iterable<T>> many();
  
  /// p.many1() is equivalent to p+ in EBNF.
  Parser<Iterable<T>> many1();
  
  Parser map(dynamic f(T value));
  
  Option<T> parse(String str);
  
  Option<T> parseFrom(StringIterator itr);
  
  Parser<Iterable<T>> sepBy(Parser delim);
  
  Parser<Iterable<T>> sepBy1(Parser delim);
  
  Parser<Iterable> times({min:0, max:null});
}