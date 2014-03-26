library parsing_test;

import "dart:async";

import "package:restlib_common/collections.dart";
import "package:restlib_parsing/parsing.dart";
import "package:unittest/unittest.dart";

part "src/abstract_rune_matcher_test.dart";
part "src/parser_test.dart";

testRuneMatcher(final String name, final RuneMatcher matcher, final Iterable<int> matches, final Iterable<int> noMatch) {
  group("RuneMatcher: $name", () {
    test("matches", () =>
        matches.forEach((final int i) =>
            expect(matcher.matches(i), isTrue, reason: "Failed for rune: $i")));
    test("does not match", () =>
        noMatch.forEach((final int i) =>
            expect(matcher.matches(i), isFalse, reason: "Failed for rune: $i")));
  });
}

testParser(final String name, final Parser parser, final Iterable<String> matches, final Iterable<String> noMatch, int matchLength) {
  group("Parser: $name", () {
    test("parse with result", () =>
        matches.forEach((final String str) {
          final IterableString itrStr = new IterableString(str);
          final ParseResult result = parser.parseFrom(itrStr);
          expect(result.left.isNotEmpty, isTrue, reason: "Failed on: $str");
          expect(result.next.length, equals(itrStr.length - matchLength));
        }));
    test("parse with error", () =>
        noMatch.forEach((final String str) =>
            expect(parser.parseFrom(new IterableString(str)).right.isNotEmpty, isTrue, reason: "Failed on: $str")));
  });
}

FiniteSet<int> rangeToSet(final Range range) =>
    range.toSet(IntegerDomain.UINT32);

testSingleAsciiRuneMatcher(final String name, final RuneMatcher matcher, final int cp) =>
    testRuneMatcher(name, matcher,
          new Range.single(cp).toSet(IntegerDomain.UINT32),
          concat([new Range.closedOpen(0, cp),
                  new Range.openClosed(cp, 255),
                  new Range.closed(65000, 80000)].map(rangeToSet)));

