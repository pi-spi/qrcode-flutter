
import '../models/pispi_qr_const.dart';
import '../models/pispi_qr_country.dart';
import '../models/pispi_qr_exceptions.dart';
import '../models/pispi_qr_payload_decode.dart';
import '../models/pispi_qr_payload_input.dart';
import '../models/pispi_qr_type.dart';

class PispiQrPayloadService {

  String encode(PispiQrPayloadInput input) {

    if(!isValidAlias(input.alias)){
      throw PispiQrPayloadInputException("L'alias doit être un UUID v4 valide");
    }
  
    final segments = <String>[];

    segments.add(_formatDataObject('00', defaultPispiQrPayloadIndicator)); // Payload Format Indicator 	

    final merchantAccount = // Merchant Account information
    [
      _formatDataObject('00', defaultPispiQrGui), //GUI
      _formatDataObject('01', input.alias), // Account proxy
    ];
    segments.add(_formatDataObject('36', merchantAccount.join()));

    segments.add(_formatDataObject('52', defaultPispiQrMerchantCategoryCode)); // Merchant Category Code 

    segments.add(_formatDataObject('53', defaultPispiQrTransactionCurrency)); // Transaction Currency

    if (input.amount != null) {
      if(input.amount! <= 0){
        throw PispiQrPayloadInputException("Le montant doit être superieur à 0");
      }
      segments.add(_formatDataObject('54', input.amount!.toInt().toString())); //Transaction amount
    }

    segments.add(_formatDataObject('58', input.countryCode.code)); // Country Code
    segments.add(_formatDataObject('59', defaultPispiQrMerchantName)); // Marchant Name
    segments.add(_formatDataObject('60', defaultPispiQrMerchantCity)); // Marchant city

    // Additional Data Field Template
    var additionalData = [];
    if(input.qrType == PispiQrType.dynamic){
      if(input.referenceLabel == null || input.referenceLabel!.isEmpty){
        throw PispiQrPayloadInputException("La valeur du [referenceLabel] est obligatoire pour le qrcode dynamique");
      }
      if(!_isValidReferenceLabel(input.referenceLabel!)){
        throw PispiQrPayloadInputException("La valeur du [referenceLabel] ne doit pas dépasser 25 caractères");
      }
      additionalData.add(_formatDataObject('05', input.referenceLabel!));
    }
    else {
      if(input.referenceLabel != null && input.referenceLabel!.isNotEmpty){
        if(!_isValidReferenceLabel(input.referenceLabel!)){
          throw PispiQrPayloadInputException("La valeur du [referenceLabel] ne doit pas dépasser 25 caractères");
        }
        additionalData.add(_formatDataObject('05', input.referenceLabel!));
      }
    }

    additionalData.add(_formatDataObject('11', input.qrType == PispiQrType.static ? '000' : '400'));

    if (additionalData.isNotEmpty) {
      segments.add(_formatDataObject('62', additionalData.join()));
    }

    final payloadWithoutCrc = segments.join();

    final crcInput = '${payloadWithoutCrc}6304'; // Ajouter le tag CRC avec longueur 04 AVANT calcul
    final crc = computeCrc16(crcInput);

    return '$payloadWithoutCrc${_formatDataObject('63', crc)}';
  }

