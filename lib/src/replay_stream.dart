part of parsing;

class ReplayStream<T> extends Stream<T> {
  factory ReplayStream(final Stream<T> stream) {
    checkNotNull(stream);
    return stream is ReplayStream ?
        ((stream as ReplayStream)..stopReplay()..replay()) :
          new ReplayStream._(stream);
  }

  final Stream<T> _stream;
  final MutableSequence<Try<T>> _events = new GrowableSequence();
  final MutableSet<StreamController> _controllers = new MutableSet.hash();

  Option<StreamSubscription> subscription = Option.NONE;

  bool _isReplay = true;
  bool _isSubscribed = false;
  bool _isClosed = false;
  bool _retain = false;

  ReplayStream._(this._stream);

  bool get retain =>
      _retain;

  void set retain(bool retain) {
    _retain = retain;
    if (!retain && _controllers.isEmpty) {
      subscription.map((final StreamSubscription subscription) =>
                        subscription.cancel());
    }
  }

  Iterable<T> get values =>
      _events
        .where((final Try<T> event) =>
            event.then(
              (final T value) => true,
              onError: (_) => false).value)
        .map((final Try<T> event) => event.value);

  void stopReplay() {
    _isReplay = false;
    clear();
  }

  void replay() {
    _isReplay = true;
  }

  void clear() =>
      _events.clear();

  StreamSubscription<T> listen(void onData(T event),
                               { Function onError,
                                 void onDone(),
                                 bool cancelOnError}) {
      if (!_isSubscribed) {
        _subscribe();
        _isSubscribed = true;
      }

      StreamController controller;
      controller = new StreamController(
          onCancel: () {
            _controllers.remove(controller);
            if (!retain && _controllers.isEmpty) {
              subscription.map((final StreamSubscription subscription) =>
                  subscription.cancel());
            }
          });

      for (final Try<T> event in _events) {
        event.then(
            (final T value) => controller.add(event),
            onError: (final error, [final StackTrace stackTrace]) =>
                controller.addError(error, stackTrace));
      }

      if (_isClosed) {
        controller.close();
      } else {
        _controllers.add(controller);
      }

      return controller.stream.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  void addEvent(final Try<T> event) {
    if (_isReplay) {
      _events.add(event);
    }
  }

  void _subscribe() {
    final StreamSubscription subscription = _stream.listen(
        (final T data) {
          addEvent(new Try.success(data));
          for (final StreamController controller in _controllers) {
            controller.add(data);
          }
        },
        onError: (final error, [final StackTrace stackTrace]) {
          addEvent(new Try.failure(error, stackTrace));
          for (final StreamController controller in _controllers) {
            controller.addError(error, stackTrace);
          }
        },
        onDone: () {
          _isClosed = true;
          for (final StreamController controller in _controllers) {
            controller.close();
          }
          _controllers.clear();
        });

    this.subscription = new Option(subscription);
  }
}