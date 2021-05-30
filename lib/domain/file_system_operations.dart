import 'dart:io';

import 'package:path/path.dart';

import 'results.dart';

class FileSystemOperations {
  static Stream<Result<List<String>>> scanDirectoryForMp3(String directoryPath) async* {
    Directory musicDir = Directory(directoryPath);

    if (!await musicDir.exists()) {
      yield IntermediateResult<List<String>>(<String>[], 'The directory $directoryPath doesn\'t exist.');
      return;
    }

    List<String> filenames = [];
    await for (FileSystemEntity file in musicDir.list(followLinks: false)) {
      // Only if its a file with a length of 36 characters ending on ".mp3"
      if (file is File) {
        String filename = basename(file.path);
        if (filename.length == 36 && filename.toLowerCase().endsWith('.mp3')) {
          filenames.add(filename);
        }
      }
    }
    yield IntermediateResult<List<String>>(filenames, 'Found ${filenames.length} valid files in $directoryPath.');
  }
}