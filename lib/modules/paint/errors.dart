import 'package:flutter/widgets.dart';

/// An exception that is thrown when something goes wrong with the
/// [ImageProvider] for the embedded image of a QrImageView or QrPainter.
class QrEmbeddedImageException implements Exception {
  /// Create a new QrEmbeddedImageException.
  factory QrEmbeddedImageException(String message) {
    return QrEmbeddedImageException._internal(message);
  }
  QrEmbeddedImageException._internal(this.message);

  /// A message describing the exception state.
  final String message;

  @override
  String toString() => 'QrEmbeddedImageException: $message';
}
