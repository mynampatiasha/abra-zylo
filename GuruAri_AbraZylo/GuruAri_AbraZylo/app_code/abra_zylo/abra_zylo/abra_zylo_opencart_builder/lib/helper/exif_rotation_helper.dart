import 'package:flutter/foundation.dart' show kIsWeb;

// Conditional import: use stub on web, real implementation on mobile
import 'exif_rotation_stub.dart' if (dart.library.io) 'exif_rotation_mobile.dart';

/// Rotates an image file to correct EXIF orientation.
/// On web, returns the original path unchanged (camera not supported on web).
Future<String> rotateImageIfNeeded(String path) async {
  if (kIsWeb) return path;
  return rotateImageNative(path);
}
