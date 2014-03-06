part of parsing;

class IterableString extends IterableBase<int> {
  static const IterableString EMPTY = const IterableString._internal("");

  factory IterableString(final String string) =>
      string.isEmpty ? EMPTY : new IterableString._internal(string);

  final String _string;

  const IterableString._internal(this._string);

  bool get isEmpty =>
      _string.isEmpty;

  StringIterator get iterator =>
      new StringIterator(_string);

  String toString() =>
      _string;
}

class StringIterator implements BidirectionalIterator<int> {
  int _current = null;
  int _index = -1;
  final String string;

  StringIterator(this.string);

  int get current {
    if (_current == null) {
      throw new StateError("Index is out of bounds");
    }

    return _current;
  }

  String get currentAsString {
    if (_current == null) {
      throw new StateError("Index is out of bounds");
    }
    return _isLeadSurrogate(string.codeUnitAt(index)) ?
        string.substring(index, index + 2) :
        string.substring(index, index + 1);
  }

  int get index => _index;

  void set index(final int index) {
    checkRangeInclusive(-1, string.length, index);
    if ((index > 0) &&
        (index < string.length) &&
        _isTrailSurrogate(string.codeUnitAt(index))) {
      throw new ArgumentError("Index inside surrogate pair: $index");
    }
    _index = index;
    _updateCurrent();
  }

  bool moveNext() {
    if (index < string.length) {
      _moveIndexToNextCodePointIndex();
      _updateCurrent();
      return !(index == string.length);
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
        (index < string.length - 1) &&
        _isLeadSurrogate(string.codeUnitAt(index))) {
      _index++;
    }
    _index++;
  }

  void _moveIndexToPreviousCodePointIndex() {
    if ((index > 0) &&
        (index < string.length) &&
        _isTrailSurrogate(string.codeUnitAt(index))) {
      _index--;
    }
    _index--;
  }

  void _updateCurrent() {
    if (index == string.length || index < 0) {
      this._current = null;
    } else {
      int codeUnit = string.codeUnitAt(index);
      this._current =
          _isLeadSurrogate(string.codeUnitAt(index)) ?
            _combineSurrogatePair(codeUnit, string.codeUnitAt(index + 1)) :
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