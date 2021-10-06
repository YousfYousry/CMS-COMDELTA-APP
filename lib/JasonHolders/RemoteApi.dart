import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:login_cms_comdelta/JasonHolders/LogJason.dart';

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
          (jsonObject) => LogJason.fromJson(jsonObject,searchTerm),
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
          (jsonObject) => LogJason.fromJson(jsonObject,searchTerm),
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
