import 'dart:convert';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:http/http.dart' as http;

import 'dart:typed_data' show Uint8List;
import 'dart:html' as html;

import 'package:master_lists/mastersScreen/services/services.dart';

class ExcelHandler {
  static Future<void> saveDataToExcel() async {
    final response =
        await http.get(Uri.parse('$API_ENDPOINT_URL/getData'));

    if (response.statusCode == 200) {
      final dynamic responseData = json.decode(response.body);

      if (responseData is List) {
        final List<Map<String, dynamic>> data = List.castFrom(responseData);
        _generateExcelFile(data);
      } else {
        print("Unexpected response format");
      }
    }
  }

  static void _generateExcelFile(List<Map<String, dynamic>> datalist) {
    // Create an Excel workbook and add a worksheet
    final Excel excel = Excel.createExcel();
    final Sheet sheet = excel['Sheet1'];

    // Add headers to the Excel sheet
    sheet.appendRow([
      TextCellValue('availableItem1'),
      TextCellValue('availableItem2'),
      TextCellValue('availableItem3'),
      TextCellValue('availableItem4'),
      TextCellValue('ifAddOns'),
      TextCellValue('ifExtra'),
      TextCellValue('itemCategory'),
      TextCellValue('itemDescription'),
      TextCellValue('itemDiscountPercent'),
      TextCellValue('itemImage'),
      TextCellValue('itemIsAvailable'),
      TextCellValue('itemIsBestSeller'),
      TextCellValue('itemIsNewlyLaunched'),
      TextCellValue('itemIsRecommended'),
      TextCellValue('itemName'),
      TextCellValue('itemPrice1'),
      TextCellValue('itemPrice2'),
      TextCellValue('itemPrice3'),
      TextCellValue('itemPrice4'),
      TextCellValue('itemRating'),
      TextCellValue('itemSize1'),
      TextCellValue('itemSize2'),
      TextCellValue('itemSize3'),
      TextCellValue('itemSize4'),
      TextCellValue('itemType'),
      TextCellValue('itemTypeImage'),
      TextCellValue('itemsMulti'),
      TextCellValue('key'),
      TextCellValue('storeID'),
    ]);

    // Add data to the Excel sheet
    datalist.forEach((entry) {
      sheet.appendRow([
        TextCellValue(entry['availableItem1'] ?? ''),
        TextCellValue(entry['availableItem2'] ?? ''),
        TextCellValue(entry['availableItem3'] ?? ''),
        TextCellValue(entry['availableItem4'] ?? ''),
        TextCellValue(entry['ifAddOns'] ?? ''),
        TextCellValue(entry['ifExtra'] ?? ''),
        TextCellValue(entry['itemCategory'] ?? ''),
        TextCellValue(entry['itemDescription'] ?? ''),
        TextCellValue(entry['itemDiscountPercent'] ?? ''),
        TextCellValue(entry['itemImage'] ?? ''),
        TextCellValue(entry['itemIsAvailable'] ?? ''),
        TextCellValue(entry['itemIsBestSeller'] ?? ''),
        TextCellValue(entry['itemIsNewlyLaunched'] ?? ''),
        TextCellValue(entry['itemIsRecommended'] ?? ''),
        TextCellValue(entry['itemName'] ?? ''),
        TextCellValue(entry['itemPrice1'] ?? ''),
        TextCellValue(entry['itemPrice2'] ?? ''),
        TextCellValue(entry['itemPrice3'] ?? ''),
        TextCellValue(entry['itemPrice4'] ?? ''),
        TextCellValue(entry['itemRating'] ?? ''),
        TextCellValue(entry['itemSize1'] ?? ''),
        TextCellValue(entry['itemSize2'] ?? ''),
        TextCellValue(entry['itemSize3'] ?? ''),
        TextCellValue(entry['itemSize4'] ?? ''),
        TextCellValue(entry['itemType'] ?? ''),
        TextCellValue(entry['itemTypeImage'] ?? ''),
        TextCellValue(entry['itemsMulti'] ?? ''),
        TextCellValue(entry['key'] ?? ''),
        TextCellValue(entry['storeID'] ?? ''),
      ]);
    });
    var encodedBytes = excel.encode();
    var blob = html.Blob([Uint8List.fromList(encodedBytes!)]);
    var url = html.Url.createObjectUrlFromBlob(blob);

    // Create an anchor element and trigger the download
    var anchor = html.AnchorElement(href: url)
      ..target = 'web_download'
      ..download = 'Excel_Menu.xlsx' // specify the desired file name
      ..click();

    html.Url.revokeObjectUrl(url);
  }
}


