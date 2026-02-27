/// Exception levée lorsqu’une erreur survient
/// lors de la construction d’un payload QR PI-SPI.
///
/// Cette exception est déclenchée lorsque les paramètres
/// fournis en entrée ne respectent pas les règles
/// fonctionnelles ou de validation du standard PI-SPI.
///
/// Elle contient :
/// - un message explicite destiné au développeur,
/// - un code d’erreur optionnel pour un traitement programmatique.
class PispiQrPayloadInputException implements Exception {

  /// Message d’erreur lisible par un humain.
  ///
  /// Décrit précisément la cause de l’échec
  /// (ex : alias invalide, montant incorrect, etc.).
  final String message;

  /// Code d’erreur optionnel permettant
  /// un traitement automatisé côté application.
  final PispiQrPayloadInputError? error;

  PispiQrPayloadInputException(
    this.message, {
    this.error,
  });

  @override
  String toString() {
    if (error != null) {
      return 'PispiQrPayloadInputException: $message (code: $error)';
    }
    return 'PispiQrPayloadInputException: $message';
  }
}

/// Codes d’erreurs liés à la validation des données
/// lors de la génération d’un payload PI-SPI.
///
/// Ces erreurs concernent exclusivement
/// les données d’entrée fournies par le développeur.
enum PispiQrPayloadInputError {

  /// Alias invalide (format incorrect, UUID invalide, etc.).
  invalidAlias,

  /// Montant invalide (format incorrect ou dépassement de longueur).
  invalidAmount,

  /// Canal marchand invalide ou incohérent avec le type de QR.
  invalidMerchantChannel,

  /// Reference label invalide (format ou longueur incorrecte).
  invalidReferenceLabel,

  /// Type de QR invalide (doit être static ou dynamic).
  invalidQrType,

  /// Catégorie d’utilisateur invalide.
  invalidQrUser,
}

/// Exception levée lorsqu’une erreur survient
/// lors du décodage d’un payload QR PI-SPI.
///
/// Cette exception est déclenchée lorsque la payload
/// analysée ne respecte pas le format EMV TLV
/// ou les règles de conformité PI-SPI.
class PispiQrPayloadDecodeException implements Exception {

  /// Message d’erreur explicite décrivant
  /// la cause du problème rencontré.
  final String message;

  /// Code d’erreur spécifique lié à l’analyse
  /// ou à la validation du payload.
  final PispiQrPayloadDecodeError? error;

  PispiQrPayloadDecodeException(
    this.message, {
    this.error,
  });

  @override
  String toString() {
    if (error != null) {
      return 'PispiQrPayloadDecodeException: $message (code: $error)';
    }
    return 'PispiQrPayloadDecodeException: $message';
  }
}

/// Liste exhaustive des erreurs possibles
/// lors du décodage d’un payload QR PI-SPI.
///
/// Ces erreurs correspondent aux validations
/// des différents tags EMV présents dans la payload.
enum PispiQrPayloadDecodeError {

  /// Code de routage du service invalide.
  ///
  /// Concerne le Service Routing Code (SRC).
  invalidSRC,

  /// La structure TLV EMV de la payload est invalide.
  ///
  /// Exemple :
  /// - longueur incorrecte,
  /// - segment tronqué,
  /// - tag mal formé.
  invalidPayloadFormat,

  /// Indicateur de format invalide (Tag 00).
  ///
  /// La valeur attendue est généralement "01".
  invalidPayloadIndicator,

  /// Global Unique Identifier invalide (Tag 36.00).
  ///
  /// Doit correspondre à l’identifiant officiel PI-SPI.
  invalidGUI,

  /// Alias (proxy de compte) invalide (Tag 36.01).
  invalidAlias,

  /// Merchant Category Code invalide (Tag 52).
  invalidMerchantCategoryCode,

  /// Devise de transaction invalide (Tag 53).
  ///
  /// Pour PI-SPI UEMOA, la valeur attendue est 952 (XOF).
  invalidTransactionCurrency,

  /// Montant de transaction invalide (Tag 54).
  invalidTransactionAmount,

  /// Code pays invalide (Tag 58).
  ///
  /// Doit correspondre à un pays UEMOA supporté.
  invalidCountryCode,

  /// Nom du marchand invalide (Tag 59).
  invalidMerchantName,

  /// Ville du marchand invalide (Tag 60 ou 62 selon implémentation).
  invalidMerchantCity,

  /// Reference label invalide (Tag 62.05).
  invalidReferenceLabel,

  /// Marchant channel invalide (Tag 62.11).
  invalidMarchantChannel
}