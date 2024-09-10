import 'package:flutter/cupertino.dart';

enum LoadingStatusE { idle, busy, error }

class BaseModel with ChangeNotifier {
  LoadingStatusE loadingStatus = LoadingStatusE.idle;

  BaseModel();
}
