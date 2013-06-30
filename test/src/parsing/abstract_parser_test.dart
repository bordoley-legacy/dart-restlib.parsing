part of restlib_parsing.parsing_test;

parserTests() {
  test("characterParser()", () {
    Parser<String> characterParser = charParser("v");
    Parser<String> surrogatePairParser = charParser("\u{1D11E}");
    
    expect(characterParser.parse(""), isEmpty);
    
    expect(
        characterParser.parseFrom(
            new StringIterator("vvvcc")..moveNext()..moveNext()..moveNext()),
        isEmpty);
    
    expect(characterParser.parse("vvvcc").value, equals("v"));
    
    expect(
        characterParser.parseFrom(
            new StringIterator("vvvcc")..moveNext()..moveNext()).value,
        equals("v"));
    
    expect(
        surrogatePairParser.parseFrom(
            new StringIterator("\u{1D11E}\u{1D11E}\u{1D11E}cc")..moveNext()..moveNext()..moveNext()),
        isEmpty);
    
    expect(
        surrogatePairParser.parse("\u{1D11E}\u{1D11E}cc").value, 
        equals("\u{1D11E}"));
    
    expect(
        surrogatePairParser.parseFrom(
            new StringIterator("\u{1D11E}\u{1D11E}\u{1D11E}cc")..moveNext()..moveNext()).value,
        equals("\u{1D11E}"));
  });
  
  test("compositeParser()", () {
    Parser<String> a = charParser("a");
    Parser<String> b = charParser("b");
    Parser<String> c = charParser("c");
    
    Parser<String> composite = (a + b + c).map((e) => e.join());
    
    expect(composite.parse("abc").value, equals("abc"));
    expect(composite.parse("abcd").value, equals("abc"));
    expect(composite.parse("dabc"), isEmpty);
    expect(composite.parseFrom(new StringIterator("dabc")..moveNext()).value, equals("abc"));
    expect(composite.parseFrom(new StringIterator("abdc")..moveNext()), isEmpty);
    
    expect(composite.parseFrom(
        new StringIterator("abc")..moveNext()..moveNext()..moveNext()), 
        isEmpty);
  });
  
  test("firstOrSecondParser()", () {
    Parser<String> a = charParser("a");
    Parser<String> b = charParser("b");
    Parser<Either<String,String>> aOrB = a | b;
    
    expect(aOrB.parse("abc").value.left.value, equals("a"));
    expect(aOrB.parse("bca").value.right.value, equals("b"));
    expect(aOrB.parse("cab"), isEmpty);
  });
  
  test("predicateParser", (){
    RuneMatcher matcher = new RuneMatcher.inRange("a", "z");
    Parser parser = runeParser(matcher);
    expect(parser.parse("c").value, equals("c"));
    expect(parser.parse("ABC"), isEmpty);
  });
  
  test("whileParser", (){
    RuneMatcher matcher = new RuneMatcher.inRange("a", "z");
    Parser testWhileParser = whileMatchesParser(matcher);
    expect(testWhileParser.parse("abcz").value, equals("abcz"));
    expect(testWhileParser.parse("abczZZZZZZ").value, equals("abcz"));
    expect(testWhileParser.parse("ZZZZZZabcz"), isEmpty);
  });  
  
  test ("sepBy", (){
    Parser<Iterable<String>> parser = whileMatchesParser(RuneMatcher.ALPHA_NUMERIC_MATCHER).sepBy(charParser(","));
    expect(parser.parse("a,b,5,sss,yyy").value, equals(["a", "b", "5", "sss", "yyy"]));
    expect(parser.parse("a").value, equals(["a"]));
  });
}