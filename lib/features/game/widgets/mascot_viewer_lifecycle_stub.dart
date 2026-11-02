class MascotViewerLifecycle {
  MascotViewerLifecycle(
    String id, {
    required void Function() onLoad,
    required void Function() onError,
  });
  void setPlayback({required bool play}) {}
  void restart() {}
  void release() {}
}
