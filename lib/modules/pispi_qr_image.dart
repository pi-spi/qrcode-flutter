import 'package:flutter/material.dart';
import '../models/pispi_qr_const.dart';
import 'paint/qr_image.dart';
import 'paint/types.dart';

/// Options de configuration pour [PispiQrImage].
class QrImageOptions {

  final QrImageOptionsIcon? icon;

  /// Taille personnalisée du QR. Si null, le QR sera responsive.
  final double? qrSize;

  /// Marge autour du QR.
  final double margin;

  /// Label optionnel affiché sous le QR.
  final QrImageOptionsLabel? label;

  /// Couleur des modules de données du QR.
  final QrImageOptionsData? data;

  /// Couleur des "yeux" du QR (finder patterns).
  final QrImageOptionsEye? eye;

  /// Crée une instance de configuration pour [PispiQrImage].
  const QrImageOptions({
    this.label,
    this.margin = 10,
    this.qrSize,
    this.icon,
    this.data,
    this.eye,
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

/// L'icône PI-SPI intégrée au centre du QR.
class QrImageOptionsIcon {

  final ImageProvider<Object>? image;

  final double size;

  /// Crée un label pour le QR code.
  const QrImageOptionsIcon({
    this.image,
    this.size = 60,
  });
}

/// Widget qui affiche un QR code PI-SPI conforme EMV à partir d’une payload.
///
/// Ce widget repose sur [QrImageView] pour le rendu du QR code et
/// permet une personnalisation complète via [QrImageOptions].
///
/// Fonctionnalités :
/// - Taille responsive (ou personnalisée via `qrSize`)
/// - Icône centrale optionnelle (logo PI-SPI par défaut)
/// - Personnalisation des modules de données (forme, couleur)
/// - Personnalisation des "yeux" du QR (finder patterns)
/// - Marge configurable (quiet zone)
/// - Label optionnel affiché sous le QR
/// - Gestion des états : loader, erreur, vide
///
/// Exemple d’utilisation :
///
/// ```dart
/// PispiQrImage(
///   payload: payload,
///   qrImageOptions: QrImageOptions(
///     qrSize: 220,
///     margin: 12,
///     icon: QrImageOptionsIcon(
///       size: 40,
///     ),
///     eye: QrImageOptionsEye(
///       color: Colors.black,
///       shape: QrEyeShape.square,
///     ),
///     data: QrImageOptionsData(
///       color: Colors.black,
///       shape: QrDataShape.circle,
///     ),
///     label: QrImageOptionsLabel(
///       text: "Nom du marchand",
///     ),
///   ),
/// )
/// ```
///
/// ⚠️ Recommandations :
/// - Éviter une icône centrale > 20% de la taille totale du QR
/// - Conserver une marge suffisante pour assurer une bonne lisibilité
/// - Toujours fournir une payload valide conforme EMV
///
/// Compatible mobile et tablette.
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

    final size = qrImageOptions.qrSize ?? defaultSize;

    return SizedBox(
      width: size,
      child: Center(
        child: qrImageOptions.label == null
          ? _buildQr(context, payload, size)
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildQr(context, payload, size),
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
      ),
    );
  }

  /// Construit le widget
  Widget _buildQr(BuildContext context, String svg, double size) {
    return QrImageView(
      data: payload,
      errorStateBuilder: (context, e) => error ?? SizedBox.shrink(),
      padding: EdgeInsets.all(qrImageOptions.margin),
      embedded: QrEmbeddedImage(
        image: qrImageOptions.icon?.image != null 
          ? qrImageOptions.icon!.image!
          : const AssetImage(icPiSpiQr, package: packageName),
        style: QrEmbeddedImageStyle(
          size: Size(
            qrImageOptions.icon?.size ?? 60, 
            qrImageOptions.icon?.size ?? 60
          ),
        ),
      ),
      eyeStyle: QrImageOptionsEye(
        color: qrImageOptions.eye?.color ?? Colors.black,
        shape: qrImageOptions.eye?.shape ?? QrEyeShape.square,
      ),
      dataModuleStyle: QrImageOptionsData(
        color: qrImageOptions.data?.color ?? Colors.black,
        shape: qrImageOptions.data?.shape ?? QrDataShape.circle,
      ),
    );
  }
}