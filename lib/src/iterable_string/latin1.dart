part of parsing;

class _Latin1String extends IterableBase<int> implements IterableString {
  final List<int> bytes;

  const _Latin1String(this.bytes);

  bool get isEmpty =>
      bytes.isEmpty;

  int get length =>
      bytes.length;

  CodePointIterator get iterator =>
      new _Latin1Iterator(this);

  IterableString operator+(final IterableString other) {
    checkArgument(other is _Latin1String || other.isEmpty);
    return other.isEmpty ? this : new _Latin1String(concatLists([this.bytes, other.bytes]));
  }

  IterableString appendAll(Iterable<IterableString> strings) {
    if (strings.isEmpty) {
      return this;
    }

    final List<int> delegate =
        concatLists(
            [bytes]..addAll(
                strings.map((final IterableString str) {
                  checkArgument(str is _Latin1String || str.isEmpty);
                  return str.bytes;
                })));

    if (delegate.length == this.bytes.length) {
      return this;
    }

    return new _Latin1String(delegate);
  }

  IterableString substring(int startIndex, [int endIndex]) {
    endIndex = firstNotNull(endIndex, this.length);
    final List<int> delegate = sublist(this.bytes, startIndex, endIndex);
    return delegate.isEmpty ? IterableString.EMPTY : new _Latin1String(delegate);
  }

  String toString() =>
      LATIN1.decode(bytes, allowInvalid:false);
}

class _Latin1Iterator
    extends Object
    with ForwardingIterator<int>,
      ForwardingBidirectionalIterator<int>,
      ForwardingIndexedIterator<int>
    implements CodePointIterator {
  final IndexedIterator<int> delegate;
  final int length;

  bool _eof = false;

  _Latin1Iterator(final _Latin1String str) :
    this.delegate = new IndexedIterator.list(str.bytes),
    this.length = str.length;

  int get current {
    final int retval = delegate.current;

    // FIXME: This range could be tightened up
    if (retval < 0 || retval >= 128) {
      throw new EncodingException();
    }

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

