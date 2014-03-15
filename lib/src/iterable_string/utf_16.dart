part of parsing;

class _Utf16String extends IterableBase<int> implements IterableString {
  final String _string;

  const _Utf16String(this._string);

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

  bool _eof = false;

  _Utf16Iterator(this.iterable);

  int get current => _current;

  /*
  String get currentAsString {
    if (_current == null) {
      throw new StateError("Index is out of bounds");
    }
    return _isLeadSurrogate(string.codeUnitAt(index)) ?
        string.substring(index, index + 2) :
        string.substring(index, index + 1);
  }*/

  bool get eof => _eof;

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
      _eof = false;
    }

  }

  bool moveNext() {
    if (eof) {
      return false;
    }

    _moveIndexToNextCodePointIndex();
    _updateCurrent();
    _eof = (index == iterable.toString().length);
    return !eof;

  }

  bool movePrevious() {
    _eof = false;

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