import 'package:recase/recase.dart';

class Validation {
  bool isItemCategoryValid(String itemCategory) {
    if (itemCategory.titleCase == itemCategory && itemCategory.isNotEmpty) {
      return true;
    }
    return false;
  }

  bool isItemNameValid(String itemName) {
    if (itemName.titleCase == itemName && itemName.isNotEmpty) {
      return true;
    }
    return false;
  }

  bool isItemTypeValid(String itemType) {
    if (itemType == 'Veg' || itemType == 'NonVeg' || itemType == 'Egg') {
      return true;
    }
    return false;
  }

  bool isItemsMultiValid(
      String itemMulti,
      String itemPrice4,
      String itemSize4,
      String itemPrice1,
      String itemPrice2,
      String itemPrice3,
      String itemSize1,
      String itemSize2,
      String itemSize3) {
    try {
      int parsedItemMulti = int.parse(itemMulti);

      if (parsedItemMulti == 0) {
        int parsedItemPrice4 = int.parse(itemPrice4);
        if (parsedItemPrice4 > 0 && itemSize4 != "NA") {
          return true;
        }
      } else {
        int parsedItemPrice1 = int.parse(itemPrice1);
        int parsedItemPrice2 = int.parse(itemPrice2);
        int parsedItemPrice3 = int.parse(itemPrice3);
        int parsedItemPrice4 = int.parse(itemPrice4);

        if (parsedItemPrice1 > 0 &&
            parsedItemPrice2 > 0 &&
            parsedItemPrice3 > 0 &&
            itemSize1 != 'NA' &&
            itemSize2 != 'NA' &&
            itemSize3 != 'NA' &&
            parsedItemPrice4 == 0 &&
            itemSize4 == 'NA') {
          return true;
        } else if ((parsedItemPrice2 > 0 &&
            parsedItemPrice3 > 0 &&
            itemSize2 != 'NA' &&
            itemSize3 != 'NA' &&
            parsedItemPrice1 == 0 &&
            parsedItemPrice4 == 0 &&
            itemSize1 == 'NA' &&
            itemSize4 == 'NA')) {
          return true;
        }
      }
    } catch (e) {
      // Handle the case where parsing fails (e.g., non-integer input)
      return false;
    }

    return false;
  }
}
