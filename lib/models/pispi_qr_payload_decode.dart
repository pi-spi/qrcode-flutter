import 'pispi_qr_country.dart';
import 'pispi_qr_type.dart';

class PispiQrPayloadDecodeResult {

  /// Définit le type de QR code à générer.
  ///
  /// - `static`  → QR réutilisable.
  /// - `dynamic` → QR à usage unique avec référence obligatoire.
  final PispiQrType qrType;

  /// Alias unique du marchand ou du compte bénéficiaire.
  ///
  /// Cet identifiant sert au routage de la transaction
  /// dans l’écosystème PI-SPI.
  ///
  /// ⚠️ Ne doit jamais être vide.
  final String alias;

  /// Pays d’émission du QR code.
  ///
  /// Doit appartenir à la liste des pays supportés
  /// par le système PI-SPI (UEMOA).
  final PispiQrCountry countryCode;

  /// Montant de la transaction.
  ///
  /// - Optionnel pour un QR statique.
  /// - Optionnel pour un QR dynamique selon implémentation.
  /// - Doit être strictement supérieur à zéro s’il est fourni.
  final double? amount;


  /// Référence de transaction (Reference Label).
  ///
  /// Utilisée pour :
  /// - la réconciliation comptable,
  /// - le suivi transactionnel,
  /// - l’identification unique d’un paiement dynamique.
  ///
  /// - Optionnelle pour QR statique.
  /// - Obligatoire pour QR dynamique.
  final String? referenceLabel;

  final String merchantChannel;

  /// Crée une nouvelle instance de [PispiQrPayloadDecodeResult].
  ///
  /// Une validation automatique est exécutée lors de l’instanciation.
  ///
  PispiQrPayloadDecodeResult({
    required this.qrType,
    required this.alias,
    required this.countryCode,
    required this.merchantChannel,
    this.amount,
    this.referenceLabel,
  });


  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'qrType': qrType.name,
      'alias': alias,
      'merchantChannel': merchantChannel
    };

    if (referenceLabel != null) {
      data['referenceLabel'] = referenceLabel;
    }
    if (amount != null) {
      data['amount'] = amount;
    }

    return data;
  }
}