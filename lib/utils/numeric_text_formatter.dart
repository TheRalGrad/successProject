import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NumericTextFormatter extends TextInputFormatter {
  // Untuk membuat textFormmater custom, perlu extends class TextInputFormatter
  // kemudian mengoverride method formatEditUpdate
  // Yang berisi parameter oldValue, dan newValue
  // jika newValue kosong akan direturn value tersebut tanpa di format
  // Jika newValue dan oldValue tidak sama (atau != 0, karena compareTo() returnya int, jika valuenya 0 maka sama)
  // maka newValue kita format dengan NumberFormat dari package intl
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      final int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.end;
      final f = NumberFormat("#,###");
      final number =
          int.parse(newValue.text.replaceAll(f.symbols.GROUP_SEP, ''));
      final newString = f.format(number);
      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
            offset: newString.length - selectionIndexFromTheRight),
      );
    } else {
      return newValue;
    }
  }
}
