import 'package:flutter/foundation.dart';

@immutable
class DetailData {
  DetailData(
    this.title,
    this.description,
    this.imgPath,
  );

  final String title;
  final String description;
  final String imgPath;
}
