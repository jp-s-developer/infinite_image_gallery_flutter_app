
import 'package:flutter/cupertino.dart';

abstract class BaseVm extends ChangeNotifier {
  bool isScreenDispose = false;


  @override
  void notifyListeners(){
    if(!isScreenDispose){
      super.notifyListeners();
    }
  }

  int getCrossAxisCount(BuildContext context) {
    final width = MediaQuery
        .sizeOf(context)
        .width;

    if (width < 600) {
      return 2;
    }

    if (width < 1000) {
      return 3;
    }

    return 4;
  }
}