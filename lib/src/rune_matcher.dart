part of parsing;

abstract class RuneMatcher implements Parser<int> {

  /**
   * Returns a {@code RuneMatcher} that matches any code point matched by both {@code this} matcher and {@code other}.
   * @param other a non-null {@code RuneMatcher}
   * @throws NullPointerException if {@code other} is null.
   */
  RuneMatcher operator &(final RuneMatcher other);

  /**
   * Returns a {@code RuneMatcher} that matches any code point matched by either {@code this} matcher or {@code other}.
   * @param other a non-null {@code RuneMatcher}
   * @throws NullPointerException if {@code other} is null.
   */
  RuneMatcher operator|(final RuneMatcher other);

  Parser<IterableString> many();

  Parser<IterableString> many1();

  bool matches(int rune);

  /**
   * Returns true if a character sequence contains only matching code points.
   * @param in a non-null {@code CharSequence}
   * @throws NullPointerException if {@code in} is null.
   */
  bool matchesAllOf(final String val);

  /**
   * Returns true if a character sequence contains no matching code points.
   * @param in a non-null {@code CharSequence}
   * @throws NullPointerException if {@code in} is null.
   */
  bool matchesNoneOf(final String val);

  /**
   *  Returns a matcher that matches any code point not matched by this matcher.
   */
  RuneMatcher negate();
}


