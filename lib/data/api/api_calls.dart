import 'dart:convert';
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as getx;
import 'package:http/http.dart' as http;
import '../executables/repositories/auth_repo.dart';
import '../services/constants.dart';
import 'api_checker.dart';

class ApiCalls {
  String? token;
  Map<String, String>? mainHeaders;

  validCall(int status) {
    return [200, 422, 201].contains(status);
  }

  apiHandler(http.Response res, url) {
    Fluttertoast.cancel();
    if (kDebugMode) {
      try {
        if ((jsonDecode(res.body) as Map).containsKey('message')) {
          Fluttertoast.showToast(msg: "${jsonDecode(res.body)['message']}");
          log("${jsonDecode(res.body)['message']}",
              name:
                  "${DateTime.now().toString().split(' ')[1]}->HANDLERS->$url");
        } else if ((jsonDecode(res.body) as Map).containsKey('msg')) {
          Fluttertoast.showToast(msg: "${jsonDecode(res.body)['msg']}");
          log("${jsonDecode(res.body)['msg']}",
              name:
                  "${DateTime.now().toString().split(' ')[1]}->HANDLERS->$url");
        } else if ((jsonDecode(res.body) as Map).containsKey('error')) {
          Fluttertoast.showToast(msg: "${jsonDecode(res.body)['error']}");
          log("${jsonDecode(res.body)['error']}",
              name:
                  "${DateTime.now().toString().split(' ')[1]}->HANDLERS->$url");
        }
      } catch (e) {
        log('$e', name: "ERROR AT API HANDLER");
      }
    }
  }

  Future<dynamic> apiCallWithResponsePost(
      String extUrl, Map<String, dynamic> body) async {
    log('$body', name: "Body $extUrl");
    mainHeaders = {
      'Accept': 'application/json',
      'Authorization':
          'Bearer ${token = (getx.Get.find<AuthRepo>().getUserToken())}',
    };
    log(token.toString(), name: "token");
    var url = AppConstants.baseUrl + extUrl;
    log("${url.toString()} *$body", name: "url");
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        body: body,
        headers: mainHeaders,
      );
      log("$url------------>>>>>>${response.statusCode}<----response---->",
          name: "${DateTime.now().toString().split(' ')[1]}->Call->");
      ApiChecker.checkApi(response);
      apiHandler(response, extUrl);
      if (validCall(response.statusCode)) {
        return (response);
      } else {
        log(response.body.toString(), name: "API ERROR :( BODY-->>");
        return "failed";
      }
    } catch (e) {
      log('$url -Error catching data', name: e.toString());
      Fluttertoast.showToast(msg: "Something went wrong !! ");
      return "failed";
    }
  }

  Future<dynamic> apiCallWithResponseGet(String extUrl) async {
    mainHeaders = {
      'Accept': 'application/json',
      'Authorization':
          'Bearer ${token = (getx.Get.find<AuthRepo>().getUserToken())}',
    };
    log(token.toString(), name: "token");
    log(mainHeaders.toString(), name: "token");
    var url = AppConstants.baseUrl + extUrl;

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: mainHeaders,
      );
      log("$url------------>>>>>>${response.statusCode}<----response---->",
          name: "${DateTime.now().toString().split(' ')[1]}->Call->");
      ApiChecker.checkApi(response);
      apiHandler(response, extUrl);
      if (validCall(response.statusCode)) {
        return (response);
      } else {
        log(response.body.toString(), name: "API ERROR :( BODY-->>");
        return "failed";
      }
    } catch (e) {
      log('$url -Error catching data', name: e.toString());
      Fluttertoast.showToast(msg: "Something went wrong !! ");
      return "failed";
    }
  }
}
