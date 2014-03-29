part of parsing_test;

void testParsers() =>
    group("parsers", () {

      testParser(ASTERISK.many(), ["****"], [], 4);
      testParser(string("abc").map((_) => "success"), ["abc", "abc "], [" abc", ""], 3);
      testParser(string("abc").map((_) => null), [], ["abc", "abc ", " abc", ""], 0);
      testParser(string("abc").flatMap((_) => new Option("success")), ["abc", "abc "], [" abc", ""], 3);
      testParser(string("abc").flatMap((_) => Option.NONE), [], ["abc", "abc ", " abc", ""], 0);
      //testParser(string("abc").optional(), ["abc", "", " ", "abc "], [], 0);
      testParser(string("abc") | string("def") | string("ghi"),
               ["abc", "abc ", "def", "def ", "ghi", "ghi "],
               [" abc", " def", " ghi", ""], 3);
      testParser(rec(() => string("abc")), ["abc", "abc "], [" abc", ""], 3);
      testParser(string("abc"), ["abc", "abc "], [" abc", ""], 3);
      testParser(ASTERISK + ASTERISK, ["**", "** "], [" **", "*", " *", ""], 2);
    });
