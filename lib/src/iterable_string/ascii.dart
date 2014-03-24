part of parsing;

class _AsciiString extends IterableBase<int> implements IterableString {
  final List<int> bytes;

  const _AsciiString(this.bytes);

  bool get isEmpty =>
      bytes.isEmpty;

  int get length =>
      bytes.length;

  CodePointIterator get iterator =>
      new _AsciiIterator(this);

  IterableString operator+(final IterableString other) {
    checkArgument(other is _AsciiString || other.isEmpty);
    return other.isEmpty ? this : new _AsciiString(concatLists([this.bytes, other.bytes]));
  }

  IterableString appendAll(Iterable<IterableString> strings) {
    if (strings.isEmpty) {
      return this;
    }

    final List<int> delegate =
        concatLists(
            [bytes]..addAll(
                strings.map((final IterableString str) {
                  checkArgument(str is _AsciiString || str.isEmpty);
                  return str.bytes;
                })));

    if (delegate.length == this.bytes.length) {
      return this;
    }

    return new _AsciiString(delegate);
  }

  IterableString substring(int startIndex, [int endIndex]) {
    final List<int> delegate = sublist(this.bytes, startIndex, endIndex - startIndex);
    return delegate.isEmpty ? IterableString.EMPTY : new _AsciiString(delegate);
  }

  String toString() =>
      ASCII.decode(bytes, allowInvalid:false);
}

class _AsciiIterator
    extends Object
    with ForwardingIterator<int>,
      ForwardingBidirectionalIterator<int>,
      ForwardingIndexedIterator<int>
    implements CodePointIterator {
  final IndexedIterator<int> delegate;
  final int length;

  bool _eof = false;

  _AsciiIterator(final _AsciiString str) :
    this.delegate = new IndexedIterator.list(str.bytes),
    this.length = str.length;

  int get current {
    final int retval = delegate.current;

    checkState(retval < 128 && retval >=0);
    return retval;
  }

  bool get eof => _eof;

  void set index(final int index) {
    super.index = index;
    if (index < length) {
      _eof = false;
    }
  }

  bool moveNext() {
    if (eof) {
      return false;
    }

    if (!eof && !super.moveNext()) {
      _eof = true;
      return false;
    }

    return true;
  }

  bool movePrevious() {
    _eof = false;
    return super.movePrevious();
  }
}