/// Représente le résultat d’un décodage réussi
/// d’un payload QR PI-SPI conforme au standard EMV.
///
/// Ce modèle contient l’ensemble des champs EMV extraits
/// et validés depuis la payload du QR code.
///
/// Chaque propriété correspond à un tag EMV spécifique.
class PispiQrPayloadDecodeResult {

  /// Indicateur de format de la payload (Tag 00).
  ///
  /// La valeur attendue est généralement "01".
  final String payloadFormatIndicator;

  /// Informations de compte marchand (Tag 36).
  ///
  /// Contient :
  /// - le Global Unique Identifier (GUI),
  /// - le proxy de compte (alias).
  final MerchantAccountInformation merchantAccountInformation;

  /// Merchant Category Code (Tag 52).
  ///
  /// Code catégoriel du marchand selon la classification EMV.
  final String merchantCategoryCode;

  /// Devise de transaction (Tag 53).
  ///
  /// Pour l’UEMOA, la valeur attendue est :
  /// 952 (Franc CFA - XOF).
  final String transactionCurrency;

  /// Montant de la transaction (Tag 54).
  ///
  /// Peut être nul dans le cas d’un QR statique
  /// sans montant prédéfini.
  final double? transactionAmount;

  /// Code pays ISO 3166-1 alpha-2 (Tag 58).
  ///
  /// Doit correspondre à un pays UEMOA supporté.
  final String countryCode;

  /// Nom du marchand (Tag 59).
  final String merchantName;

  /// Ville du marchand (Tag 60).
  final String merchantCity;

  /// Données additionnelles (Tag 62).
  ///
  /// Inclut notamment :
  /// - le Reference Label,
  /// - le canal marchand.
  final AdditionalData additionalData;

  /// Code de contrôle CRC (Tag 63).
  ///
  /// Permet de vérifier l’intégrité de la payload.
  final String crc;

  PispiQrPayloadDecodeResult({
    required this.payloadFormatIndicator,
    required this.merchantAccountInformation,
    required this.merchantCategoryCode,
    required this.transactionCurrency,
    required this.countryCode,
    required this.merchantName,
    required this.merchantCity,
    required this.crc,
    this.transactionAmount,
    required this.additionalData,
  });

  /// Convertit le résultat décodé en représentation JSON.
  ///
  /// Les champs optionnels nuls ne sont pas inclus.
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'payloadFormatIndicator': payloadFormatIndicator,
      'merchantAccountInformation': merchantAccountInformation.toJson(),
      'merchantCategoryCode': merchantCategoryCode,
      'transactionCurrency': transactionCurrency,
      'countryCode': countryCode,
      'merchantName': merchantName,
      'merchantCity': merchantCity,
      'additionalData': additionalData.toJson(),
      'crc': crc,
    };

    if (transactionAmount != null) {
      data['transactionAmount'] = transactionAmount;
    }

    return data;
  }
}

/// Représente les informations de compte marchand (Tag 36).
///
/// Ce segment EMV encapsule des sous-tags :
/// - 36.00 : Global Unique Identifier (GUI)
/// - 36.01 : Proxy de compte (alias)
class MerchantAccountInformation {

  /// Global Unique Identifier (Tag 36.00).
  ///
  /// Identifiant unique du système PI-SPI.
  final String gui;

  /// Proxy de compte (Tag 36.01).
  ///
  /// Correspond généralement à l’alias (UUID v4).
  final String accountProxy;

  MerchantAccountInformation({
    required this.gui,
    required this.accountProxy,
  });

  /// Convertit les informations marchand en JSON.
  Map<String, dynamic> toJson() {
    return {
      'gui': gui,
      'accountProxy': accountProxy,
    };
  }
}

/// Représente le modèle des Données Additionnelles (Tag 62).
///
/// Ce segment peut contenir plusieurs sous-tags,
/// dont les plus importants pour PI-SPI :
///
/// - 62.05 : Reference Label
/// - 62.11 : Merchant Channel
class AdditionalData {

  /// Reference Label optionnel (Tag 62.05).
  ///
  /// Généralement obligatoire pour les QR dynamiques.
  final String? referenceLabel;

  /// Identifiant du canal marchand (Tag 62.11).
  ///
  /// Exemple :
  /// - "000" → QR statique
  /// - "400" → QR dynamique
  final String merchantChannel;

  AdditionalData({
    this.referenceLabel,
    required this.merchantChannel,
  });

  /// Convertit les données additionnelles en JSON.
  ///
  /// Les champs nuls ne sont pas inclus.
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'merchantChannel': merchantChannel,
    };

    if (referenceLabel != null) {
      data['referenceLabel'] = referenceLabel;
    }

    return data;
  }
}