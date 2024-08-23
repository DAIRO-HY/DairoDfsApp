import 'dart:async';

class SyncLock {
  Completer<void> _completer = Completer<void>();

  SyncLock() {
    //_completer.complete();
  }

  void synchronized(void Function() action) {
    final previousCompleter = _completer;
    _completer = Completer<void>();

    previousCompleter.future.then((_) {
      try {
        action();
      } finally {
        _completer.complete();
      }
    });
  }

  Future<void> lock() {
    return _completer.future;
  }

  void release() {
    if (!_completer.isCompleted) {
      _completer.complete();
    }
  }
}
