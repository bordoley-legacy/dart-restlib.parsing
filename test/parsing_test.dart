library restlib_parsing.parsing_test;

import "package:restlib_common/collections.dart";
import "package:restlib_parsing/parsing.dart";
import "package:unittest/unittest.dart";

part 'src/parsing/abstract_parser_test.dart';
part "src/rune_matcher_test.dart";
part 'src/string_iterator_test.dart';

parsingTestGroups() {
  group("class StringIterator", stringIteratorTests);
  group("function Parser", parserTests);
}

main() {
  parsingTestGroups();  
}