import 'package:bceao_pispi_qrcode/services/pispi_qr_payload_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bceao_pispi_qrcode/pispi_qr.dart';

void main() {
  final service = PispiQrPayloadService();

  const validAlias = "550e8400-e29b-41d4-a716-446655440000";

  group("ENCODE - SUCCESS CASES", () {


    test("Individual Merchant - Static - Valid", () {
      final input = PispiQrPayloadInput(
        qrType: PispiQrType.static,
        alias: validAlias,
        countryCode: PispiQrCountry.sn,
        referenceLabel: "REF123",
      );

      final payload = service.encode(input);

      expect(payload, isNotEmpty);
      expect(payload.contains("000"), true);
    });

    test("Business Entity - Static - Valid", () {
      final input = PispiQrPayloadInput(
        qrType: PispiQrType.static,
        alias: validAlias,
        countryCode: PispiQrCountry.sn,
        referenceLabel: "FACTURE001",
      );

      final payload = service.encode(input);

      expect(payload, isNotEmpty);
    });

    test("Business Entity - Dynamic - Valid", () {
      final input = PispiQrPayloadInput(
        qrType: PispiQrType.dynamic,
        alias: validAlias,
        countryCode: PispiQrCountry.sn,
        referenceLabel: "INV2024",
        amount: 100,
      );

      final payload = service.encode(input);

      expect(payload.contains("54"), true);
    });
  });

  group("ENCODE - ERROR CASES", () {

    test("Amount invalid", () {
      final input = PispiQrPayloadInput(
        qrType: PispiQrType.dynamic,
        alias: validAlias,
        countryCode: PispiQrCountry.sn,
        referenceLabel: "0000000",
        amount: 0
      );

      expect(
        () => service.encode(input),
        throwsA(isA<PispiQrPayloadInputException>()),
      );
    });

    test("Alias invalide", () {
      final input = PispiQrPayloadInput(
        qrType: PispiQrType.static,
        alias: "invalid-alias",
        countryCode: PispiQrCountry.sn,
      );

      expect(
        () => service.encode(input),
        throwsA(isA<PispiQrPayloadInputException>()),
      );
    });

    test("referenceLabel.length > 25", () {
      final input = PispiQrPayloadInput(
        qrType: PispiQrType.dynamic,
        alias: validAlias,
        countryCode: PispiQrCountry.sn,
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
        qrType: PispiQrType.dynamic,
        alias: validAlias,
        countryCode: PispiQrCountry.sn,
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
        alias: validAlias,
        countryCode: PispiQrCountry.sn,
      );

      final payload = service.encode(input);
      final result = service.decode(payload);

      expect(result.countryCode, PispiQrCountry.sn);
      expect(result.alias, validAlias);

      expect(result.merchantChannel, '000');
    });

    test("Decode with amount", () {
      final input = PispiQrPayloadInput(
        qrType: PispiQrType.dynamic,
        alias: validAlias,
        countryCode: PispiQrCountry.sn,
        referenceLabel: "000000",
        amount: 150,
      );

      final payload = service.encode(input);
      final result = service.decode(payload);

      expect(result.amount, 150);

      expect(result.merchantChannel, '400');
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
        alias: validAlias,
        countryCode: PispiQrCountry.sn,
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
