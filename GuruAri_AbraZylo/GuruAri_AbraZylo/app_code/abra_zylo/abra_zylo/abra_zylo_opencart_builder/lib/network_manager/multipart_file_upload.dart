import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';

class MultiPartImageUpload {
  static const String tag = "MultiPartImageUpload:- ";

  static asyncFileUpload(String fileUploadApi, String? filePath,
      String? filename, String? extension) async {
    var decoded = Uri.decodeFull(fileUploadApi);
    var request = http.MultipartRequest("POST", Uri.parse(decoded));
    print(decoded);
    if (filePath != null && filePath != "" && extension != "") {
      request.fields["type"] = "." + extension!;
      var multipartData = await http.MultipartFile.fromPath("file", filePath,
          filename: filename, contentType: new MediaType('image', 'jpeg'));
      print(tag + "multipart data-> ${multipartData}");
      print(tag + "file path-> ${filePath}");
      print(tag + "file extension-> ${extension}");
      print(tag + "file name -> ${filename}");
      request.fields["wk_token"] = await AppSharedPref.getWkToken();
      request.files.add(multipartData);
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      print(tag + "${responseData}");
      var responseString = String.fromCharCodes(responseData);
      print(tag + "${responseString}");
      return responseString;
    }
  }
}
