part of parsing;

abstract class _AbstractRuneMatcher extends AbstractParser<int> implements RuneMatcher {
  const _AbstractRuneMatcher();

  RuneMatcher operator &(final RuneMatcher other) =>
      new _AndRuneMatcher(this, other);

  RuneMatcher operator|(final RuneMatcher other) =>
      new _OrRuneMatcher([this, other]);

  Option<int> doParse(final CodePointIterator itr) =>
      (itr.moveNext() && matches(itr.current)) ?
          new Option(itr.current) :
            Option.NONE;

  Parser<IterableString> many() =>
      new _ManyRuneParser(this);

  Parser<IterableString> many1() =>
      super.many1();

  bool matches(int rune);

  bool matchesAllOf(final String val) =>
      val.runes.every(this.matches);

  bool matchesNoneOf(final String val) =>
      val.runes.every((final int rune) =>
          !this.matches(rune));

  RuneMatcher negate() =>
      new _NegateRuneMatcher(this);
}


