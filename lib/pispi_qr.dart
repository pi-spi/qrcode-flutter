/// Plugin Flutter PI-SPI QR
///
/// Fournit un SDK complet pour :
/// - Générer des payloads PI-SPI QR conformes EMV
/// - Décoder des payloads PI-SPI QR
/// - Afficher des widgets QR code personnalisables
///
/// Exemple d'utilisation :
/*
import 'package:pispi_qr/pispi_qr.dart';

final payload = PispiQrPayload.create(input);

PispiQrImage(
  payload: payload,
);

final svg = await PispiQrGenerator.svg(payload);
*/
library;

/// Exporte la façade pour la génération et le décodage des payloads QR.
export 'modules/pispi_qr_payload.dart';

/// Exporte le widget Flutter pour afficher un QR code avec options de personnalisation.
export 'modules/pispi_qr_image.dart';

/// Exporte le générateur SVG interne du QR code avec gestion du logo PI-SPI.
export 'modules/pispi_qr_generator.dart';