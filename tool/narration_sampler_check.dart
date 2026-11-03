// Browser-only behavioral check built in release mode like the benchmark.
import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;
import 'package:fire_prevention_challenge/core/audio/narration_position_updater_web.dart';

@JS('globalThis.samplerCheck')
external set samplerCheck(JSString value);

Future<void> frame() {
  final done = Completer<void>();
  web.window.requestAnimationFrame(((double _) => done.complete()).toJS);
  return done.future;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SizedBox.shrink());
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await Future<void>.delayed(Duration.zero);
    final failures = <String>[];
    var reads = 0;
    final updater = createNarrationPositionUpdater(
      getPosition: () async {
        reads++;
        return const Duration(milliseconds: 120);
      },
    );
    final received = <Duration>[];
    final two = Completer<void>();
    final sub = updater.positionStream.listen((p) {
      received.add(p);
      if (received.length >= 2 && !two.isCompleted) two.complete();
    });
    try {
      updater.start();
      updater.start();
      if (WidgetsBinding.instance.hasScheduledFrame) {
        failures.add('Audio-only sampling scheduled a Flutter paint.');
      }
      await two.future.timeout(const Duration(seconds: 3));
      if (received.any((p) => p != const Duration(milliseconds: 120))) {
        failures.add('Sampled position changed.');
      }
      updater.stop();
      await frame();
      final stopped = reads;
      await frame();
      await frame();
      if (reads != stopped) failures.add('Sampling continued after stop.');
      updater.start();
      await frame();
      await frame();
      if (reads <= stopped) failures.add('Sampling did not resume.');
    } catch (error) {
      failures.add('$error');
    } finally {
      await updater.dispose();
      await sub.cancel();
    }
    final disposedReads = reads;
    await frame();
    await frame();
    if (reads != disposedReads) {
      failures.add('Sampling continued after dispose.');
    }
    samplerCheck = jsonEncode({
      'passed': failures.isEmpty,
      'failures': failures,
      'samples': received.length,
      'positionPreserved': received.every(
        (p) => p == const Duration(milliseconds: 120),
      ),
    }).toJS;
  });
}
