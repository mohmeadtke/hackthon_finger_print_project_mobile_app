import 'dart:io';

class FingerPrintEntity {
  final File fingerPrintImage;
  final String name;
  final String email;

  FingerPrintEntity({
    required this.name,
    required this.email,
    required this.fingerPrintImage,
  });
}
