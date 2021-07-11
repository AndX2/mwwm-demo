import 'package:flutter/foundation.dart';

@immutable
class DetailData {
  const DetailData(
    this.title,
    this.description,
    this.imgPath,
  );

  final String title;
  final String description;
  final String imgPath;

  DetailData copyWith({
    String? title,
    String? description,
    String? imgPath,
  }) {
    return DetailData(
      title ?? this.title,
      description ?? this.description,
      imgPath ?? this.imgPath,
    );
  }
}
