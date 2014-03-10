part of restlib_parsing.parsing_test;

parserTests() {
  test("characterParser()", () {
    Parser<int> characterParser = isChar("v");
    Parser<int> surrogatePairParser = isChar("\u{1D11E}");

    expect(characterParser.parse(""), isEmpty);

    expect(
        characterParser.parseFrom(
            new IterableString("vvvcc").iterator..moveNext()..moveNext()..moveNext()),
        isEmpty);

    expect(characterParser.parse("vvvcc").value, equals("v"));

    expect(
        characterParser.parseFrom(
            new IterableString("vvvcc").iterator..moveNext()..moveNext()).value,
        equals("v"));

    expect(
        surrogatePairParser.parseFrom(
            new IterableString("\u{1D11E}\u{1D11E}\u{1D11E}cc").iterator..moveNext()..moveNext()..moveNext()),
        isEmpty);

    expect(
        surrogatePairParser.parse("\u{1D11E}\u{1D11E}cc").value,
        equals("\u{1D11E}"));

    expect(
        surrogatePairParser.parseFrom(
            new IterableString("\u{1D11E}\u{1D11E}\u{1D11E}cc").iterator..moveNext()..moveNext()).value,
        equals("\u{1D11E}"));
  });

  test("compositeParser()", () {
    Parser<int> a = isChar("a");
    Parser<int> b = isChar("b");
    Parser<int> c = isChar("c");

    Parser<String> composite = (a + b + c).map((e) => e.join());

    expect(composite.parse("abc").value, equals("abc"));
    expect(composite.parse("abcd").value, equals("abc"));
    expect(composite.parse("dabc"), isEmpty);
    expect(composite.parseFrom(new IterableString("dabc").iterator..moveNext()).value, equals("abc"));
    expect(composite.parseFrom(new IterableString("abdc").iterator..moveNext()), isEmpty);

    expect(composite.parseFrom(
        new IterableString("abc").iterator..moveNext()..moveNext()..moveNext()),
        isEmpty);
  });

  test("firstOrSecondParser()", () {
    Parser<int> a = isChar("a");
    Parser<int> b = isChar("b");
    Parser<Either<int,int>> aOrB = a ^ b;

    expect(aOrB.parse("abc").value.left.value, equals("a"));
    expect(aOrB.parse("bca").value.right.value, equals("b"));
    expect(aOrB.parse("cab"), isEmpty);
  });

  test("predicateParser", (){
    RuneMatcher matcher = inRange("a", "z");
    expect(matcher.parse("c").value, equals("c"));
    expect(matcher.parse("ABC"), isEmpty);
  });
}