// class FirebaseDataModel {
//   String? key;
//   dynamic availableItem1;
//   dynamic availableItem2;
//   dynamic availableItem3;
//   dynamic availableItem4;
//   dynamic ifAddOns;
//   dynamic ifExtra;
//   String itemCategory;
//   String? itemDescription;
//   dynamic itemDiscountPercent;
//   String itemImage;
//   dynamic itemIsAvailable;
//   dynamic itemIsBestSeller;
//   dynamic itemIsNewlyLaunched;
//   dynamic itemIsRecommended;
//   String itemName;
//   dynamic itemPrice1;
//   dynamic itemPrice2;
//   dynamic itemPrice3;
//   dynamic itemPrice4;
//   dynamic itemRating;
//   String itemSize1;
//   String itemSize2;
//   String itemSize3;
//   String itemSize4;
//   String itemType;
//   String itemTypeImage;
//   dynamic itemsMulti;
//   String storeID;

//   FirebaseDataModel({
//     this.key,
//     this.availableItem1,
//     this.availableItem2,
//     this.availableItem3,
//     this.availableItem4,
//     this.ifAddOns,
//     this.ifExtra,
//     required this.itemCategory,
//     this.itemDescription,
//     this.itemDiscountPercent,
//     required this.itemImage,
//     this.itemIsAvailable,
//     this.itemIsBestSeller,
//     this.itemIsNewlyLaunched,
//     this.itemIsRecommended,
//     required this.itemName,
//     this.itemPrice1,
//     this.itemPrice2,
//     this.itemPrice3,
//     this.itemPrice4,
//     this.itemRating,
//     required this.itemSize1,
//     required this.itemSize2,
//     required this.itemSize3,
//     required this.itemSize4,
//     required this.itemType,
//     required this.itemTypeImage,
//     this.itemsMulti,
//     required this.storeID,
//   });

//   // Factory method to create an instance from a map
//   factory FirebaseDataModel.fromMap(Map<String, dynamic> map) {
//     return FirebaseDataModel(
//       key: map['key'],
//       availableItem1: map['availableItem1'],
//       availableItem2: map['availableItem2'],
//       availableItem3: map['availableItem3'],
//       availableItem4: map['availableItem4'],
//       ifAddOns: map['ifAddOns'],
//       ifExtra: map['ifExtra'],
//       itemCategory: map['itemCategory'] ?? '',
//       itemDescription: map['itemDescription'],
//       itemDiscountPercent: map['itemDiscountPercent'],
//       itemImage: map['itemImage'] ?? '',
//       itemIsAvailable: map['itemIsAvailable'],
//       itemIsBestSeller: map['itemIsBestSeller'],
//       itemIsNewlyLaunched: map['itemIsNewlyLaunched'],
//       itemIsRecommended: map['itemIsRecommended'],
//       itemName: map['itemName'] ?? '',
//       itemPrice1: map['itemPrice1'],
//       itemPrice2: map['itemPrice2'],
//       itemPrice3: map['itemPrice3'],
//       itemPrice4: map['itemPrice4'],
//       itemRating: map['itemRating'],
//       itemSize1: map['itemSize1'] ?? '',
//       itemSize2: map['itemSize2'] ?? '',
//       itemSize3: map['itemSize3'] ?? '',
//       itemSize4: map['itemSize4'] ?? '',
//       itemType: map['itemType'] ?? '',
//       itemTypeImage: map['itemTypeImage'] ?? '',
//       itemsMulti: map['itemsMulti'],
//       storeID: map['storeID'] ?? '',
//     );
//   }
// }
