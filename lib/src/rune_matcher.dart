part of restlib.parsing;

abstract class RuneMatcher {
  static final RuneMatcher ALPHA_NUMERIC_MATCHER = 
    new RuneMatcher.inRange('a', 'z') | new RuneMatcher.inRange('A', 'Z') | NUMERIC_MATCHER;
  
  static const RuneMatcher ANY = const _AnyRuneMatcher();
  static const RuneMatcher NONE = const _NoneRuneMatcher();
  
  static final RuneMatcher NUMERIC_MATCHER = new RuneMatcher.inRange("0", "9");

  factory RuneMatcher.anyOf(String runes) =>
     (runes.length == 0) ? NONE : new _AnyOfRuneMatcher(runes); 
  
  factory RuneMatcher.inRange(final String start, final String finish) => 
      new _InRangeRuneMatcher(start.runes.single, finish.runes.single);
  
  factory RuneMatcher.isChar(String rune) =>
      new _SingleRuneMatcher(rune.runes.single);
  
  factory RuneMatcher.noneOf(String runes) =>
      new RuneMatcher.anyOf(runes).negate();
  
  const RuneMatcher._internal();
  
  /**
   * Returns a {@code RuneMatcher} that matches any code point matched by both {@code this} matcher and {@code other}.
   * @param other a non-null {@code RuneMatcher}
   * @throws NullPointerException if {@code other} is null.
   */
  RuneMatcher operator &(RuneMatcher other) => new _AndRuneMatcher(this, other);
  
  /**
   * Returns a {@code RuneMatcher} that matches any code point matched by either {@code this} matcher or {@code other}.
   * @param other a non-null {@code RuneMatcher}
   * @throws NullPointerException if {@code other} is null.
   */
  RuneMatcher operator|(RuneMatcher other) => new _OrRuneMatcher(this, other);
  
  bool matches(int rune);
  
  /**
   * Returns true if a character sequence contains only matching code points.
   * @param in a non-null {@code CharSequence}
   * @throws NullPointerException if {@code in} is null.
   */
  bool matchesAllOf(String val) => 
      val.runes.every(this.matches);
  
  /**
   * Returns true if a character sequence contains no matching code points.
   * @param in a non-null {@code CharSequence}
   * @throws NullPointerException if {@code in} is null.
   */
  bool matchesNoneOf(String val) => 
      val.runes.every((int rune) => !this.matches(rune));
  
  /**
   *  Returns a matcher that matches any code point not matched by this matcher.
   */
  RuneMatcher negate() => new _NegateRuneMatcher(this);
}


