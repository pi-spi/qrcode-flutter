/// SDK PI-SPI QR Code
///
/// Point d'entrée principal pour :
/// - Créer des payloads PI-SPI QR conformes EMV
/// - Décoder des payloads QR
/// - Valider des alias
/// - Calculer des checksums CRC16
library;

export '../models/pispi_qr_payload_input.dart';
export '../models/pispi_qr_payload_decode.dart';
export '../models/pispi_qr_country.dart';
export '../models/pispi_qr_type.dart';
export '../models/pispi_qr_user.dart';
export '../models/pispi_qr_exceptions.dart';

import '../models/pispi_qr_payload_decode.dart';
import '../models/pispi_qr_payload_input.dart';
import '../services/pispi_qr_payload_service.dart';

/// Classe façade principale du SDK PI-SPI QR.
///
/// Cette classe expose des méthodes statiques pour :
/// - Générer des payloads QR
/// - Décoder des payloads existants
/// - Valider des alias
/// - Calculer des checksums CRC16
///
/// Exemple :
/* 
final payload = PispiQrPayload.create(input);
final decoded = PispiQrPayload.decode(payload);
*/
class PispiQrPayload {

  /// Constructeur privé pour empêcher l'instanciation.
  PispiQrPayload._();

  /// Instance du service interne de génération et décodage.
  static final PispiQrPayloadService _service = PispiQrPayloadService();

  /// Génère un payload PI-SPI QR à partir de l'[input] fourni.
  ///
  /// Lance une [PispiQrPayloadInputException] si la validation échoue.
  static String create(PispiQrPayloadInput input) {
    return _service.encode(input);
  }

  /// Décode une chaîne de payload PI-SPI QR.
  ///
  /// Lance une [PispiQrPayloadDecodeException] si le payload
  /// est invalide ou non conforme EMV.
  static PispiQrPayloadDecodeResult decode(String payload) {
    return _service.decode(payload);
  }

  /// Calcule le checksum CRC16 d'une chaîne de caractères.
  ///
  /// Utilisé en interne pour la validation d'intégrité EMV.
  static String computeCrc16(String input) {
    return _service.computeCrc16(input);
  }

  /// Valide si l'alias fourni correspond
  /// au format UUID attendu.
  static bool isValidAlias(String alias) {
    return _service.isValidAlias(alias);
  }
}