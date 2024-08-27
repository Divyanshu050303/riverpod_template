import 'dart:async';

class AppDeBouncer {
  final Duration? delay;
  Timer? _timer;

  AppDeBouncer({this.delay});

  void call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay!, action);
  }

  // Notifies if the delayed call is active.
  bool get isRunning => _timer?.isActive ?? false;

  //Cancel the current delayed call.
  void cancel() => _timer?.cancel();
}
