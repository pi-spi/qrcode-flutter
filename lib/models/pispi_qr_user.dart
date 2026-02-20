/// Définit la catégorie d’utilisateur du QR code PI-SPI.
///
/// Cette valeur détermine les règles métier appliquées
/// lors de la génération du payload (canal marchand,
/// obligation ou non du champ referenceLabel,
/// type de QR autorisé, etc.).
///
/// Elle influence directement la conformité du QR
/// aux spécifications fonctionnelles PI-SPI.
enum PispiQrUser {

  /// Client particulier (personne physique).
  ///
  /// Généralement utilisé pour les paiements
  /// de type Person-to-Person (P2P).
  ///
  /// Contraintes principales :
  /// - QR statique uniquement
  /// - Canal marchand spécifique
  /// - referenceLabel non requis
  individualCustomer,

  /// Commerçant individuel (personne physique exerçant
  /// une activité commerciale).
  ///
  /// Utilisé lorsqu’un entrepreneur individuel
  /// accepte des paiements dans le cadre de son activité.
  ///
  /// Contraintes principales :
  /// - QR statique
  /// - referenceLabel optionnel
  /// - Canal marchand spécifique aux commerçants individuels
  individualMerchant,

  /// Personne morale (entreprise ou organisation enregistrée).
  ///
  /// Utilisé pour les sociétés, institutions ou
  /// entités légalement constituées.
  ///
  /// Contraintes principales :
  /// - QR statique ou dynamique autorisé
  /// - referenceLabel obligatoire
  /// - Canal marchand dépend du type de QR
  businessEntity,
}