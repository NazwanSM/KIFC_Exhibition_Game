/// Shared visual states. Audio/timing are owned by the narration tickets.
enum MascotState {
  idle,
  welcome,
  presenting,
  talking,
  success,
  hintSafety,
  farewell,
}

String mascotClip(MascotState state, {required bool narrating}) =>
    switch (state) {
      MascotState.idle => 'Idle',
      MascotState.welcome => 'Wave',
      MascotState.presenting => 'PointIdle',
      MascotState.talking => narrating ? 'Talk' : 'TalkSilent',
      MascotState.success => 'Happy',
      MascotState.hintSafety => narrating ? 'Feedback' : 'FeedbackSilent',
      MascotState.farewell => narrating ? 'Wave' : 'WaveSilent',
    };