  PispiQrPayloadDecodeResult decode(String payload) {
    if (payload.isEmpty) {
      throw PispiQrPayloadDecodeException("La payload doit être une chaîne non vide", error: PispiQrPayloadDecodeError.invalidPayloadFormat);
    }

    if (payload.length < 12) {
      throw PispiQrPayloadDecodeException("Payload trop courte pour contenir des segments EMV", error: PispiQrPayloadDecodeError.invalidPayloadFormat);
    }

    final Map<String, String> root = {};
    int index = 0;

    while (index < payload.length - 4) {

      if (index + 4 > payload.length - 4) {
        throw PispiQrPayloadDecodeException(
          "Segment TLV incomplet",
          error: PispiQrPayloadDecodeError.invalidPayloadFormat,
        );
      }

      final id = payload.substring(index, index + 2);
      final lengthStr = payload.substring(index + 2, index + 4);

      if (!RegExp(r'^\d{2}$').hasMatch(lengthStr)) {
        throw PispiQrPayloadDecodeException(
          "Longueur TLV invalide",
          error: PispiQrPayloadDecodeError.invalidPayloadFormat,
        );
      }

      final length = int.parse(lengthStr);

      if (index + 4 + length > payload.length) {
        throw PispiQrPayloadDecodeException(
          "Valeur TLV dépasse la taille du payload",
          error: PispiQrPayloadDecodeError.invalidPayloadFormat,
        );
      }

      final value = payload.substring(index + 4, index + 4 + length);

      root[id] = value;
      index += 4 + length;
    }

    final extractedCrc = payload.substring(payload.length - 4);
    final payloadWithoutCrc = payload.substring(0, payload.length - 4);
    final computedCrc = computeCrc16(payloadWithoutCrc);

    if (extractedCrc != computedCrc) {
      throw PispiQrPayloadDecodeException("CRC invalide", error: PispiQrPayloadDecodeError.invalidSRC);
    }

    final payloadFormatIndicator = root['00'];
    final merchantCategoryCode = root['52'];
    final transactionCurrency = root['53'];
    final transactionAmount = root['54'];
    final countryCode = root['58'];
    final merchantName = root['59'];
    final merchantCity = root['60'];
    final merchantAccountInformation = root['36'];
    final merchantAccountInformationRoot = _parseNested(merchantAccountInformation);
    final gui = merchantAccountInformationRoot['00'];
    final accountProxy = merchantAccountInformationRoot['01'];
    final additionalData = root['62'];
    final additionalDataRoot = additionalData != null ? _parseNested(additionalData) : null;
    final referenceLabel = additionalDataRoot != null ? additionalDataRoot['05'] : null;
    final merchantChannel = additionalDataRoot != null ? additionalDataRoot['11'] : null;

    if(payloadFormatIndicator == null || merchantCategoryCode == null ||
      transactionCurrency == null ||
      countryCode == null || merchantName == null || merchantCity == null ||
      merchantAccountInformation == null || gui == null || accountProxy == null ||
      additionalData == null || merchantChannel == null){
      throw PispiQrPayloadDecodeException("Payload invalide", error: PispiQrPayloadDecodeError.invalidPayloadFormat);
    }

    if(payloadFormatIndicator != defaultPispiQrPayloadIndicator){
      throw PispiQrPayloadDecodeException("Payload invalide Indicator", error: PispiQrPayloadDecodeError.invalidPayloadIndicator);
    }

    if(gui != defaultPispiQrGui){
      throw PispiQrPayloadDecodeException("GUI invalide", error: PispiQrPayloadDecodeError.invalidGUI);
    }

    if (!isValidAlias(accountProxy)) {
      throw PispiQrPayloadDecodeException("Proxy invalide", error: PispiQrPayloadDecodeError.invalidAlias);
    }

    if(merchantCategoryCode != defaultPispiQrMerchantCategoryCode){
      throw PispiQrPayloadDecodeException("Merchant Category Code invalide", error: PispiQrPayloadDecodeError.invalidMerchantCategoryCode);
    }

    if (transactionCurrency != defaultPispiQrTransactionCurrency) {
      throw PispiQrPayloadDecodeException("Transaction Currency invalide", error: PispiQrPayloadDecodeError.invalidTransactionCurrency);
    }

    if (transactionAmount != null && !_isValidAmount(transactionAmount)) {
      throw PispiQrPayloadDecodeException("Transaction Amount invalide", error: PispiQrPayloadDecodeError.invalidTransactionAmount);
    }

    if(!PispiQrCountry.isValid(countryCode)) {
      throw PispiQrPayloadDecodeException("Country Code invalide", error: PispiQrPayloadDecodeError.invalidCountryCode);
    }

    if(merchantName != defaultPispiQrMerchantName){
      throw PispiQrPayloadDecodeException("Merchant Name invalide", error: PispiQrPayloadDecodeError.invalidMerchantName);
    }

    if(merchantCity != defaultPispiQrMerchantCity){
      throw PispiQrPayloadDecodeException("Merchant City invalide", error: PispiQrPayloadDecodeError.invalidMerchantCity);
    }

    if (_isValidMarchantChannel(merchantChannel)) {
      throw PispiQrPayloadDecodeException("Marchant Channel invalide", error: PispiQrPayloadDecodeError.invalidMarchantChannel);
    }

    if (referenceLabel != null && !_isValidReferenceLabel(referenceLabel)) {
      throw PispiQrPayloadDecodeException("Reference Label invalide", error: PispiQrPayloadDecodeError.invalidReferenceLabel);
    }

    return PispiQrPayloadDecodeResult(
      qrType: merchantChannel == '400' ? PispiQrType.dynamic : PispiQrType.static,
      alias: accountProxy,
      merchantChannel: merchantChannel,
      amount: transactionAmount != null ? double.parse(transactionAmount) : null,
      countryCode: PispiQrCountry.get(countryCode),
      referenceLabel: referenceLabel,
    );
  }

