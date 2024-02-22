import 'package:change_case/change_case.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';
import 'dart:typed_data' show Uint8List;
import 'dart:html' as html;
import 'package:master_lists/excel_package/Excel Code/MyHomepage.dart';
import '../../Models/ExcelModels/ExcelModels.dart';
import 'ExcelLikeTable.dart';

// ignore: must_be_immutable
class MenuRead extends StatefulWidget {
  MenuRead({super.key});
  @override
  State<MenuRead> createState() => _MenuReadState();
}

class _MenuReadState extends State<MenuRead> {
  FilePickerResult? file;
  List<ExcelModel> alldata = [];

  @override
  void initState() {
    super.initState();
    getExcelFile();
  }

  //File Picker
  Future<void> getExcelFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );
    file = result;
    readfile();
  }

  readfile() {
    if (file != null) {
      var bytes = file!.files.single.bytes;
      var excel = Excel.decodeBytes(bytes!);
      String sheetName = 'Sheet1';
      if (excel.tables.keys.contains(sheetName)) {
        for (var table in excel.tables.keys) {
          if (table == sheetName) {
            var tablerow = excel.tables[table]!.maxRows;

            for (var rowIdx = 1; rowIdx < tablerow; rowIdx++) {
              var row = excel.tables[table]!.rows[rowIdx];

              String key;
              if (row[0]!.value == null) {
                key = 'Pending';
              } else {
                key = row[0]!.value.toString();
              }

              // Check if itemCategory is in proper case
              String itemCategory;
              if (row[2]!.value.toString().isNotEmpty &&
                  row[2]!.value.toString().toTitleCase() ==
                      row[2]!.value.toString()) {
                itemCategory = row[2]!.value.toString();
              } else {
                itemCategory = row[2]!.value.toString();
              }

              // Check if itemName is in proper case
              String itemName;
              if (row[3]!.value.toString().isNotEmpty &&
                  row[3]!.value.toString().toTitleCase() ==
                      row[3]!.value.toString()) {
                itemName = row[3]!.value.toString();
              } else {
                itemName = row[3]!.value.toString();
              }

              //check if ItemMulti is zero or non zero

              String itemsMulti;
              if (int.parse(row[4]!.value.toString()) == 0 &&
                  int.parse(row[8]!.value.toString()) > 0 &&
                  row[12]!.value.toString() != "NA" &&
                  int.parse(row[5]!.value.toString()) == 0 &&
                  int.parse(row[6]!.value.toString()) == 0 &&
                  int.parse(row[7]!.value.toString()) == 0 &&
                  row[9]!.value.toString() == "NA" &&
                  row[10]!.value.toString() == "NA" &&
                  row[11]!.value.toString() == "NA") {
                itemsMulti = row[4]!.value.toString();
              } else if ((int.parse(row[5]!.value.toString()) > 0 &&
                      int.parse(row[6]!.value.toString()) > 0 &&
                      int.parse(row[7]!.value.toString()) > 0 &&
                      row[9]!.value.toString() != 'NA' &&
                      row[10]!.value.toString() != 'NA' &&
                      row[11]!.value.toString() != 'NA' &&
                      int.parse(row[8]!.value.toString()) == 0 &&
                      row[12]!.value.toString() == 'NA') ||
                  (int.parse(row[6]!.value.toString()) > 0 &&
                      int.parse(row[6]!.value.toString()) > 0 &&
                      row[10]?.value.toString() != 'NA' &&
                      row[11]?.value.toString() != 'NA' &&
                      int.parse(row[5]!.value.toString()) == 0 &&
                      int.parse(row[8]!.value.toString()) == 0 &&
                      row[9]!.value.toString().toString() == 'NA' &&
                      row[12]!.value.toString().toString() == 'NA')) {
                itemsMulti = row[4]!.value.toString();
              } else {
                itemsMulti = 'Error';
              }

              // var itemPrice1 = row[5]?.value ?? 'No Info';
              // var itemPrice2 = row[6]?.value ?? 'No Info';
              // var itemPrice3 = row[7]?.value ?? 'No Info';
              // var itemPrice4 = row[8]?.value ?? 'No Info';
              // var itemSize1 = row[9]?.value ?? 'No Info';
              // var itemSize2 = row[10]?.value ?? 'No Info';
              // var itemSize3 = row[11]?.value ?? 'No Info';
              // var itemSize4 = row[12]?.value ?? 'No Info';
              // var itemDescription = row[13]?.value ?? 'No Info';

              String itemType;
              if (row[14]?.value.toString() == 'Veg' ||
                  row[14]?.value.toString() == 'Egg' ||
                  row[14]?.value.toString() == 'NonVeg') {
                itemType = row[14]!.value.toString();
              } else {
                itemType = row[14]!.value.toString();
              }
              var itemTypeImage = row[15]?.value ?? 'No Info';
              var ifAddOns = row[16]?.value ?? 'No Info';
              var ifExtra = row[17]?.value ?? 'No Info';
              var itemDiscountPercent = row[18]?.value ?? 'No Info';
              var itemImage = row[19]?.value ?? 'No Info';

              alldata.add(ExcelModel(
                key: key,
                storeID: row[1]?.value.toString() ?? 'No Info',
                itemCategory: itemCategory,
                itemName: itemName,
                itemsMulti: itemsMulti,
                itemPrice1: row[5]?.value.toString() ?? 'No Info',
                itemPrice2: row[6]?.value.toString() ?? 'No Info',
                itemPrice3: row[7]?.value.toString() ?? 'No Info',
                itemPrice4: row[8]?.value.toString() ?? 'No Info',
                itemSize1: row[9]?.value.toString() ?? 'No Info',
                itemSize2: row[10]?.value.toString() ?? 'No Info',
                itemSize3: row[11]?.value.toString() ?? 'No Info',
                itemSize4: row[12]?.value.toString() ?? 'No Info',
                itemDescription: row[13]?.value.toString() ?? 'No Info',
                itemType: itemType,
                itemTypeImage: row[15]?.value.toString() ?? 'No Info',
                ifAddOns: row[16]?.value.toString() ?? 'No Info',
                ifExtra: row[17]?.value.toString() ?? 'No Info',
                itemDiscountPercent: row[18]?.value.toString() ?? 'No Info',
                itemImage: row[19]?.value.toString() ?? 'No Info',
                itemIsAvailable: row[20]?.value.toString() ?? 'No Info',
                itemIsBestSeller: row[21]?.value.toString() ?? 'No Info',
                itemIsNewlyLaunched: row[22]?.value.toString() ?? 'No Info',
                itemIsRecommended: row[23]?.value.toString() ?? 'No Info',
                itemRating: row[24]?.value.toString() ?? 'No Info',
                availableItem1: row[25]?.value.toString() ?? 'No Info',
                availableItem2: row[26]?.value.toString() ?? 'No Info',
                availableItem3: row[27]?.value.toString() ?? 'No Info',
                availableItem4: row[28]?.value.toString() ?? 'No Info',
              ));
            } //end
          }
        }
      }
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ExcelLikeTable(alldata: alldata),
          ));
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('No Excel file selected'),
            content: Text('Please select an Excel file before proceeding.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(),
                    ),
                  );
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

