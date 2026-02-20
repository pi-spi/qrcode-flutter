/// Définit le type de QR code PI-SPI à générer.
///
/// Le type de QR détermine les règles fonctionnelles
/// applicables au payload, notamment :
/// - l’obligation ou non du montant,
/// - la nécessité d’un referenceLabel,
/// - la valeur attendue du canal marchand,
/// - la durée de validité du QR code.
///
/// Deux types sont supportés conformément aux
/// spécifications PI-SPI.
enum PispiQrType {

  /// QR code statique.
  ///
  /// Ce QR code est réutilisable pour plusieurs transactions.
  ///
  /// Caractéristiques principales :
  /// - Le montant est généralement optionnel.
  /// - Le payeur peut saisir le montant au moment du paiement.
  /// - Utilisé pour les paiements récurrents ou permanents.
  /// - Compatible avec les personnes physiques et morales
  ///   selon les règles métier définies.
  static,

  /// QR code dynamique.
  ///
  /// Ce QR code est généré pour une transaction unique.
  ///
  /// Caractéristiques principales :
  /// - Le montant est généralement prédéfini.
  /// - Un referenceLabel est requis pour assurer
  ///   l’unicité de la transaction.
  /// - Utilisé pour les paiements ponctuels,
  ///   factures ou demandes de paiement spécifiques.
  /// - Principalement destiné aux personnes morales
  ///   selon les règles de conformité PI-SPI.
  dynamic,
}