void constantTests() {
  int toCp(final String str) =>
      str.runes.single;

  final Iterable<int> unicode =
      concat(
          [new Range.closed(0, 0xFFFF),         // BMP
           new Range.closed(0x10000, 0x13FFF),  // SMP
           new Range.closed(0x16000, 0x16FFF),  // SMP
           new Range.closed(0x1B000, 0x1BFFF),  // SMP
           new Range.closed(0x1D000, 0x1FFFF),  // SMP
           new Range.closed(0x20000, 0x2BFFF),  // SIP
           new Range.closed(0x2F000, 0x2FFFF),  // SIP
           new Range.closed(0x3F000, 0x3FFFF),  // NOT UNICODE
           new Range.closed(0xE0000, 0xE0FFF),  // SSP
           new Range.closed(0xF0000, 0x10FFFF), // S PUA A/B
          ].map(rangeToSet));

  testRuneMatcher("ALPHA", ALPHA,
      concat([new Range.closed(toCp("A"), toCp("Z")),
              new Range.closed(toCp("a"), toCp("z"))].map(rangeToSet)),
      concat([new Range.closedOpen(0, toCp("A")),
              new Range.open(toCp("Z"), toCp("a")),
              new Range.openClosed(toCp("z"), 255),
              new Range.closed(65000, 80000)].map(rangeToSet)));

  testRuneMatcher("ALPHA_NUMERIC", ALPHA_NUMERIC,
      concat([new Range.closed(toCp("0"), toCp("9")),
              new Range.closed(toCp("A"), toCp("Z")),
              new Range.closed(toCp("a"), toCp("z"))].map(rangeToSet)),
      concat([new Range.closedOpen(0, toCp("0")),
              new Range.open(toCp("9"), toCp("A")),
              new Range.open(toCp("Z"), toCp("a")),
              new Range.openClosed(toCp("z"), 255),
              new Range.closed(65000, 80000)].map(rangeToSet)));

  testSingleAsciiRuneMatcher("AMPERSAND", AMPERSAND, toCp("&"));

  testRuneMatcher("ANY", ANY, unicode, []);

  testSingleAsciiRuneMatcher("ASTERISK", ASTERISK, toCp("*"));

  testRuneMatcher("BIT", BIT,
      new Range.closed(toCp("0"), toCp("1")).toSet(IntegerDomain.UINT32),
      concat([new Range.closedOpen(0, toCp("0")),
              new Range.openClosed(toCp("1"), 255),
              new Range.closed(65000, 80000)].map(rangeToSet)));

  testRuneMatcher("CHAR", CHAR,
        new Range.closed(1, 127).toSet(IntegerDomain.UINT32),
        concat([new Range.single(0),
                new Range.closed(128, 255),
                new Range.closed(65000, 80000)].map(rangeToSet)));

  testSingleAsciiRuneMatcher("CLOSE_PARENTHESES", CLOSE_PARENTHESES, toCp(")"));

  testSingleAsciiRuneMatcher("COLON", COLON, toCp(":"));

  testSingleAsciiRuneMatcher("COMMA", COMMA, toCp(","));

  testSingleAsciiRuneMatcher("CR", CR, toCp("\r"));

  testParser("CRLF", CRLF, ["\r\n"], ["\r", "\n", "\r\r\n", "\n\r", " \r\n"], 2);

  testRuneMatcher("CTL", CTL,
            concat([new Range.closed(0, 0x1F), new Range.single(0x7F)].map(rangeToSet)),
            concat([new Range.open(0x1F, 0x7F),
                    new Range.openClosed(0x7F, 255),
                    new Range.closed(65000, 80000)].map(rangeToSet)));

  testParser("DIGIT", DIGIT,
      ["0", "1", "2", "3" , "4", "5", "6", "7", "8", "9"],
      [" 0", " 1", " 2", " 3" , " 4", " 5", " 6", " 7", " 8", " 9", " 11", "a", "afjdsklfj"], 1);

  testParser("EOF", EOF, [""], [" ", "a", "abc", " abc"], 0);

  testSingleAsciiRuneMatcher("EQUALS", EQUALS, toCp("="));

  testSingleAsciiRuneMatcher("DASH", DASH, toCp("-"));

  testSingleAsciiRuneMatcher("DQUOTE", DQUOTE, toCp("\""));

  testSingleAsciiRuneMatcher("FORWARD_SLASH", FORWARD_SLASH, toCp("/"));

  testRuneMatcher("HEXDIG", HEXDIG,
            concat([new Range.closed(toCp("0"), toCp("9")), new Range.closed(toCp("A"), toCp("F"))].map(rangeToSet)),
            concat([new Range.closedOpen(0, toCp("0")),
                    new Range.open(toCp("9"), toCp("A")),
                    new Range.openClosed(toCp("F"), 255)].map(rangeToSet)));

  testSingleAsciiRuneMatcher("HTAB", HTAB, toCp("\t"));

  testParser("INTEGER", INTEGER, ["1234", "4567", "8901"], [" 1234789", "a1", "A11"], 4);

  testSingleAsciiRuneMatcher("LF", LF, toCp("\n"));

  testRuneMatcher("NONE", NONE, [], unicode);

  testRuneMatcher("NUMERIC", NUMERIC,
        new Range.closed(toCp("0"), toCp("9")).toSet(IntegerDomain.UINT32),
        concat([new Range.closedOpen(0, toCp("0")),
                new Range.open(toCp("9"), 255),
                new Range.closed(65000, 80000)].map(rangeToSet)));

  testRuneMatcher("OCTET", OCTET,
        new Range.closed(0, 0xFF).toSet(IntegerDomain.UINT32),
        new Range.open(0xFF, 65536).toSet(IntegerDomain.UINT32));

  testSingleAsciiRuneMatcher("OPEN_PARENTHESES", OPEN_PARENTHESES, toCp("("));

  testSingleAsciiRuneMatcher("PERIOD", PERIOD, toCp("."));

  testSingleAsciiRuneMatcher("POUND_SIGN", POUND_SIGN, toCp("#"));

  testSingleAsciiRuneMatcher("QUESTION_MARK", QUESTION_MARK, toCp("?"));

  testSingleAsciiRuneMatcher("SEMICOLON", SEMICOLON, toCp(";"));

  testSingleAsciiRuneMatcher("SP", SP, toCp(" "));

  testRuneMatcher("UNICODE", UNICODE, unicode, new Range.open(0x10FFFF, 0x50FFFF).toSet(IntegerDomain.UINT32));

  testRuneMatcher("VCHAR", VCHAR,
      new Range.closed(0x21, 0x7E).toSet(IntegerDomain.UINT32),
      concat([new Range.closedOpen(0, 0x21), new Range.openClosed(0x7E, 255)].map(rangeToSet)));

  testRuneMatcher("WSP", WSP, [toCp(" "), toCp("\t")],
      concat([new Range.closedOpen(0, 9),
              new Range.open(9, 32),
              new Range.openClosed(32, 255)].map(rangeToSet)));

}

parsingTestGroups() {
  group("package:parsing", () {
    constantTests();
    testParsers();
  });
}

main() {
  //parsingTestGroups();


  Stream<List<int>> generateStream(final Iterable<String> streamParts) =>
      new Stream.fromIterable(streamParts.map((final String str) => str.codeUnits));

  IterableString convertUtf16(final Iterable<int> bytes) =>
      new IterableString(new String.fromCharCodes(bytes));

  Future testAsyncParse(parser, Iterable<String> streamParts) =>
      parser.parseAsync(generateStream(streamParts), convertUtf16)
        .then((final AsyncParseResult result) =>
            print(result.left));

  testAsyncParse(POUND_SIGN.many(), ["####555577"]);
  testAsyncParse(POUND_SIGN + string("1234"), ["#12", "3", "4"]);
  testAsyncParse(string("ab") ^ isChar("c"), ["fgh"]);
  testAsyncParse(EOF, ["", ""]);
  testAsyncParse(string("abc") + EOF, ["", "abc"]);
  testAsyncParse(string("abc").many(), ["abc", "abc   "]);
  testAsyncParse(string("abc").map((final String str) => "def").many(),["abc", "abc   "]);
  testAsyncParse(string("abc").flatMap((final String str) => new Option("def")).many(), ["abc", "abc   "]);
  testAsyncParse(string("abc").optional(), ["abc", "abc   "]);
  testAsyncParse(string("abc").optional(), ["   ", "jklj   "]);
  testAsyncParse(string("abc") | string("def") | string("ghi"), ["a", "b", "c"]);
  testAsyncParse(string("abc") | string("def") | string("ghi"), ["g", "h", "i"]);
}