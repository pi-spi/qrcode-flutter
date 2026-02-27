
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:qr/qr.dart';

import '../models/pispi_qr_const.dart';

/// PI-SPI QR SVG Generator
///
/// Générateur SVG vectoriel conforme EMVCo pour les QR Codes PI-SPI.
/// 
/// Cette classe permet :
/// - La génération d’un QR Code vectoriel (SVG)
/// - La personnalisation des couleurs (fond, modules, finder patterns)
/// - L’intégration d’un logo central encodé en Base64
/// - Une compatibilité totale Mobile / Web / Desktop
///
/// Le rendu est indépendant de `qr_flutter` et repose uniquement sur
/// le package `qr` pour la génération matricielle.
///
/// ⚠️ La méthode principale est asynchrone car elle charge
/// dynamiquement l’asset du logo via `rootBundle`.

class PispiQrGenerator {

  /// Constructeur privé empêchant l’instanciation.
  PispiQrGenerator._();

  /// Génère un QR Code au format SVG.
  ///
  /// [data] : Payload EMV à encoder.
  ///
  /// Paramètres optionnels :
  /// - [margin] : Marge externe autour du QR.
  /// - [size] : Taille totale du SVG.
  /// - [logoSize] : Taille du logo central.
  /// - [backgroundColor] : Couleur du fond.
  /// - [dotColor] : Couleur des modules de données.
  ///
  /// Retourne une `String` contenant le SVG complet.
  ///
  /// Exemple :
  /// ```dart
  /// final svg = await PispiQrGenerator.svg(payload);
  /// ```
  static Future<String> svg(
    String data, {
    double margin = 10,
    double size = 200,
    double logoSize = 40,
    Color? backgroundColor,
    Color dotColor = Colors.black,
  }) async {

    /// Création du QR Code brut conforme ISO/IEC 18004
    /// avec niveau de correction d’erreur M.
    final qrCode = QrCode.fromData(
      data: data,
      errorCorrectLevel: QrErrorCorrectLevel.L,
    );

    /// Transformation en image matricielle exploitable.
    final qrImage = QrImage(qrCode);

    /// Taille exploitable interne après retrait des marges.
    final drawableSize = size - margin * 2;

    /// Nombre total de modules du QR.
    final moduleCount = qrImage.moduleCount;

    /// Taille d’un module individuel.
    final cellSize = drawableSize / moduleCount;

    /// Rayon utilisé pour les modules circulaires.
    final dotRadius = cellSize * 0.4;

    /// Buffer servant à construire le SVG.
    final buffer = StringBuffer();

    /// Déclaration de l’en-tête SVG.
    buffer.writeln(
      '<svg xmlns="http://www.w3.org/2000/svg" width="$size" height="$size" shape-rendering="crispEdges">'
    );

    /// Application du fond si couleur supportée.
    final bgColor = _color(backgroundColor);
    if (bgColor != null) {
      buffer.writeln(
        '<rect width="$size" height="$size" fill="$bgColor"/>'
      );
    }

    /// Parcours de tous les modules du QR.
    for (var row = 0; row < moduleCount; row++) {
      for (var col = 0; col < moduleCount; col++) {

        /// Vérifie si le module est actif (noir).
        if (qrImage.isDark(row, col) == true) {

          /// Calcul position centrée.
          final x = margin + col * cellSize;
          final y = margin + row * cellSize;

          final dotColorHex = colorToHex(dotColor);

          /// Détection des finder patterns (yeux).
          if (_isFinderPattern(moduleCount, row, col)) {


            buffer.writeln(
              '<rect x="${x.toStringAsFixed(2)}" y="${y.toStringAsFixed(2)}" '
              'width="${cellSize.toStringAsFixed(2)}" height="${cellSize.toStringAsFixed(2)}" '
              'fill="$dotColorHex"/>'
            );

          } else {

            /// Modules de données rendus en cercle.
            final cx = x + cellSize / 2;
            final cy = y + cellSize / 2;

            buffer.writeln(
              '<circle cx="${cx.toStringAsFixed(2)}" cy="${cy.toStringAsFixed(2)}" '
              'r="${dotRadius.toStringAsFixed(2)}" '
              'fill="$dotColorHex"/>'
            );
          }

        }
      }
    }

    /// Intégration du logo central si activé.
    if (logoSize > 0) {

      /// Chargement de l’asset depuis le package.
      final logoBytes =
          await rootBundle.load('packages/$packageName/$icPiSpiQr');

      /// Encodage Base64 pour intégration inline.
      final logoBase64 =
          base64Encode(logoBytes.buffer.asUint8List());

      final logoDataUrl =
          'data:image/png;base64,$logoBase64';

      /// Positionnement centré.
      final x = (size - logoSize) / 2;
      final y = (size - logoSize) / 2;

      buffer.writeln(
        '<image x="$x" y="$y" '
        'width="$logoSize" height="$logoSize" '
        'href="$logoDataUrl"/>'
      );
    }

    /// Fermeture de la balise SVG.
    buffer.writeln('</svg>');

    return buffer.toString();
  }

  /// Détermine si un module appartient à un finder pattern.
  ///
  /// Les finder patterns sont les trois carrés 7x7
  /// situés :
  /// - en haut à gauche
  /// - en haut à droite
  /// - en bas à gauche
  static bool _isFinderPattern(int moduleCount, int row, int col) {

    const patternSize = 7;

    final inTopLeft = row < patternSize && col < patternSize;
    final inTopRight = row < patternSize && col >= moduleCount - patternSize;
    final inBottomLeft = row >= moduleCount - patternSize && col < patternSize;

    return inTopLeft || inTopRight || inBottomLeft;
  }

  /// Convertit une couleur Flutter en valeur SVG simple.
  ///
  /// Actuellement supporté :
  /// - blanc
  /// - noir
  ///
  /// Retourne `null` si la couleur n’est pas supportée.
  static String? _color(Color? color) {
    if(color == null) return null;

    if (color == Colors.white ||
        color == const Color(0xFFFFFFFF)) {
      return 'white';
    }

    if (color == Colors.black ||
        color == const Color(0xFF000000)) {
      return 'black';
    }

    return null;
  }

  static String colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
  }
}