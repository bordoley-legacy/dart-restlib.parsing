part of parsing_test;

void testParsers() =>
    group("parsers", () {

      testParser("ManyRuneParser", ASTERISK.many(), ["****"], [], 4);
      testParser("MappedParser to value", string("abc").map((_) => "success"), ["abc", "abc "], [" abc", ""], 3);
      testParser("MappedParser to null", string("abc").map((_) => null), [], ["abc", "abc ", " abc", ""], 0);
      testParser("FlatMapMappedParser to value", string("abc").flatMap((_) => new Option("success")), ["abc", "abc "], [" abc", ""], 3);
      testParser("FlatMappedParser to null", string("abc").flatMap((_) => Option.NONE), [], ["abc", "abc ", " abc", ""], 0);
      //testParser("OptionalParser", string("abc").optional(), ["abc", "", " ", "abc "], [], 0);
      testParser("OrParser", string("abc") | string("def") | string("ghi"),
               ["abc", "abc ", "def", "def ", "ghi", "ghi "],
               [" abc", " def", " ghi", ""], 3);
      testParser("RecursiveParser", rec(() => string("abc")), ["abc", "abc "], [" abc", ""], 3);
      testParser("StringParser", string("abc"), ["abc", "abc "], [" abc", ""], 3);
      testParser("TupleParser", ASTERISK + ASTERISK, ["**", "** "], [" **", "*", " *", ""], 2);
    });
