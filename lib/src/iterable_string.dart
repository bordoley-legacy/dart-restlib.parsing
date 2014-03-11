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

class _Utf16String extends IterableBase<int> implements IterableString {
  final String _string;

  const _Utf16String._internal(this._string);

  bool get isEmpty =>
      _string.isEmpty;

  int get length =>
      _string.length;

  CodePointIterator get iterator =>
      new _Utf16Iterator(this);

  IterableString substring(int startIndex, [int endIndex]) =>
      new IterableString(_string.substring(startIndex, endIndex));

  String toString() =>
      _string;
}

class _Utf16Iterator implements CodePointIterator {
  // Is then code (a 16-bit unsigned integer) a UTF-16 lead surrogate.
  static bool _isLeadSurrogate(final int code) =>
      (code & 0xFC00) == 0xD800;

  // Is then code (a 16-bit unsigned integer) a UTF-16 trail surrogate.
  static bool _isTrailSurrogate(final int code) =>
      (code & 0xFC00) == 0xDC00;

  // Combine a lead and a trail surrogate value into a single code point.
  static int _combineSurrogatePair(final int start, final int end) =>
    0x10000 + ((start & 0x3FF) << 10) + (end & 0x3FF);

  int _current = null;
  int _index = -1;
  final IterableString iterable;

  bool reachedEof = false;

  _Utf16Iterator(this.iterable);

  int get current {
    if (_current == null) {
      throw new StateError("Index is out of bounds");
    }

    return _current;
  }

  /*
  String get currentAsString {
    if (_current == null) {
      throw new StateError("Index is out of bounds");
    }
    return _isLeadSurrogate(string.codeUnitAt(index)) ?
        string.substring(index, index + 2) :
        string.substring(index, index + 1);
  }*/

  int get index => _index;

  void set index(final int index) {
    checkRangeInclusive(-1, iterable.toString().length, index);
    if ((index > 0) &&
        (index < iterable.toString().length) &&
        _isTrailSurrogate(iterable.toString().codeUnitAt(index))) {
      throw new ArgumentError("Index inside surrogate pair: $index");
    }
    _index = index;
    _updateCurrent();

    if (index < iterable.length) {
      reachedEof = false;
    }

  }

  bool moveNext() {
    if (reachedEof) {
      return false;
    }

    _moveIndexToNextCodePointIndex();
    _updateCurrent();
    reachedEof = (index == iterable.toString().length);
    return !reachedEof;

  }

  bool movePrevious() {
    reachedEof = false;

    if (index > -1) {
      _moveIndexToPreviousCodePointIndex();
      _updateCurrent();
      return !(index == -1);
    } else {
      return false;
    }
  }

  void _moveIndexToNextCodePointIndex() {
    if ((index > -1) &&
        (index < iterable.toString().length - 1) &&
        _isLeadSurrogate(iterable.toString().codeUnitAt(index))) {
      _index++;
    }
    _index++;
  }

  void _moveIndexToPreviousCodePointIndex() {
    if ((index > 0) &&
        (index < iterable.toString().length) &&
        _isTrailSurrogate(iterable.toString().codeUnitAt(index))) {
      _index--;
    }
    _index--;
  }

  void _updateCurrent() {
    if (index == iterable.toString().length || index < 0) {
      this._current = null;
    } else {
      int codeUnit = iterable.toString().codeUnitAt(index);
      this._current =
          _isLeadSurrogate(iterable.toString().codeUnitAt(index)) ?
            _combineSurrogatePair(codeUnit, iterable.toString().codeUnitAt(index + 1)) :
              codeUnit;
    }
  }
}

class _AsciiString extends IterableBase<int> implements IterableString {
  final List<int> _bytes;

  const _AsciiString(this._bytes);

  bool get isEmpty =>
      _bytes.isEmpty;

  int get length =>
      _bytes.length;

  CodePointIterator get iterator =>
      new _AsciiIterator(this);

  IterableString substring(int startIndex, [int endIndex]) =>
      new _AsciiString(sublist(this._bytes, startIndex, endIndex - startIndex));

  String toString() =>
      ASCII.decode(_bytes, allowInvalid:false);
}

class _AsciiIterator
    extends Object
    with ForwardingIterator<int>,
      ForwardingBidirectionalIterator<int>,
      ForwardingIndexedIterator<int>
    implements CodePointIterator {
  final IndexedIterator<int> delegate;
  final _AsciiString iterable;

  bool reachedEof = false;

  _AsciiIterator(final _AsciiString str) :
    this.delegate = new IndexedIterator.list(str._bytes),
    this.iterable = str;

  int get current {
    final int retval = delegate.current;

    checkState(retval < 128 && retval >=0);
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

