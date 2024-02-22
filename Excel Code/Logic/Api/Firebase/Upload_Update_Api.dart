import 'dart:convert';
import 'package:http/http.dart' as http;

class FirebaseApi {
  static Future<void> uploadData(Map<String, String?> jsonData) async {
    final apiUrl = Uri.parse('http://localhost:3000/api/uploadData');

    try {
      final response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(jsonData),
      );

      if (response.statusCode == 200) {
        print('Data uploaded to API successfully');
      } else {
        print(
            'Failed to upload data to API. Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
    } catch (e) {
      print('Error uploading data to API: $e');
    }
  }

  static Future<void> updateData(
      String key, Map<String, String?> jsonData) async {
    final apiUrl = Uri.parse('http://localhost:3000/api/update/-$key');

    try {
      final response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(jsonData),
      );

      if (response.statusCode == 200) {
        print('Data updated in Firebase successfully');
      } else {
        print(
            'Failed to update data in Firebase. Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
    } catch (e) {
      print('Error updating data in Firebase: $e');
    }
  }
}
