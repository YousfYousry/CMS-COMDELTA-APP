import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:login_cms_comdelta/JasonHolders/DeviceJason.dart';
import 'package:login_cms_comdelta/JasonHolders/HistoryJason.dart';
import 'package:login_cms_comdelta/JasonHolders/LogJason.dart';
import 'package:smart_select/smart_select.dart';

class RemoteApi {
  static Future<List<LogJason>> getCharacterList(
    int offset,
    int limit,
    String id, {
    String searchTerm,
  }) async =>
      http.post(
        Uri.parse('http://103.18.247.174:8080/AmitProject/admin/getLogs.php'),
        body: {
          'device_id': id,
          // 'offset': offset.toString(),
          // 'limit': limit.toString(),
          // 'search_term': searchTerm.toString(),
        },
      ).mapFromResponse<List<LogJason>, List<dynamic>>(
        (jsonArray) => _parseItemListFromJsonArray(
          jsonArray,
          (jsonObject) => LogJason.fromJson(jsonObject, searchTerm),
        ),
      );

  static Future<List<LogJason>> getList(
    String id, {
    String searchTerm,
  }) async =>
      http.post(
        Uri.parse('http://103.18.247.174:8080/AmitProject/admin/getLogs.php'),
        body: {
          'device_id': id,
          'search_term': "",
        },
      ).mapFromResponse<List<LogJason>, List<dynamic>>(
        (jsonArray) => _parseItemListFromJsonArray(
          jsonArray,
          (jsonObject) => LogJason.fromJson(jsonObject, searchTerm),
        ),
      );

  static Future<List<S2Choice<String>>> getClientList() async => http.post(
        Uri.parse(
            'http://103.18.247.174:8080/AmitProject/admin/getClientList.php'),
        body: {},
      ).mapFromResponse<List<S2Choice<String>>, List<dynamic>>(
        (jsonArray) => _parseItemListFromJsonArray(jsonArray, (jsonObject) {
          var str = jsonObject['client_name'];
          return (str != null && !str.toString().contains("null"))
              ? S2Choice<String>(value: str.toString(), title: str.toString())
              : S2Choice<String>(value: '', title: '');
        }),
      );

  static Future<List<S2Choice<String>>> getLocationList() async => http.post(
    Uri.parse(
        'http://103.18.247.174:8080/AmitProject/getLocations.php'),
    body: {},
  ).mapFromResponse<List<S2Choice<String>>, List<dynamic>>(
        (jsonArray) => _parseItemListFromJsonArray(jsonArray, (jsonObject) {
      var id = jsonObject['location_id'];
      var name = jsonObject['location_name'];
      return (notNull(id)&&notNull(name))
          ? S2Choice<String>(value: id.toString(), title: name.toString())
          : S2Choice<String>(value: '', title: '');
    }),
  );

  static bool notNull(var obj){
    return obj != null && !obj.toString().contains("null");
  }

  static Future<List<HistoryJason>> getHistoryList() async => http.post(
        Uri.parse(
            'http://103.18.247.174:8080/AmitProject/admin/getHistory.php'),
        body: {},
      ).mapFromResponse<List<HistoryJason>, List<dynamic>>(
        (jsonArray) => _parseItemListFromJsonArray(
          jsonArray,
          (jsonObject) => HistoryJason.fromJson(jsonObject),
        ),
      );

  static Future<List<DeviceJason>> getDevicesList() async => http.post(
    Uri.parse(
        'http://103.18.247.174:8080/AmitProject/admin/getDevices.php'),
    body: {},
  ).mapFromResponse<List<DeviceJason>, List<dynamic>>(
        (jsonArray) => _parseItemListFromJsonArray(
      jsonArray,
          (jsonObject) => DeviceJason.fromJsonOnly(jsonObject),
    ),
  );

  static Future<List<DeviceJason>> getClientDevicesList(String clientId) async => http.post(
    Uri.parse(
        'http://103.18.247.174:8080/AmitProject/getDeviceClient.php'),
    body: {
      'client_id': clientId,
    },
  ).mapFromResponse<List<DeviceJason>, List<dynamic>>(
        (jsonArray) => _parseItemListFromJsonArray(
      jsonArray,
          (jsonObject) => DeviceJason.fromJsonOnly(jsonObject),
    ),
  );

  static List<T> _parseItemListFromJsonArray<T>(
    List<dynamic> jsonArray,
    T Function(dynamic object) mapper,
  ) =>
      jsonArray.map(mapper).toList();
}

class GenericHttpException implements Exception {}

class NoConnectionException implements Exception {}

// class _ApiUrlBuilder {
//   static const _baseUrl = 'https://www.breakingbadapi.com/api/';
//   static const _charactersResource = 'characters/';
//
//   static Uri characterList(
//       int offset,
//       int limit, {
//         String searchTerm,
//       }) =>
//       Uri.parse(
//         '$_baseUrl$_charactersResource?'
//             'offset=$offset'
//             '&limit=$limit'
//             '${_buildSearchTermQuery(searchTerm)}',
//       );
//
//   static String _buildSearchTermQuery(String searchTerm) =>
//       searchTerm != null && searchTerm.isNotEmpty
//           ? '&name=${searchTerm.replaceAll(' ', '+').toLowerCase()}'
//           : '';
// }

extension on Future<http.Response> {
  Future<R> mapFromResponse<R, T>(R Function(T) jsonParser) async {
    try {
      final response = await this;
      if (response.statusCode == 200) {
        return jsonParser(jsonDecode(response.body));
      } else {
        throw GenericHttpException();
      }
    } on SocketException {
      throw NoConnectionException();
    }
  }
}
