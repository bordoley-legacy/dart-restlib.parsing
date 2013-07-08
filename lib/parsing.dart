library restlib.parsing;

import "dart:collection";

import "package:restlib_common/collections.dart";
import "package:restlib_common/objects.dart";
import "package:restlib_common/preconditions.dart";

part "src/matchers/and_rune_matcher.dart";
part "src/matchers/any_rune_matcher.dart";
part "src/matchers/any_of_rune_matcher.dart";
part "src/matchers/in_range_rune_matcher.dart";
part "src/matchers/negate_rune_matcher.dart";
part "src/matchers/none_rune_matcher.dart";
part "src/matchers/or_rune_matcher.dart";
part "src/matchers/single_rune_matcher.dart";
part "src/parsers/eof_parser.dart";
part "src/parsers/followedby_parser.dart";
part "src/parsers/list_parser.dart";
part "src/parsers/many_parser.dart";
part "src/parsers/many_rune_parser.dart";
part "src/parsers/mapped_parser.dart";
part "src/parsers/optional_parser.dart";
part "src/parsers/or_parser.dart";
part "src/parsers/recurse_parser.dart";
part "src/parsers/string_parser.dart";
part "src/parser.dart";
part "src/rune_matcher.dart";
part "src/iterable_string.dart";

final RuneMatcher ALPHA_NUMERIC = inRange('a', 'z') | inRange('A', 'Z') | NUMERIC;

const RuneMatcher ANY = const _AnyRuneMatcher();

const RuneMatcher CLOSE_PARENTHESES = const _SingleRuneMatcher(41);

const RuneMatcher COLON = const _SingleRuneMatcher(58);

const RuneMatcher COMMA = const _SingleRuneMatcher(44);

final Parser<int> DIGIT = NUMERIC.map((final int rune) => 
    rune - 48);

const Parser<String> EOF = const _EofParser();

const RuneMatcher EQUALS = const _SingleRuneMatcher(61);

const RuneMatcher FORWARD_SLASH = const _SingleRuneMatcher(47);

const RuneMatcher GLOB = const _SingleRuneMatcher(42);

const RuneMatcher NONE = const _NoneRuneMatcher();

final RuneMatcher NUMERIC = inRange("0", "9");

const RuneMatcher OPEN_PARENTHESES = const _SingleRuneMatcher(40);

const RuneMatcher PERIOD = const _SingleRuneMatcher(46);

const RuneMatcher DQUOTE = const _SingleRuneMatcher(34);

const RuneMatcher SEMICOLON = const _SingleRuneMatcher(59);

Parser rec(Parser parser()) =>
    new _RecurseParser(parser);

Parser<String> string(final String string) => 
    new _StringParser(string);

RuneMatcher anyOf(final String runes) =>
    (runes.length == 0) ? NONE : new _AnyOfRuneMatcher(runes); 

RuneMatcher inRange(final String start, final String finish) => 
    new _InRangeRuneMatcher(start.runes.single, finish.runes.single);

RuneMatcher isChar(final String rune) =>
    new _SingleRuneMatcher(rune.runes.single);

RuneMatcher noneOf(final String runes) =>
    anyOf(runes).negate();
