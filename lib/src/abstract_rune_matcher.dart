part of parsing;

abstract class _AbstractRuneMatcher extends ParserBase<int> implements RuneMatcher {
  const _AbstractRuneMatcher();

  RuneMatcher operator &(final RuneMatcher other) =>
      new _AndRuneMatcher(this, other);

  RuneMatcher operator|(final RuneMatcher other) =>
      new _OrRuneMatcher([this, other]);

  Option<int> doParse(final CodePointIterator itr) =>
      (itr.moveNext() && matches(itr.current)) ?
          new Option(itr.current) :
            Option.NONE;

  ParseResult<int> parseFrom(final IterableString str) =>
      first(str)
        .map((final int cp) =>
            matches(cp) ? new ParseResult.success(cp, str.substring(1)) : new ParseResult.failure(str))
        .orCompute(() =>
            new ParseResult.eof(str));

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


