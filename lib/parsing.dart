library parsing;

import "dart:collection";
import "dart:convert";

import "package:restlib_common/collections.dart";
import "package:restlib_common/collections.forwarding.dart";
import "package:restlib_common/collections.immutable.dart";
import "package:restlib_common/preconditions.dart";

part "src/iterable_string/ascii.dart";
part "src/iterable_string/latin1.dart";
part "src/iterable_string/utf_16.dart";
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
part "src/abstract_parser.dart";
part "src/abstract_rune_matcher.dart";
part "src/iterable_string.dart";
part "src/parser.dart";
part "src/rune_matcher.dart";
part "src/parsers/string_parser.dart";

// See http://tools.ietf.org/html/rfc5234#appendix-B.1

const RuneMatcher ALPHA = const _OrRuneMatcher(const[const _InRangeRuneMatcher(97, 122), const _InRangeRuneMatcher(65, 90)]);

const RuneMatcher ALPHA_NUMERIC = const _OrRuneMatcher(const[ALPHA, NUMERIC]);

const RuneMatcher AMPERSAND = const _SingleRuneMatcher(38);

const RuneMatcher ANY = const _AnyRuneMatcher();

const RuneMatcher ASTERISK = const _SingleRuneMatcher(42);

const RuneMatcher BIT = const _InRangeRuneMatcher(48, 49);

const RuneMatcher CHAR = const _InRangeRuneMatcher(1,127);

const RuneMatcher CLOSE_PARENTHESES = const _SingleRuneMatcher(41);

const RuneMatcher COLON = const _SingleRuneMatcher(58);

const RuneMatcher COMMA = const _SingleRuneMatcher(44);

const RuneMatcher CR = const _SingleRuneMatcher(13);

const Parser<String> CRLF = const _StringParser(const _Utf16String("\r\n"), const Option.constant("\r\n"));

const RuneMatcher CTL = const _OrRuneMatcher(const[const _InRangeRuneMatcher(0, 0x1F), const _SingleRuneMatcher(0x7F)]);

final Parser<int> DIGIT = NUMERIC.map((final int rune) =>
    rune - 48);

const Parser<String> EOF = const _EofParser();

const RuneMatcher EQUALS = const _SingleRuneMatcher(61);

const RuneMatcher DASH = const _SingleRuneMatcher(45);

const RuneMatcher DQUOTE = const _SingleRuneMatcher(34);

const RuneMatcher FORWARD_SLASH = const _SingleRuneMatcher(47);

const RuneMatcher HEXDIG = const _OrRuneMatcher(const[NUMERIC, const _InRangeRuneMatcher(65, 70)]);

const RuneMatcher HTAB = const _SingleRuneMatcher(9);

final Parser<int> INTEGER =
  NUMERIC.many1().map((final IterableString digits) =>
      digits.fold(0, (final int accumulator, final int rune) =>
          (accumulator * 10) + (rune - 48)));

const RuneMatcher LF = const _SingleRuneMatcher(10);

// FIXME: LWSP =  *(WSP / CRLF WSP)

const RuneMatcher NONE = const _NoneRuneMatcher();

const RuneMatcher NUMERIC = const _InRangeRuneMatcher(48, 57);

const RuneMatcher OCTET = const _InRangeRuneMatcher(0, 0xFF);

const RuneMatcher OPEN_PARENTHESES = const _SingleRuneMatcher(40);

const RuneMatcher PERIOD = const _SingleRuneMatcher(46);

const RuneMatcher POUND_SIGN = const _SingleRuneMatcher(35);

const RuneMatcher QUESTION_MARK = const _SingleRuneMatcher(63);

const RuneMatcher SEMICOLON = const _SingleRuneMatcher(59);

const RuneMatcher SP = const _SingleRuneMatcher(32);

const RuneMatcher UNICODE = const _OrRuneMatcher(const [
              const _InRangeRuneMatcher(0, 0xFFFF),           // BMP
              const _InRangeRuneMatcher(0x10000, 0x13FFF),    // SMP
              const _InRangeRuneMatcher(0x16000, 0x16FFF),    // SMP
              const _InRangeRuneMatcher(0x1B000, 0x1BFFF),    // SMP
              const _InRangeRuneMatcher(0x1D000, 0x1FFFF),    // SMP
              const _InRangeRuneMatcher(0x20000, 0x2BFFF),    // SIP
              const _InRangeRuneMatcher(0x2F000, 0x2FFFF),    // SIP
              const _InRangeRuneMatcher(0x3F000, 0x3FFFF),
              const _InRangeRuneMatcher(0xE0000, 0xE0FFF),    // SSP
              const _InRangeRuneMatcher(0xF0000, 0x10FFFF)]); // S PUA A/B]

const RuneMatcher VCHAR = const _InRangeRuneMatcher(0x21, 0x7E);

const RuneMatcher WSP = const _OrRuneMatcher(const[SP, HTAB]);

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
    new _StringParser(new IterableString(string), new Option(string));