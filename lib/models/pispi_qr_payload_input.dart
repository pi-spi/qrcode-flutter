import 'pispi_qr_country.dart';
import 'pispi_qr_exceptions.dart';
import 'pispi_qr_type.dart';

/// Représente les données d’entrée nécessaires
/// à la génération d’une payload QR PI-SPI conforme EMV.
///
/// Ce modèle encapsule l’ensemble des paramètres requis
/// pour construire une payload valide destinée à un QR code PI-SPI.
///
/// Exemple :
/// ```dart
/// final input = PispiQrPayloadInput(
///   qrType: PispiQrType.static,
///   qrUser: PispiQrUser.individualMerchant,
///   alias: '111c3e1b-4312-49ec-b75e-4c8c74c10fd7',
///   country: PispiQrCountry.sn,
///   amount: 2000,
///   merchantChannel: '000',
///   referenceLabel: 'TX00000001',
/// );
/// ```
class PispiQrPayloadInput {

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

  /// Crée une nouvelle instance de [PispiQrPayloadInput].
  ///
  /// Une validation automatique est exécutée lors de l’instanciation.
  ///
  /// Lève une [ArgumentError] si les données sont invalides.
  PispiQrPayloadInput({
    required this.qrType,
    required this.alias,
    required this.countryCode,
    this.amount,
    this.referenceLabel,
  });

  /// Valide l’intégrité et la cohérence des données d’entrée.
  ///
  /// Règles appliquées :
  /// - Alias non vide.
  /// - Merchant Channel non vide.
  /// - Montant strictement positif si fourni.
  /// - Reference Label obligatoire pour un QR dynamique.
  void validate() {
    if (alias.trim().isEmpty) {
      throw PispiQrPayloadInputException('Alias ne peut pas être vide.');
    }

    if (amount != null && amount! <= 0) {
      throw PispiQrPayloadInputException('Le montant doit être strictement supérieur à zéro.');
    }

    if (qrType == PispiQrType.dynamic && referenceLabel == null) {
      throw PispiQrPayloadInputException(
        'Le Reference Label est obligatoire pour un QR dynamique.',
      );
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'qrType': qrType.name,
      'alias': alias
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