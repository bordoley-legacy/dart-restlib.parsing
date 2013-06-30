part of restlib_parsing.parsing_test;

stringIteratorTests() {  
  test("Iterate forwards.", () {
    StringIterator itr = new StringIterator("ab");
    
    expect(() => itr.current, throwsStateError);
    expect(itr.index, equals(-1));
    
    expect(itr.moveNext(),isTrue);
    expect(itr.current, equals("a".runes.single));
    expect(itr.currentAsString, equals("a"));
    expect(itr.index, equals(0));
    
    expect(itr.moveNext(), isTrue);
    expect(itr.current, equals("b".runes.single));
    expect(itr.currentAsString, equals("b"));
    expect(itr.index, equals(1));
    
    expect(itr.moveNext(), isFalse);
    expect(() => itr.current, throwsStateError);  
    expect(itr.index, equals(2));
  });
  
  test("Iterate backwards.", () {
    StringIterator itr = new StringIterator("ab");
    while(itr.moveNext());
    
    expect(itr.movePrevious(), true);
    expect(itr.current, equals("b".runes.single));
    expect(itr.currentAsString, equals("b"));
    expect(itr.index, equals(1));
    
    expect(itr.movePrevious(), true);
    expect(itr.current, equals("a".runes.single));
    expect(itr.currentAsString, equals("a"));
    expect(itr.index, equals(0));
    
    expect(itr.movePrevious(), isFalse);
    expect(() => itr.current, throwsStateError);  
    expect(itr.index, equals(-1));
  });
  
  test("Iterate through String with surrogate pairs.", () {
    StringIterator itr = new StringIterator("a\u{1D11E}");
    
    expect(itr.moveNext(),isTrue);
    expect(itr.current, equals("a".runes.single));
    expect(itr.currentAsString, equals("a"));
    expect(itr.index, equals(0));
    
    expect(itr.moveNext(),isTrue);
    expect(itr.current, equals("\u{1D11E}".runes.single));
    expect(itr.currentAsString, equals("\u{1D11E}"));
    expect(itr.index, equals(1));
    
    expect(itr.moveNext(), isFalse);
    expect(() => itr.current, throwsStateError);  
    expect(itr.index, equals(3));
  });
  
  test("set Index", () {
    StringIterator itr = new StringIterator("abcd");
    
    expect(() => itr.index = -2, throwsRangeError);
    expect(() => itr.index = 10, throwsRangeError);
    
    itr.index == -1;
    expect(() => itr.current, throwsStateError);  
    
    itr.index = itr.string.length;
    expect(() => itr.current, throwsStateError);  
    
    itr.index = 0;
    expect(itr.current, equals("a".runes.single));
    expect(itr.currentAsString, equals("a"));
    
  }); 
}