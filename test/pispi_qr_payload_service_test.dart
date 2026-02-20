import 'package:bceao_pispi_qrcode/services/pispi_qr_payload_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bceao_pispi_qrcode/pispi_qr.dart';

void main() {
  final service = PispiQrPayloadService();

  const validAlias = "550e8400-e29b-41d4-a716-446655440000";

  group("ENCODE - SUCCESS CASES", () {

    test("Individual Customer - Static - Valid", () {
      final input = PispiQrPayloadInput(
        qrType: PispiQrType.static,
        qrUser: PispiQrUser.individualCustomer,
        alias: validAlias,
        country: PispiQrCountry.sn,
        merchantChannel: "731",
      );

      final payload = service.encode(input);

      expect(payload, isNotEmpty);
      expect(payload.contains("731"), true);
    });

    test("Individual Merchant - Static - Valid", () {
      final input = PispiQrPayloadInput(
        qrType: PispiQrType.static,
        qrUser: PispiQrUser.individualMerchant,
        alias: validAlias,
        country: PispiQrCountry.sn,
        merchantChannel: "000",
        referenceLabel: "REF123",
      );

      final payload = service.encode(input);

      expect(payload, isNotEmpty);
      expect(payload.contains("000"), true);
    });

    test("Business Entity - Static - Valid", () {
      final input = PispiQrPayloadInput(
        qrType: PispiQrType.static,
        qrUser: PispiQrUser.businessEntity,
        alias: validAlias,
        country: PispiQrCountry.sn,
        merchantChannel: "000",
        referenceLabel: "FACTURE001",
      );

      final payload = service.encode(input);

      expect(payload, isNotEmpty);
    });

    test("Business Entity - Dynamic - Valid", () {
      final input = PispiQrPayloadInput(
        qrType: PispiQrType.dynamic,
        qrUser: PispiQrUser.businessEntity,
        alias: validAlias,
        country: PispiQrCountry.sn,
        merchantChannel: "400",
        referenceLabel: "INV2024",
        amount: 100,
      );

      final payload = service.encode(input);

      expect(payload.contains("54"), true);
    });
  });

  group("ENCODE - ERROR CASES", () {

    test("Personne physique dynamic interdit", () {
      final input = PispiQrPayloadInput(
        qrType: PispiQrType.dynamic,
        qrUser: PispiQrUser.individualCustomer,
        alias: validAlias,
        country: PispiQrCountry.sn,
        referenceLabel: "0000000",
        merchantChannel: "731",
      );

      expect(
        () => service.encode(input),
        throwsA(isA<PispiQrPayloadInputException>()),
      );
    });

    test("Alias invalide", () {
      final input = PispiQrPayloadInput(
        qrType: PispiQrType.static,
        qrUser: PispiQrUser.individualCustomer,
        alias: "invalid-alias",
        country: PispiQrCountry.sn,
        merchantChannel: "731",
      );

      expect(
        () => service.encode(input),
        throwsA(isA<PispiQrPayloadInputException>()),
      );
    });

    test("referenceLabel.length > 25", () {
      final input = PispiQrPayloadInput(
        qrType: PispiQrType.dynamic,
        qrUser: PispiQrUser.businessEntity,
        alias: validAlias,
        country: PispiQrCountry.sn,
        merchantChannel: "400",
        referenceLabel: "000000000000000000000000000000000000000000000000",
        amount: 10,
      );

      expect(
        () => service.encode(input),
        throwsA(isA<PispiQrPayloadInputException>()),
      );
    });

    test("Business sans referenceLabel", () {
      final input = PispiQrPayloadInput(
        qrType: PispiQrType.static,
        qrUser: PispiQrUser.businessEntity,
        alias: validAlias,
        country: PispiQrCountry.sn,
        merchantChannel: "000",
      );

      expect(
        () => service.encode(input),
        throwsA(isA<PispiQrPayloadInputException>()),
      );
    });
  });

  group("DECODE - SUCCESS CASES", () {

    test("Decode valid payload", () {
      final input = PispiQrPayloadInput(
        qrType: PispiQrType.static,
        qrUser: PispiQrUser.individualCustomer,
        alias: validAlias,
        country: PispiQrCountry.sn,
        merchantChannel: "731",
      );

      final payload = service.encode(input);
      final result = service.decode(payload);

      expect(result.countryCode, "SN");
      expect(result.merchantAccountInformation.accountProxy, validAlias);
      expect(result.additionalData.merchantChannel, "731");
    });

    test("Decode with amount", () {
      final input = PispiQrPayloadInput(
        qrType: PispiQrType.dynamic,
        qrUser: PispiQrUser.businessEntity,
        alias: validAlias,
        country: PispiQrCountry.sn,
        merchantChannel: "400",
        referenceLabel: "000000",
        amount: 150,
      );

      final payload = service.encode(input);
      final result = service.decode(payload);

      expect(result.transactionAmount, 150);
    });
  });

  group("DECODE - ERROR CASES", () {

    test("Payload vide", () {
      expect(
        () => service.decode(""),
        throwsA(isA<PispiQrPayloadDecodeException>()),
      );
    });

    test("Payload trop court", () {
      expect(
        () => service.decode("1234"),
        throwsA(isA<PispiQrPayloadDecodeException>()),
      );
    });

    test("CRC invalide", () {
      final input = PispiQrPayloadInput(
        qrType: PispiQrType.static,
        qrUser: PispiQrUser.individualCustomer,
        alias: validAlias,
        country: PispiQrCountry.sn,
        merchantChannel: "731",
      );

      final payload = service.encode(input);
      final corrupted = payload.substring(0, payload.length - 1) + "0";

      expect(
        () => service.decode(corrupted),
        throwsA(isA<PispiQrPayloadDecodeException>()),
      );
    });
  });

  group("CRC TESTS", () {

    test("CRC known input", () {
      final crc = service.computeCrc16("123456789");
      expect(crc, isNotEmpty);
      expect(crc.length, 4);
    });
  });

  group("ALIAS VALIDATION", () {

    test("Valid UUID v4", () {
      expect(service.isValidAlias(validAlias), true);
    });

    test("Invalid UUID", () {
      expect(service.isValidAlias("abc"), false);
    });
  });
}
