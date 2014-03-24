part of parsing;

abstract class IterableString implements Iterable<int> {
  static const IterableString EMPTY = const _EmptyIterableString();

  factory IterableString(final String string) =>
      checkNotNull(string).isEmpty ? EMPTY : new _Utf16String(string);

  factory IterableString.ascii(final List<int> bytes) =>
      checkNotNull(bytes).isEmpty ? EMPTY : new _AsciiString(bytes);

  factory IterableString.latin1(final List<int> bytes) =>
      checkNotNull(bytes).isEmpty ? EMPTY : new _Latin1String(bytes);

  factory IterableString.utf8(final List<int> bytes) =>
        null;

  factory IterableString.utf16BE(final List<int> bytes) =>
        null;

  factory IterableString.utf16LE(final List<int> bytes) =>
        null;

  List<int> get bytes;
  CodePointIterator get iterator;
  IterableString operator+(IterableString other);
  IterableString appendAll(Iterable<IterableString> strings);
  IterableString substring(int startIndex, [int endIndex]);
  String toString();
}

class _EmptyIterableString extends IterableBase<int> implements IterableString {
  const _EmptyIterableString();

  List<int> get bytes =>
      EMPTY_LIST;

  CodePointIterator get iterator =>
      EMPTY_LIST.iterator;

  bool get isEmpty =>
      true;

  int get length =>
      0;

  IterableString operator+(final IterableString other) =>
      other;

  IterableString appendAll(Iterable<IterableString> strings) =>
      concatStrings(strings);

  IterableString substring(final int startIndex, [final int endIndex]) =>
      this;

  String toString() =>
      "";
}

abstract class CodePointIterator implements IndexedIterator<int> {
  bool get eof;
}

IterableString concatStrings(final Iterable<IterableString> strings) {
  if (strings.isEmpty) {
    return IterableString.EMPTY;
  } else if (strings.length == 1) {
    return strings.elementAt(0);
  }

  return strings.first.appendAll(strings.skip(1));
}