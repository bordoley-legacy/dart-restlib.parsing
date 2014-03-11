part of parsing;

class _Latin1String extends IterableBase<int> implements IterableString {
  final List<int> _bytes;

  const _Latin1String(this._bytes);

  bool get isEmpty =>
      _bytes.isEmpty;

  int get length =>
      _bytes.length;

  CodePointIterator get iterator =>
      new _Latin1Iterator(this);

  IterableString substring(int startIndex, [int endIndex]) =>
      new _Latin1String(sublist(this._bytes, startIndex, endIndex - startIndex));

  String toString() =>
      LATIN1.decode(_bytes, allowInvalid:false);
}

class _Latin1Iterator
    extends Object
    with ForwardingIterator<int>,
      ForwardingBidirectionalIterator<int>,
      ForwardingIndexedIterator<int>
    implements CodePointIterator {
  final IndexedIterator<int> delegate;
  final _Latin1String iterable;

  bool reachedEof = false;

  _Latin1Iterator(final _Latin1String str) :
    this.delegate = new IndexedIterator.list(str._bytes),
    this.iterable = str;

  int get current {
    final int retval = delegate.current;

    // FIXME: This range could be tightened up
    checkState(retval < 256 && retval >=0);
    return retval;
  }

  void set index(final int index) {
    super.index = index;
    if (index < delegate.iterable.length) {
      reachedEof = false;
    }
  }

  bool moveNext() {
    if (reachedEof) {
      return false;
    }

    if (!reachedEof && !super.moveNext()) {
      reachedEof = true;
      return false;
    }

    return true;
  }

  bool movePrevious() {
    reachedEof = false;
    return super.movePrevious();
  }
}

