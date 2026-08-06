import 'dart:convert';
import 'dart:io';

void main() async {
  var request = await HttpClient().postUrl(Uri.parse('https://abra-zylo.com/index.php?route=api/wkrestapi/catalog/searchSuggest'));
  request.headers.set('Content-Type', 'application/x-www-form-urlencoded');
  request.write('search=tshirt');
  var response = await request.close();
  var responseBody = await response.transform(utf8.decoder).join();
  print(responseBody);
}
