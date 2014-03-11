part of parsing;

abstract class IterableString implements Iterable<int> {
  static const IterableString EMPTY_UTF_16 = const _Utf16String._internal("");
  static const IterableString EMPTY_ASCII = const _AsciiString(EMPTY_LIST);
  static const IterableString EMPTY_LATIN1 = const _Latin1String(EMPTY_LIST);

  factory IterableString(final String string) =>
      checkNotNull(string).isEmpty ? EMPTY_UTF_16 : new _Utf16String._internal(string);

  factory IterableString.ascii(final List<int> bytes) =>
      checkNotNull(bytes).isEmpty ? EMPTY_ASCII : new _AsciiString(bytes);

  factory IterableString.latin1(final List<int> bytes) =>
      checkNotNull(bytes).isEmpty ? EMPTY_LATIN1 : new _Latin1String(bytes);

  factory IterableString.utf8(final List<int> bytes) =>
        null;

  CodePointIterator get iterator;
  IterableString substring(int startIndex, [int endIndex]);
  String toString();
}

abstract class CodePointIterator implements IndexedIterator<int> {
  IterableString get iterable;
  bool get reachedEof;
}