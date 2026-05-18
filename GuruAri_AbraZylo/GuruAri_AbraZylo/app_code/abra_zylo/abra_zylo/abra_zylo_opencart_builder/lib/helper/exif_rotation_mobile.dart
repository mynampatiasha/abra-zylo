/// Mobile implementation — returns path as-is.
/// To re-enable EXIF rotation on mobile, add flutter_exif_rotation back to
/// pubspec.yaml and uncomment the implementation below.
Future<String> rotateImageNative(String path) async {
  // final rotated = await FlutterExifRotation.rotateImage(path: path);
  // return rotated.path;
  return path;
}