// updating Excel
  void updateExcel(List<ExcelModel> updatedList) async {
    // Create a new Excel workbook
    var excel = Excel.createExcel();

    // Add a sheet to the workbook
    var sheet = excel['Sheet1'];
    var headerStyle = CellStyle(
      bold: true, // Yellow background
    );
    // Add headers to the sheet
    sheet.appendRow([
      const TextCellValue('Key'),
      const TextCellValue('StoreID'),
      const TextCellValue('ItemCategory'),
      const TextCellValue('ItemName'),
      const TextCellValue('ItemsMulti'),
      const TextCellValue('ItemPrice1'),
      const TextCellValue('ItemPrice2'),
      const TextCellValue('ItemPrice3'),
      const TextCellValue('ItemPrice4'),
      const TextCellValue('ItemSize1'),
      const TextCellValue('ItemSize2'),
      const TextCellValue('ItemSize3'),
      const TextCellValue('ItemSize4'),
      const TextCellValue('ItemDescription'),
      const TextCellValue('ItemType'),
      const TextCellValue('ItemTypeImage'),
      const TextCellValue('IfAddOns'),
      const TextCellValue('IfExtra'),
      const TextCellValue('ItemDiscountPercent'),
      const TextCellValue('ItemImage')
    ]);

    // Populate the sheet with data from the updatedList
    for (var item in updatedList) {
      sheet.appendRow(<CellValue?>[
        TextCellValue(item.key!),
        TextCellValue(item.storeID!),
        TextCellValue(item.itemCategory!),
        TextCellValue(item.itemName!),
        TextCellValue(item.itemsMulti!),
        TextCellValue(item.itemPrice1!),
        TextCellValue(item.itemPrice2!),
        TextCellValue(item.itemPrice3!),
        TextCellValue(item.itemPrice4!),
        TextCellValue(item.itemSize1!),
        TextCellValue(item.itemSize2!),
        TextCellValue(item.itemSize3!),
        TextCellValue(item.itemSize4!),
        TextCellValue(item.itemDescription!),
        TextCellValue(item.itemType!),
        TextCellValue(item.itemTypeImage!),
        TextCellValue(item.ifAddOns!),
        TextCellValue(item.ifExtra!),
        TextCellValue(item.itemDiscountPercent!),
        TextCellValue(item.itemImage!),
      ]);
    }

    // Save the Excel file
    var encodedBytes = excel.encode();
    var blob = html.Blob([Uint8List.fromList(encodedBytes!)]);
    var url = html.Url.createObjectUrlFromBlob(blob);
    html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Excel Reader'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Text('Please Wait! while Your Excel File is Uploading...')
          ],
        ),
      ),
    );
  }
}
