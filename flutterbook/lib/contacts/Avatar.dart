import 'dart:io';
import 'package:path/path.dart';

mixin Avatar {
  static Directory docsDir;

  File avatarTempFile() {
    return File(avatarTempFileName());
  }

  String avatarTempFileName() {
    return join(docsDir.path, "avatar");
  }

  String avatarFileName(int id) {
    return join(docsDir.path, id.toString());
  }
}