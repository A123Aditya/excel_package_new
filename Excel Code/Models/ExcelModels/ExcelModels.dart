class ExcelModel {
  String? key;
  final String? storeID;
  final String? itemCategory;
  final String? itemName;
  final String? itemsMulti;
  final String? itemPrice1;
  final String? itemPrice2;
  final String? itemPrice3;
  final String? itemPrice4;
  final String? itemSize1;
  final String? itemSize2;
  final String? itemSize3;
  final String? itemSize4;
  final String? itemDescription;
  final String? itemType;
  final String? itemTypeImage;
  final String? ifAddOns;
  final String? ifExtra;
  final String? itemDiscountPercent;
  final String? itemImage;
  final String? itemIsAvailable;
  final String? itemIsBestSeller;
  final String? itemIsNewlyLaunched;
  final String? itemIsRecommended;
  final String? itemRating;
  final String? availableItem1;
  final String? availableItem2;
  final String? availableItem3;
  final String? availableItem4;
  

  ExcelModel({
    this.key,
    this.storeID,
    this.itemCategory,
    this.itemName,
    this.itemsMulti,
    this.itemPrice1,
    this.itemPrice2,
    this.itemPrice3,
    this.itemPrice4,
    this.itemSize1,
    this.itemSize2,
    this.itemSize3,
    this.itemSize4,
    this.itemDescription,
    this.itemType,
    this.itemTypeImage,
    this.ifAddOns,
    this.ifExtra,
    this.itemDiscountPercent,
    this.itemImage,
    this.itemIsAvailable,
    this.itemIsBestSeller,
    this.itemIsNewlyLaunched,
    this.itemIsRecommended,
    this.itemRating,
    this.availableItem1,
    this.availableItem2,
    this.availableItem3,
    this.availableItem4,
  });

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'storeID': storeID,
      'itemCategory': itemCategory,
      'itemName': itemName,
      'itemsMulti': itemsMulti,
      'itemPrice1': itemPrice1,
      'itemPrice2': itemPrice2,
      'itemPrice3': itemPrice3,
      'itemPrice4': itemPrice4,
      'itemSize1': itemSize1,
      'itemSize2': itemSize2,
      'itemSize3': itemSize3,
      'itemSize4': itemSize4,
      'itemDescription': itemDescription,
      'itemType': itemType,
      'itemTypeImage': itemTypeImage,
      'ifAddOns': ifAddOns,
      'ifExtra': ifExtra,
      'itemDiscountPercent': itemDiscountPercent,
      'itemImage': itemImage,
    };
  }

  @override
  String toString() {
    return 'allData{key: $key, storeID: $storeID, itemCategory: $itemCategory, itemName: $itemName, '
        'itemsMulti: $itemsMulti, itemPrice1: $itemPrice1, itemPrice2: $itemPrice2, '
        'itemPrice3: $itemPrice3, itemPrice4: $itemPrice4, itemSize1: $itemSize1, '
        'itemSize2: $itemSize2, itemSize3: $itemSize3, itemSize4: $itemSize4, '
        'itemDescription: $itemDescription, itemType: $itemType, '
        'itemTypeImage: $itemTypeImage, ifAddOns: $ifAddOns, ifExtra: $ifExtra, '
        'itemDiscountPercent: $itemDiscountPercent, itemImage: $itemImage}';
  }
}
