part of parsing;

class IterableString extends IterableBase<int> {
  static const IterableString EMPTY = const IterableString._internal("");

  factory IterableString(final String string) =>
      checkNotNull(string).isEmpty ? EMPTY : new IterableString._internal(string);

  final String _string;

  const IterableString._internal(this._string);

  bool get isEmpty =>
      _string.isEmpty;

  CodePointIterator get iterator =>
      new CodePointIterator.iterableString(this);

  String toString() =>
      _string;
}

abstract class CodePointIterator implements IndexedIterator<int> {
  factory CodePointIterator.ascii(final List<int> bytes) =>
        new _AsciiIterator(bytes);

  factory CodePointIterator.latin1(final List<int> bytes) =>
      new _Latin1Iterator(bytes);

  factory CodePointIterator.iterableString(final IterableString string) =>
      new _StringIterator(checkNotNull(string));

  factory CodePointIterator.string(final String string) =>
      new _StringIterator(new IterableString(string));

  // FIXME: Add UTF-8
}

abstract class AsciiIterator implements CodePointIterator {
  List<int> get iterable;
}

class _AsciiIterator
    extends Object
    with ForwardingIterator<int>,
      ForwardingBidirectionalIterator<int>,
      ForwardingIndexedIterator<int>
    implements AsciiIterator {
  final IndexedIterator<int> _delegate;

  _AsciiIterator(final List<int> bytes) :
    this._delegate = new IndexedIterator.list(bytes);

  int get current {
    final int retval = _delegate.current;

    checkState(retval < 128 && retval >=0);
    return retval;
  }
}

abstract class Latin1Iterator implements CodePointIterator {
  List<int> get iterable;
}

class _Latin1Iterator
    extends Object
    with ForwardingIterator<int>,
      ForwardingBidirectionalIterator<int>,
      ForwardingIndexedIterator<int>
    implements Latin1Iterator {
  final IndexedIterator<int> _delegate;

  _Latin1Iterator(final List<int> bytes) :
    this._delegate = new IndexedIterator.list(bytes);

  int get current {
    final int retval = _delegate.current;

    // FIXME: This range could be tightened up
    checkState(retval < 256 && retval >=0);
    return retval;
  }
}

abstract class StringIterator implements CodePointIterator {
  IterableString get iterable;
}

class _StringIterator implements StringIterator {
  int _current = null;
  int _index = -1;
  final IterableString iterable;

  _StringIterator(this.iterable);

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
  }

  bool moveNext() {
    if (index < iterable.toString().length) {
      _moveIndexToNextCodePointIndex();
      _updateCurrent();
      return !(index == iterable.toString().length);
    } else {
      return false;
    }
  }

  bool movePrevious() {
    if (index > -1) {
      _moveIndexToPreviousCodePointIndex();
      _updateCurrent();
      return !(index == -1);
    } else {
      return false;
    }
  }

  String toString() =>
      "StringIterator($string, $index)";

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


// Is then code (a 16-bit unsigned integer) a UTF-16 lead surrogate.
bool _isLeadSurrogate(final int code) =>
    (code & 0xFC00) == 0xD800;

// Is then code (a 16-bit unsigned integer) a UTF-16 trail surrogate.
bool _isTrailSurrogate(final int code) =>
    (code & 0xFC00) == 0xDC00;

// Combine a lead and a trail surrogate value into a single code point.
int _combineSurrogatePair(final int start, final int end) =>
  0x10000 + ((start & 0x3FF) << 10) + (end & 0x3FF);