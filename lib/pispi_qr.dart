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

// Models
export 'models/pispi_qr_contant.dart';
export 'models/pispi_qr_country.dart';
export 'models/pispi_qr_exceptions.dart';
export 'models/pispi_qr_payload_decode.dart';
export 'models/pispi_qr_payload_input.dart';
export 'models/pispi_qr_type.dart';
export 'models/pispi_qr_user.dart';

// Modules
export 'modules/pispi_qr_generator.dart';
export 'modules/pispi_qr_image.dart';
export 'modules/pispi_qr_payload.dart';