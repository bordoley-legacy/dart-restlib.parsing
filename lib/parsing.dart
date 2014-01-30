library restlib.parsing;

import "dart:collection";

import "package:restlib_common/collections.dart";
import "package:restlib_common/collections.immutable.dart";
import "package:restlib_common/preconditions.dart";

part "src/parsers/either_parser.dart";
part "src/parsers/eof_parser.dart";
part "src/parsers/followedby_parser.dart";
part "src/parsers/list_parser.dart";
part "src/parsers/many_parser.dart";
part "src/parsers/many_rune_parser.dart";
part "src/parsers/mapped_parser.dart";
part "src/parsers/optional_parser.dart";
part "src/parsers/or_parser.dart";
part "src/parsers/recurse_parser.dart";
part "src/rune_matchers/and_rune_matcher.dart";
part "src/rune_matchers/any_rune_matcher.dart";
part "src/rune_matchers/any_of_rune_matcher.dart";
part "src/rune_matchers/in_range_rune_matcher.dart";
part "src/rune_matchers/negate_rune_matcher.dart";
part "src/rune_matchers/none_rune_matcher.dart";
part "src/rune_matchers/or_rune_matcher.dart";
part "src/rune_matchers/single_rune_matcher.dart";
part "src/iterable_string.dart";
part "src/parser.dart";
part "src/rune_matcher.dart";
part "src/string_parser.dart";

// See http://tools.ietf.org/html/rfc5234#appendix-B.1

final RuneMatcher ALPHA = inRange('a', 'z') | inRange('A', 'Z');

final RuneMatcher ALPHA_NUMERIC = ALPHA | NUMERIC;

const RuneMatcher ANY = const _AnyRuneMatcher();

final RuneMatcher BIT = anyOf("01");

final RuneMatcher CHAR = inRange("\u0001", "\u007F");

const RuneMatcher CLOSE_PARENTHESES = const _SingleRuneMatcher(41);

const RuneMatcher COLON = const _SingleRuneMatcher(58);

const RuneMatcher COMMA = const _SingleRuneMatcher(44);

const RuneMatcher CR = const _SingleRuneMatcher(13);

final Parser<IterableString> CRLF = CR + LF;

final RuneMatcher CTL = inRange("\u0000", "\u001F") | isChar("\u007F");

final Parser<int> DIGIT = NUMERIC.map((final int rune) => 
    rune - 48);

final Parser<int> INTEGER = 
  NUMERIC.many1().map((final IterableString digits) => 
      digits.fold(0, (final int accumulator, final int rune) => 
          (accumulator * 10) + (rune - 48)));

const Parser<String> EOF = const _EofParser();

const RuneMatcher EQUALS = const _SingleRuneMatcher(61);

const RuneMatcher DASH = const _SingleRuneMatcher(45);

const RuneMatcher DQUOTE = const _SingleRuneMatcher(34);

const RuneMatcher FORWARD_SLASH = const _SingleRuneMatcher(47);

const RuneMatcher GLOB = const _SingleRuneMatcher(42);

final RuneMatcher HEXDIG = NUMERIC | anyOf("ABCDEF");

const RuneMatcher HTAB = const _SingleRuneMatcher(9);

const RuneMatcher LF = const _SingleRuneMatcher(10);

// FIXME: LWSP =  *(WSP / CRLF WSP)

const RuneMatcher NONE = const _NoneRuneMatcher();

final RuneMatcher NUMERIC = inRange("0", "9");

final RuneMatcher OCTET = inRange("\u0000", "\u00FF");

const RuneMatcher OPEN_PARENTHESES = const _SingleRuneMatcher(40);

const RuneMatcher PERIOD = const _SingleRuneMatcher(46);

const RuneMatcher SEMICOLON = const _SingleRuneMatcher(59);

const RuneMatcher SP = const _SingleRuneMatcher(32);

final RuneMatcher VCHAR = inRange("\u0021", "\u007E");

final RuneMatcher WSP = anyOf(" \t");

RuneMatcher anyOf(final String runes) =>
    (runes.length == 0) ? NONE : new _AnyOfRuneMatcher(runes); 

RuneMatcher inRange(final String start, final String finish) => 
    new _InRangeRuneMatcher(start.runes.single, finish.runes.single);

RuneMatcher isChar(final String rune) =>
    new _SingleRuneMatcher(rune.runes.single);

RuneMatcher noneOf(final String runes) =>
    anyOf(runes).negate();

Parser rec(Parser parser()) =>
    new _RecurseParser(parser);

Parser<String> string(final String string) => 
    new _StringParser(string);