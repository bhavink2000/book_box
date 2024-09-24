import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:book_box/network/api_constant.dart';

Future postData({required String paramUri, required Map params}) async {
  var response =
      await http.post(Uri.parse(ApiConstant.baseUrl + paramUri), body: params);

  print(jsonDecode(response.body));

  return jsonDecode(response.body);
}

Future getData({required String paramUri}) async {
  var response = await http.get(Uri.parse(ApiConstant.baseUrl + paramUri));
  if (response.body.isNotEmpty) {
    var body = json.decode(response.body);
    return body;
  }

  //print(response.body);
}
