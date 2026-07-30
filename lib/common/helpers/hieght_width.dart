
import 'package:flutter/cupertino.dart';

extension HieghtWidthEx on BuildContext{

  double get exWidth => MediaQuery.of(this).size.width;
  double get exHeight => MediaQuery.of(this).size.height;
}