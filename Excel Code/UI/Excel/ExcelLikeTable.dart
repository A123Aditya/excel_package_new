import 'package:change_case/change_case.dart';
import 'package:master_lists/excel_package/Excel Code/FirebaseClass.dart';
import 'package:master_lists/excel_package/Excel Code/Logic/ExcelLogic/SavingExcel.dart';
import 'package:master_lists/excel_package/Excel Code/Utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';
import '../../Logic/ExcelLogic/ValidationLogics.dart';
import '../../Models/ExcelModels/ExcelModels.dart';
import 'DeletDialog.dart';
import 'MessageUtils(SnackBar).dart';
import 'ShowDilogue(Correction and Error).dart';

class ExcelLikeTable extends StatefulWidget {
  const ExcelLikeTable({Key? key, required this.alldata}) : super(key: key);
  final List<ExcelModel> alldata;

  @override
  State<ExcelLikeTable> createState() => _ExcelLikeTableState();
}

class _ExcelLikeTableState extends State<ExcelLikeTable> {
  final diloguebox = ShowDilogue();
  final checkvalidation = Validation();
  final FirebaseLogic firebaseLogic = FirebaseLogic();

  late List<Map<String, String?>> maplist;
  late List<String> statusList;
  List<Map<String, String?>> uploadedRows = [];
  List<Map<String, String?>> convertDataListToMapList(
      List<ExcelModel> dataList) {
    return dataList.map((ExcelModel data) {
      return {
        'key': data.key,
        'storeID': data.storeID,
        'itemCategory': data.itemCategory,
        'itemName': data.itemName,
        'itemsMulti': data.itemsMulti,
        'itemPrice1': data.itemPrice1,
        'itemPrice2': data.itemPrice2,
        'itemPrice3': data.itemPrice3,
        'itemPrice4': data.itemPrice4,
        'itemSize1': data.itemSize1,
        'itemSize2': data.itemSize2,
        'itemSize3': data.itemSize3,
        'itemSize4': data.itemSize4,
        'itemDescription': data.itemDescription,
        'itemType': data.itemType,
        'itemTypeImage': data.itemTypeImage,
        'ifAddOns': data.ifAddOns,
        'ifExtra': data.ifExtra,
        'itemDiscountPercent': data.itemDiscountPercent,
        'itemImage': data.itemImage,
        'itemIsAvailable': data.itemIsAvailable,
        'itemIsBestSeller': data.itemIsBestSeller,
        'itemIsNewlyLaunched': data.itemIsNewlyLaunched,
        'itemIsRecommended': data.itemIsRecommended,
        'itemRating': data.itemRating,
        'availableItem1': data.availableItem1,
        'availableItem2': data.availableItem2,
        'availableItem3': data.availableItem3,
        'availableItem4': data.availableItem4,
      };
    }).toList();
  }

