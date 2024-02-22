import 'dart:convert';
import 'package:master_lists/mastersScreen/services/services.dart';
import 'package:recase/recase.dart';
import 'package:http/http.dart' as http;

class FirebaseLogic {
  String API_ENDPOINT_URL='';

  Future<bool> isDataValid(Map<String, String?> data) async {
    if (isItemCategoryValid(data) &&
        isItemNameValid(data) &&
        isItemsMultiValid(data) &&
        isItemTypeValid(data) &&
        await isKeyValid(data)) {
      return true;
    }
    return false;
  }

  bool isItemCategoryValid(Map<String, String?> data) {
    if (data['itemCategory'] != data['itemCategory'].toString().titleCase) {
      return false;
    }
    return true;
  }

  bool isItemNameValid(Map<String, String?> data) {
    if (data['itemName'] != data['itemName'].toString().titleCase) {
      return false;
    }
    return true;
  }

  bool isItemsMultiValid(Map<String, String?> data) {
    if (int.parse(data['itemsMulti'].toString()) == 0 &&
        int.parse(data['itemPrice4'].toString()) > 0 &&
        int.parse(data['itemPrice1'].toString()) == 0 &&
        int.parse(data['itemPrice2'].toString()) == 0 &&
        int.parse(data['itemPrice3'].toString()) == 0 &&
        data['itemSize4'].toString() != 'NA' &&
        data['itemSize1'].toString() == 'NA' &&
        data['itemSize2'].toString() == 'NA' &&
        data['itemSize3'].toString() == 'NA') {
      return true;
    } else if (int.parse(data['itemsMulti'].toString()) == 1 &&
        int.parse(data['itemPrice4'].toString()) == 0 &&
        int.parse(data['itemPrice1'].toString()) > 0 &&
        int.parse(data['itemPrice2'].toString()) > 0 &&
        int.parse(data['itemPrice3'].toString()) > 0 &&
        data['itemSize4'].toString() == 'NA' &&
        data['itemSize1'].toString() != 'NA' &&
        data['itemSize2'].toString() != 'NA' &&
        data['itemSize3'].toString() != 'NA') {
      return true;
    } else if (int.parse(data['itemsMulti'].toString()) == 1 &&
        int.parse(data['itemPrice4'].toString()) == 0 &&
        int.parse(data['itemPrice1'].toString()) == 0 &&
        int.parse(data['itemPrice2'].toString()) > 0 &&
        int.parse(data['itemPrice3'].toString()) > 0 &&
        data['itemSize4'].toString() == 'NA' &&
        data['itemSize1'].toString() == 'NA' &&
        data['itemSize2'].toString() != 'NA' &&
        data['itemSize3'].toString() != 'NA') {
      return true;
    } else {
      return false;
    }
  }

  bool isItemTypeValid(Map<String, String?> data) {
    if (data['itemType'] == 'Veg' ||
        data['itemType'] == 'NonVeg' ||
        data['itemType'] == 'Egg') {
      return true;
    }
    return false;
  }


  Future<bool> isKeyValid(Map<String, String?> data) async {
    if (data['key'] == "No Info" || data['key'] == 'Pending') {
      return true;
    } else if (data['key'] != null) {
      bool recordExists =
          await FirebaseApi.checkRecordStatus(data['key']!, data);
      return recordExists;
    } else {
      return false;
    }
  }

  Future<List<bool>> uploadDataToFirebase(
      List<Map<String, String?>> data) async {
    List<bool> uploadResults = [];
    for (var entry in data) {
      if (await isDataValid(entry)) {
        bool dataExists =
            await FirebaseApi.checkRecordStatus(entry['key']!, entry);
        if (!dataExists) {
          // Only upload if the data does not already exist
          uploadResults.add(await FirebaseApi.uploadData(entry));
          print('Data uploaded to Firebase with key: ${entry['key']}');
        } else {
          print(
              'Data already exists for key: ${entry['key']}. Skipping upload.');
          uploadResults.add(true);
        }
      } else {
        print('Invalid data, not uploaded: $entry');
        uploadResults.add(false);
      }
    }
    return uploadResults;
  }
}

class FirebaseApi {
  static Future<bool> uploadData(Map<String, String?> jsonData) async {
    final apiUrl = Uri.parse('$API_ENDPOINT_URL/uploadData');

    try {
      final response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(jsonData),
      );

      if (response.statusCode == 200) {
        print('Data uploaded to API successfully');
        return true;
      } else {
        print(
            'Failed to upload data to API. Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error uploading data to API: $e');
      return false;
    }
  }

  static Future<bool> checkRecordStatus(
      String key, Map<String, String?> jsonData) async {
    final apiUrl =
        Uri.parse('$API_ENDPOINT_URL/checkRecordStatus/-$key');
    try {
      final response = await http.get(apiUrl);
      if (response.statusCode == 200) {
        print('Record found for key: $key');
        updateData(key, jsonData);
        return true;
      } else {
        print('Record not found for key: $key');
        return false;
      }
    } catch (e) {
      print('Error checking record status: $e');
      return false;
    }
  }

  static Future<bool> updateData(
      String key, Map<String, String?> jsonData) async {
    final apiUrl = Uri.parse('$API_ENDPOINT_URL/update/-$key');

    try {
      final response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(jsonData),
      );

      if (response.statusCode == 200) {
        print('Data updated in Firebase successfully');
        return true;
      } else {
        print(
            'Failed to update data in Firebase. Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error updating data in Firebase: $e');
      return false;
    }
  }

  static Future<List<Map<String, String?>>> getData() async {
    final apiUrl = Uri.parse('$API_ENDPOINT_URL/getData');

    try {
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        final List<Map<String, String?>> dataList = [];

        for (var data in responseData) {
          dataList.add(Map<String, String?>.from(data));
        }

        print('Data fetched from Firebase successfully');
        return dataList;
      } else {
        print(
            'Failed to fetch data from Firebase. Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching data from Firebase: $e');
      return [];
    }
  }
}
