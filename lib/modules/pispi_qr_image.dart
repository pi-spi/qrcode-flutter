/// Widget PI-SPI QR Image
///
/// Fournit un widget QR code personnalisable avec
/// un label optionnel et le logo PI-SPI intégré.
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'pispi_qr_generator.dart';

/// Options de configuration pour [PispiQrImage].
class QrImageOptions {

  /// Taille de l'icône PI-SPI intégrée au centre du QR.
  final double piIconSize;

  /// Taille personnalisée du QR. Si null, le QR sera responsive.
  final double? qrSize;

  /// Couleur de fond du QR code.
  final Color backgroundColor;

  /// Marge autour du QR.
  final double margin;

  /// Label optionnel affiché sous le QR.
  final QrImageOptionsLabel? label;

  /// Couleur des modules de données du QR.
  final Color dataColor;

  /// Couleur des "yeux" du QR (finder patterns).
  final Color eyeColor;

  /// Crée une instance de configuration pour [PispiQrImage].
  const QrImageOptions({
    this.label,
    this.backgroundColor = Colors.white,
    this.margin = 10,
    this.qrSize,
    this.piIconSize = 60,
    this.dataColor = Colors.black,
    this.eyeColor = Colors.black,
  });
}

/// Configuration d’un label affiché sous le QR.
class QrImageOptionsLabel {

  /// Texte du label.
  final String text;

  /// Style optionnel du texte.
  final TextStyle? textStyle;

  /// Crée un label pour le QR code.
  const QrImageOptionsLabel({
    required this.text,
    this.textStyle,
  });
}

/// Widget qui affiche un QR code PI-SPI à partir d’une payload.
///
/// Exemple d’utilisation :
/// ```dart
/// PispiQrImage(
///   payload: payload,
///   qrImageOptions: QrImageOptions(
///     label: QrImageOptionsLabel(text: "Nom du marchand"),
///   ),
/// )
/// ```
class PispiQrImage extends StatelessWidget {

  /// Payload QR conforme EMV.
  final String payload;

  /// Options de personnalisation du QR.
  final QrImageOptions qrImageOptions;

  /// Widget affiché pendant le chargement du QR.
  final Widget? loader;

  /// Widget affiché en cas d’erreur lors de la génération.
  final Widget? error;

  /// Widget affiché si aucune donnée n’est disponible.
  final Widget? empty;

  /// Crée un widget [PispiQrImage].
  const PispiQrImage({
    super.key,
    required this.payload,
    this.qrImageOptions = const QrImageOptions(),
    this.loader,
    this.empty,
    this.error
  });

  @override
  Widget build(BuildContext context) {
    // Largeur de l’écran
    final width = MediaQuery.of(context).size.width;

    // Détection tablette
    final bool isTablet = width >= 600;

    // Taille par défaut du QR si qrSize non fourni
    final double defaultSize =
        (width / 12) * (isTablet ? 6 : 10);

    // FutureBuilder pour générer le SVG du QR code de manière asynchrone
    return FutureBuilder<String>(
      future: PispiQrGenerator.svg(
        payload,
        size: qrImageOptions.qrSize ?? defaultSize,
        backgroundColor: qrImageOptions.backgroundColor,
        dataColor: qrImageOptions.dataColor,
        eyeColor: qrImageOptions.eyeColor,
        piIconSize: qrImageOptions.piIconSize,
        margin: qrImageOptions.margin
      ),
      builder: (context, snapshot) {
        // Affichage pendant le chargement
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loader ?? const CircularProgressIndicator();
        }

        // Affichage en cas d'erreur
        if (snapshot.hasError) {
          return error ?? Text('Erreur: ${snapshot.error}');
        }

        // Affichage si aucune donnée
        if (!snapshot.hasData) {
          return empty ?? const Text('Aucune donnée');
        }

        // Affichage du QR code avec ou sans label
        return Center(
          child: qrImageOptions.label == null
            ? _buildQr(context, snapshot.data!)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildQr(context, snapshot.data!),
                  const SizedBox(height: 8),
                  Text(
                    qrImageOptions.label!.text,
                    textAlign: TextAlign.center,
                    style: qrImageOptions.label!.textStyle ??
                        const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
        );
      },
    );
  }

  /// Construit le widget SVG du QR code.
  Widget _buildQr(BuildContext context, String svg) {
    return SvgPicture.string(svg);
  }
}