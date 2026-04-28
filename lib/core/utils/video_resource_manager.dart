import 'package:flutter/foundation.dart';

/// A global manager to track and release video resources, 
/// especially hardware decoders on Android.
class VideoResourceManager {
  static final VideoResourceManager _instance = VideoResourceManager._internal();
  factory VideoResourceManager() => _instance;
  VideoResourceManager._internal();

  final List<VoidCallback> _releaseCallbacks = [];
  final List<VoidCallback> _reInitCallbacks = [];

  /// Register a callback to release a video player's resources.
  void registerThumbnail(VoidCallback release, VoidCallback reInit) {
    _releaseCallbacks.add(release);
    _reInitCallbacks.add(reInit);
  }

  /// Remove a registered callback.
  void unregisterThumbnail(VoidCallback release, VoidCallback reInit) {
    _releaseCallbacks.remove(release);
    _reInitCallbacks.remove(reInit);
  }

  /// Release all registered background video decoders.
  void releaseAllThumbnails() {
    debugPrint("VideoResourceManager: Releasing ${_releaseCallbacks.length} background decoders");
    final callbacks = List<VoidCallback>.from(_releaseCallbacks);
    for (var release in callbacks) {
      try {
        release();
      } catch (e) {
        debugPrint("Error releasing video thumbnail: $e");
      }
    }
  }

  /// Re-initialize all released background video decoders.
  void reInitializeThumbnails() {
    debugPrint("VideoResourceManager: Re-initializing ${_reInitCallbacks.length} background decoders");
    final callbacks = List<VoidCallback>.from(_reInitCallbacks);
    for (var reInit in callbacks) {
      try {
        reInit();
      } catch (e) {
        debugPrint("Error re-initializing video thumbnail: $e");
      }
    }
  }
}