  String computeCrc16(String input) {
    int crc = 0xffff;
    const int polynomial = 0x1021;

    for (int i = 0; i < input.length; i++) {
      crc ^= input.codeUnitAt(i) << 8;

      for (int j = 0; j < 8; j++) {
        if ((crc & 0x8000) != 0) {
          crc = (crc << 1) ^ polynomial;
        } else {
          crc <<= 1;
        }
        crc &= 0xffff;
      }
    }

    return crc.toRadixString(16).toUpperCase().padLeft(4, '0');
  }

  String _formatDataObject(String id, String value) {
    final length = value.length.toString().padLeft(2, '0');
    return '$id$length$value';
  }

  Map<String, String> _parseNested(String? value) {
    if (value == null) return {};

    final Map<String, String> result = {};
    int index = 0;

    while (index < value.length) {

      if (index + 4 > value.length) {
        throw PispiQrPayloadDecodeException(
          "Segment TLV imbriqué incomplet",
          error: PispiQrPayloadDecodeError.invalidPayloadFormat,
        );
      }

      final id = value.substring(index, index + 2);
      final lengthStr = value.substring(index + 2, index + 4);

      if (!RegExp(r'^\d{2}$').hasMatch(lengthStr)) {
        throw PispiQrPayloadDecodeException(
          "Longueur TLV imbriquée invalide",
          error: PispiQrPayloadDecodeError.invalidPayloadFormat,
        );
      }

      final length = int.parse(lengthStr);

      if (index + 4 + length > value.length) {
        throw PispiQrPayloadDecodeException(
          "Valeur TLV imbriquée dépasse la taille",
          error: PispiQrPayloadDecodeError.invalidPayloadFormat,
        );
      }

      final val = value.substring(index + 4, index + 4 + length);

      result[id] = val;
      index += 4 + length;
    }

    return result;
  }

  bool isValidAlias(String alias){
    return alias.isNotEmpty && RegExp(patternSHID).hasMatch(alias);
  }

  bool _isValidAmount(String amount) {
    final regex = RegExp(r'^\d{1,10}(\.\d{1,2})?$');
    return regex.hasMatch(amount);
  }

  bool _isValidReferenceLabel(String referenceLabel) {
    return referenceLabel.isNotEmpty && referenceLabel.length < 25;
  }

  bool _isValidMarchantChannel(String merchantChannel) {
    return ['000','400','731'].contains(merchantChannel);
  }
}