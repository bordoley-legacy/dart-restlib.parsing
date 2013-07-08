part of restlib.parsing;

abstract class RuneMatcher extends AbstractParser<int> {
  factory RuneMatcher.anyOf(final String runes) =>
     (runes.length == 0) ? NONE : new _AnyOfRuneMatcher(runes); 
  
  factory RuneMatcher.inRange(final String start, final String finish) => 
      new _InRangeRuneMatcher(start.runes.single, finish.runes.single);
  
  factory RuneMatcher.isChar(final String rune) =>
      new _SingleRuneMatcher(rune.runes.single);
  
  factory RuneMatcher.noneOf(final String runes) =>
      new RuneMatcher.anyOf(runes).negate();
  
  const RuneMatcher._internal();
  
  /**
   * Returns a {@code RuneMatcher} that matches any code point matched by both {@code this} matcher and {@code other}.
   * @param other a non-null {@code RuneMatcher}
   * @throws NullPointerException if {@code other} is null.
   */
  RuneMatcher operator &(final RuneMatcher other) => 
      new _AndRuneMatcher(this, other);
  
  /**
   * Returns a {@code RuneMatcher} that matches any code point matched by either {@code this} matcher or {@code other}.
   * @param other a non-null {@code RuneMatcher}
   * @throws NullPointerException if {@code other} is null.
   */
  RuneMatcher operator|(final RuneMatcher other) => 
      new _OrRuneMatcher(this, other);
  
  Option<int> doParse(final StringIterator itr) =>
      (itr.moveNext() && this.matches(itr.current)) ? 
          new Option(itr.current) : 
            Option.NONE;
          
  Parser<IterableString> many() =>
      new _ManyRuneParser(this);    
  
  Parser<IterableString> many1() =>
      super.many1(); 
  
  bool matches(int rune);
  
  /**
   * Returns true if a character sequence contains only matching code points.
   * @param in a non-null {@code CharSequence}
   * @throws NullPointerException if {@code in} is null.
   */
  bool matchesAllOf(final String val) => 
      val.runes.every(this.matches);
  
  /**
   * Returns true if a character sequence contains no matching code points.
   * @param in a non-null {@code CharSequence}
   * @throws NullPointerException if {@code in} is null.
   */
  bool matchesNoneOf(final String val) => 
      val.runes.every((final int rune) => 
          !this.matches(rune));
  
  /**
   *  Returns a matcher that matches any code point not matched by this matcher.
   */
  RuneMatcher negate() => 
      new _NegateRuneMatcher(this);
}


