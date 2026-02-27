/// Représente les pays membres supportés par le PI-SPI.
///
/// Chaque valeur de l’énumération contient le code pays officiel
/// ISO 3166-1 alpha-2 (2 lettres) utilisé dans la génération
/// et la validation des payloads QR PI-SPI.
///
/// Exemple :
/// ```dart
/// final country = PispiQrCountry.sn;
/// print(country.code); // Résultat : SN
/// ```
enum PispiQrCountry {

  /// Bénin
  bj('BJ'),

  /// Burkina Faso
  bf('BF'),

  /// Côte d'Ivoire
  ci('CI'),

  /// Guinée-Bissau
  gw('GW'),

  /// Mali
  ml('ML'),

  /// Niger
  ne('NE'),

  /// Sénégal
  sn('SN'),

  /// Togo
  tg('TG');

  /// Code pays ISO 3166-1 alpha-2.
  ///
  /// Cette valeur est intégrée dans le payload du QR PI-SPI
  /// conformément aux spécifications régionales BCEAO.
  final String code;

  /// Crée une instance de [PispiQrCountry] avec son code ISO associé.
  const PispiQrCountry(this.code);

  /// Vérifie si le code pays fourni est supporté par le plugin PI-SPI.
  ///
  /// [code] : Code pays ISO (ex: "SN", "CI", "ML").
  ///
  /// Retourne `true` si le code existe dans l’énumération
  /// [PispiQrCountry], sinon retourne `false`.
  ///
  /// Exemple :
  /// ```dart
  /// PispiQrCountry.isValid("SN"); // true
  /// PispiQrCountry.isValid("FR"); // false
  /// ```
  static bool isValid(String code) {
    return PispiQrCountry.values
        .any((country) => country.code == code);
  }

  static PispiQrCountry get(String code) {
    return PispiQrCountry.values
        .firstWhere((country) => country.code == code);
  }
}