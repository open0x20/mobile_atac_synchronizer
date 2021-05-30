import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock/wakelock.dart';
import 'package:path/path.dart';

import 'package:mobile_atac_synchronizer/domain/certificate_operations.dart';
import 'package:mobile_atac_synchronizer/domain/file_system_operations.dart';
import '../dto/difference_request.dart';
import '../dto/difference_response.dart';
import '../globals.dart';
import 'results.dart';

class MainDomain {
  static Stream<Result<List<String>>> fetchDifference() async* {
    // Check for file system permissions
    if (!await Permission.storage.isGranted) {
      // Request storage permissions
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();

      if (!statuses[Permission.storage].isGranted) {
        yield ErrorResult<List<String>>(null, 'Filesystem access is required for this app to work properly.');
        return;
      }
    }

    // Scan for local files
    List<String> filenames = [];
    List<String> directoriesToScan = [
      '/storage/3735-3531/Music',
      (await getExternalStorageDirectory()).path
    ];
    print(2);
    for (String dir in directoriesToScan) {
      await for (Result<List<String>> result in FileSystemOperations.scanDirectoryForMp3(dir)) {
        filenames.addAll(result.result);
        yield result;
      }
    }
    print(0);
    // Fetch difference from api
    yield IntermediateResult<List<String>>(null, 'Fetching from ' + Globals.API_ATAC_URL);
    try {
      // Create new HTTP client that ignores our self signed certificates
      HttpClient client = HttpClient();
      client.badCertificateCallback = (CertificateOperations.isAllowedCertificateDomain);

      // Create and send the request
      DifferenceRequestDto drd = DifferenceRequestDto(filenames: filenames);
      HttpClientRequest httpRequest = await client.postUrl(Uri.parse(Globals.API_ATAC_URL + Globals.API_ATAC_ACTION_DIFFERENCE));
      httpRequest.write(jsonEncode(drd.toJson()));
      HttpClientResponse httpResponse = await httpRequest.close();

      // If the http code is 200 succeed, otherwise yield an error
      if (httpResponse.statusCode == 200) {
        // Parse the json response and yield the resulting difference
        var jsonResponse = await httpResponse.transform(Utf8Decoder()).join();
        DifferenceResponseDto dd = DifferenceResponseDto.fromJson(jsonDecode(jsonResponse));
        yield FinalResult<List<String>>(dd.data.difference, 'There are ${dd.data.differenceCount} new songs available!');
      } else {
        // An API error occurred
        yield ErrorResult<List<String>>(null, 'E: An API error occurred.');
      }
    } catch (e) {
      // A network error occurred
      yield IntermediateResult<List<String>>(null, 'E: A network error occurred.');
      yield ErrorResult<List<String>>(null, 'E: ${e.toString()}');
    }
  }

  static Stream<Result<List<String>>> downloadDifference(List<String> difference) async* {
    // Don't let the screen turn off
    Wakelock.enable();

    yield IntermediateResult<List<String>>(null, 'Downloading ${difference.length} songs from ' + Globals.API_ATAC_URL);
    try {

      // Create new HTTP client that ignores our self signed certificates
      HttpClient client = HttpClient();
      client.badCertificateCallback = (CertificateOperations.isAllowedCertificateDomain);

      for (String filename in difference) {

        File newFile = File((await getExternalStorageDirectory()).path + '/' + filename);
        if (await newFile.exists()) {
          yield IntermediateResult<List<String>>(null, 'File $filename already exists.');
          continue;
        }

        // Create and send the request
        Uri httpFile = Uri.parse(Globals.API_ATAC_URL + Globals.API_ATAC_ACTION_DOWNLOAD_BY_FILENAME + '/' + filename);
        HttpClientRequest httpRequest = await client.getUrl(httpFile);
        HttpClientResponse httpResponse = await httpRequest.close();
        String filesize = (httpResponse.contentLength / 1024 / 1024).toStringAsFixed(2) + ' MB';

        List<int> bytes = [];
        for (List<int> chunk in await httpResponse.toList()) {
          bytes.addAll(chunk);
        }


        await newFile.writeAsBytes(bytes, flush: true);
        yield IntermediateResult<List<String>>(null, 'Downloaded $filename ($filesize)');
      }

      yield FinalResult<List<String>>(null, 'Finished downloading ${difference.length} new songs.');
    } catch (e) {
      yield IntermediateResult<List<String>>(null, 'E: A network error occurred.');
      yield ErrorResult<List<String>>(null, 'E: ${e.toString()}');
    }

    Wakelock.disable();
  }
}