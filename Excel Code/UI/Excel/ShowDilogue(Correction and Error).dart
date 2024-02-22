import 'package:flutter/material.dart';

class ShowDilogue {
  void showDiologueBox(String ErrorMessage, BuildContext context, int index,
      Function(String) updateCallback) {
    TextEditingController correctionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: MediaQuery.of(context).size.height*0.3,
            width: MediaQuery.of(context).size.width*0.3, // Set the desired height
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text('$ErrorMessage.'),
                TextField(
                  controller: correctionController,
                  decoration: const InputDecoration(labelText: 'Correction'),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        String correction =
                            correctionController.text.toString();
                        Navigator.of(context).pop();
                        updateCallback(correction);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