  @override
  void initState() {
    statusList =
        List.generate(widget.alldata.length, (index) => 'Not Uploaded');
    maplist = convertDataListToMapList(widget.alldata);

    // Initialize uploadedRows based on the initial statusList
    for (int i = 0; i < statusList.length; i++) {
      if (statusList[i] == 'Uploaded') {
        uploadedRows.add(maplist[i]);
      }
    }

    super.initState();
    //print("this is Map talking about $maplist");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Excel-Like Table'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              DataTable(
                showCheckboxColumn: true,
                columns: _buildColumns(),
                rows: _buildRows(context),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Row(
            children: [
              Tooltip(
                message: "Upload Data",
                child: FloatingActionButton(
                  heroTag:
                      'uploadButton', // Unique tag for this FloatingActionButton
                  onPressed: () {
                    MessageUtils.showSnackBar(context, 'Data Uploading...');

                    List<Map<String, String?>> notUploadedRows = [];

                    maplist.asMap().entries.forEach((entry) {
                      if (statusList[entry.key] == 'Not Uploaded') {
                        notUploadedRows.add(entry.value);
                      }
                    });

                    firebaseLogic
                        .uploadDataToFirebase(notUploadedRows)
                        .then((result) {
                      // Update status after uploading
                      for (int i = 0; i < result.length; i++) {
                        if (result[i]) {
                          setState(() {
                            statusList[i] = 'Uploaded';
                            uploadedRows.add(maplist[i]);
                          });
                        }
                      }
                    });
                  },
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.upload_file)],
                  ),
                ),
              ),
              SizedBox(width: 10),
              Tooltip(
                message: "Save Excel File",
                child: FloatingActionButton(
                  heroTag: 'saveButton',
                  onPressed: () {
                    ExcelHandler.saveDataToExcel();
                  },
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.save)],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return [
      DataColumn(
        label: Text(
          'Delete ',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.colorsPallet[0]),
        ),
      ),
      DataColumn(
        label: Text(
          'Status',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.colorsPallet[0]),
        ),
      ),
      DataColumn(
        label: Text(
          'S.No',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.colorsPallet[0]),
        ),
      ),
      DataColumn(
        label: Text(
          'Key',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.colorsPallet[0]),
        ),
      ),
      DataColumn(
        label: Text(
          'Store ID',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.colorsPallet[0]),
        ),
      ),
      DataColumn(
        label: Text(
          'Item Category',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.colorsPallet[0]),
        ),
      ),
      DataColumn(
        label: Text(
          'Item Name',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.colorsPallet[0]),
        ),
      ),
      DataColumn(
        label: Text(
          'Items Multi',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.colorsPallet[0]),
        ),
      ),
      DataColumn(
        label: Text('Item Price 1',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.colorsPallet[0])),
      ),
      DataColumn(
        label: Text('Item Price 2',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.colorsPallet[0])),
      ),
      DataColumn(
        label: Text('Item Price 3',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.colorsPallet[0])),
      ),
      DataColumn(
        label: Text('Item Price 4',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.colorsPallet[0])),
      ),
      DataColumn(
        label: Text('Item Size 1',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.colorsPallet[0])),
      ),
      DataColumn(
        label: Text('Item Size 2',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.colorsPallet[0])),
      ),
      DataColumn(
        label: Text('Item Size 3',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.colorsPallet[0])),
      ),
      DataColumn(
        label: Text(
          'Item Size 4',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.colorsPallet[0]),
        ),
      ),
      DataColumn(
        label: Text(
          'Item Description',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.colorsPallet[0]),
        ),
      ),
      DataColumn(
        label: Text(
          'Item Type',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.colorsPallet[0]),
        ),
      ),
      DataColumn(
        label: Text(
          'Item Type Image',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.colorsPallet[0]),
        ),
      ),
      DataColumn(
        label: Text(
          'If Add-Ons',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.colorsPallet[0]),
        ),
      ),
      DataColumn(
        label: Text(
          'If Extra',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.colorsPallet[0]),
        ),
      ),
      DataColumn(
        label: Text(
          'Item Discount Percent',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.colorsPallet[0]),
        ),
      ),
      DataColumn(
        label: Text(
          'Item Image',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.colorsPallet[0]),
        ),
      ),
      DataColumn(
        label: Text(
          'Item Is Available',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.colorsPallet[0],
          ),
        ),
      ),
      DataColumn(
        label: Text(
          'Item Is Best Seller',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.colorsPallet[0],
          ),
        ),
      ),
      DataColumn(
        label: Text(
          'Item Is Newly Launched',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.colorsPallet[0],
          ),
        ),
      ),
      DataColumn(
        label: Text(
          'Item Is Recommended',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.colorsPallet[0],
          ),
        ),
      ),
      DataColumn(
        label: Text(
          'Item Rating',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.colorsPallet[0],
          ),
        ),
      ),
      DataColumn(
        label: Text(
          'Available Item 1',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.colorsPallet[0],
          ),
        ),
      ),
      DataColumn(
        label: Text(
          'Available Item 2',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.colorsPallet[0],
          ),
        ),
      ),
      DataColumn(
        label: Text(
          'Available Item 3',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.colorsPallet[0],
          ),
        ),
      ),
      DataColumn(
        label: Text(
          'Available Item 4',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.colorsPallet[0],
          ),
        ),
      ),
    ];
  }

  List<DataRow> _buildRows(BuildContext context) {
    List<DataRow> notUploadedRows = [];

    maplist.asMap().entries.forEach((entry) {
      int serialNumber = entry.key + 1;
      Map<String, dynamic> data = entry.value;

      notUploadedRows.add(DataRow(
        cells: [
          DataCell(IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              ConfirmDeletionDialog.show(
                context,
                serialNumber,
                (int entryKey) {
                  setState(() {
                    maplist.removeAt(entryKey - 1);
                  });
                },
              );
            },
          )),
          DataCell(
            Text(
              statusList[entry.key],
              style: TextStyle(
                color: statusList[entry.key] == 'Not Uploaded'
                    ? Colors.red
                    : Colors.green,
              ),
            ),
          ),
          DataCell(Text('$serialNumber')),
          DataCell(Text(data['key'] ?? 'No Info')),
          DataCell(Text(data['storeID'] ?? 'No Info')),
          DataCell(
            InkWell(
              child: Text(
                data['itemCategory'] ?? '',
                style: TextStyle(
                  color: (data['itemCategory'] !=
                          data['itemCategory'].toString().toTitleCase())
                      ? Colors.red
                      : Colors.black,
                ),
              ),
              onTap: () {
                diloguebox.showDiologueBox(
                    "Enter Valid ItemCategory Value", context, entry.key,
                    (correction) {
                  if (checkvalidation.isItemCategoryValid(correction)) {
                    setState(() {
                      maplist[entry.key]['itemCategory'] = correction;
                    });
                  } else {
                    MessageUtils.showSnackBar(
                      context,
                      'Invalid itemCategory! itemCategory Must be in ProperCase First Letter Should Be Capital, Item Type',
                    );
                  }
                });
              },
            ),
          ),
          DataCell(
            InkWell(
              child: Text(
                data['itemName'],
                style: TextStyle(
                  color: (data['itemName'] !=
                          data['itemName'].toString().toTitleCase())
                      ? Colors.red
                      : Colors.black,
                ),
              ),
              onTap: () {
                diloguebox.showDiologueBox(
                    "Enter Updated itemName ", context, entry.key,
                    (correction) {
                  if (checkvalidation.isItemNameValid(correction)) {
                    setState(() {
                      maplist[entry.key]['itemName'] = correction;
                    });
                  } else {
                    MessageUtils.showSnackBar(context,
                        'Please Enter valid ItemName , ItemName should be in ProperCase');
                  }
                });
              },
            ),
          ),
          DataCell(GestureDetector(
            onTap: () {
              if (data['itemsMulti'] == 'Error') {
                diloguebox.showDiologueBox(
                    'itemsMulti Not have valid value', context, entry.key,
                    (correction) {
                  if (checkvalidation.isItemsMultiValid(
                      data['itemsMulti'],
                      data['itemPrice4'],
                      data['itemSize4'],
                      data['itemPrice1'],
                      data['itemPrice2'],
                      data['itemPrice3'],
                      data['itemSize1'],
                      data['itemSize2'],
                      data['itemSize3'])) {
                    setState(() {
                      maplist[entry.key]['itemsMulti'] = correction.toString();
                    });
                  } else {
                    MessageUtils.showSnackBar(
                      context,
                      'Invalid itemMulti! value or there child',
                    );
                  }
                });
              }
            },
            child: Text(
              data['itemsMulti'],
              style: TextStyle(
                color:
                    (data['itemsMulti'] == 'Error') ? Colors.red : Colors.black,
              ),
            ),
          )),
          DataCell(Text(data['itemPrice1'] ?? 'No Info')),
          DataCell(Text(data['itemPrice2'] ?? 'No Info')),
          DataCell(Text(data['itemPrice3'] ?? 'No Info')),
          DataCell(Text(data['itemPrice4'] ?? 'No Info')),
          DataCell(Text(data['itemSize1'] ?? 'No Info')),
          DataCell(Text(data['itemSize2'] ?? 'No Info')),
          DataCell(Text(data['itemSize3'] ?? 'No Info')),
          DataCell(Text(data['itemSize4'] ?? 'No Info')),
          DataCell(Text(data['itemDescription'] ?? 'No Info')),
          DataCell(InkWell(
            child: Text(
              data['itemType'],
              style: TextStyle(
                color: (data['itemType'] == 'Veg' ||
                        data['itemType'] == 'Egg' ||
                        data['itemType'] == 'NonVeg')
                    ? Colors.black
                    : Colors.red,
              ),
            ),
            onTap: () {
              diloguebox.showDiologueBox(
                  "Enter Valid ItemType", context, entry.key, (correction) {
                if (checkvalidation.isItemTypeValid(correction)) {
                  setState(() {
                    maplist[entry.key]["itemType"] = correction;
                  });
                } else {
                  MessageUtils.showSnackBar(context,
                      'Enter Valid ItemType, ItemType should be of type Veg/NonVeg/Egg');
                }
              });
            },
          )),
          DataCell(Text(data['itemTypeImage'] ?? 'No Info')),
          DataCell(Text(data['ifAddOns'] ?? 'No Info')),
          DataCell(Text(data['ifExtra'] ?? 'No Info')),
          DataCell(Text(data['itemDiscountPercent'] ?? 'No Info')),
          DataCell(Text(data['itemImage'] ?? 'No Info')),
          DataCell(Text(data['itemIsAvailable'] ?? 'No Info')),
          DataCell(Text(data['itemIsBestSeller'] ?? 'No Info')),
          DataCell(Text(data['itemIsNewlyLaunched'] ?? 'No Info')),
          DataCell(Text(data['itemIsRecommended'] ?? 'No Info')),
          DataCell(Text(data['itemRating'] ?? 'No Info')),
          DataCell(Text(data['availableItem1'] ?? 'No Info')),
          DataCell(Text(data['availableItem2'] ?? 'No Info')),
          DataCell(Text(data['availableItem3'] ?? 'No Info')),
          DataCell(Text(data['availableItem4'] ?? 'No Info')),
        ],
      ));
    });

    return notUploadedRows;
  }

  void _onDeleteRow(int index) {
    setState(() {
      maplist.removeAt(index);
    });
  }
}
