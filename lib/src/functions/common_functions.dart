import 'package:fluttertoast/fluttertoast.dart';

void showToastedMessage(String msg) async {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
  );
}
