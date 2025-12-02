import 'package:fluttertoast/fluttertoast.dart';
class ShowMessage {
  static toast(
      String msg,
      ) {
    Fluttertoast.showToast(msg: msg);
  }
}
