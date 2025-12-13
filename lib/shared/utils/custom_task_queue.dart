import 'package:logger/logger.dart';

class CustomTaskQueue {
  final List<Future<void> Function()> _queue = [];
  bool _isRunning = false;

  void add(Future<void> Function() task) {
    _queue.add(task);
    _run();
  }

  void _run() async {
    if (_isRunning) return;

    _isRunning = true;

    while (_queue.isNotEmpty) {
      final task = _queue.removeAt(0);

      try {
        await task();
      } catch (e) {
        // optional error handling
        Logger().e("TaskQueue error: $e");
      }

      // optional throttle
      await Future.delayed(const Duration(milliseconds: 250));
    }

    _isRunning = false;
  }
}
