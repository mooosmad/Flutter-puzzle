// ignore_for_file: file_names

import 'package:equatable/equatable.dart';

class CaseImage extends Equatable {
  final int? value;
  final String? imagePath;
  const CaseImage({required this.imagePath, required this.value});
  @override
  List<Object?> get props => [value, imagePath];
}
