# 🏦 BCEAO PI-SPI QR Code Flutter SDK

Le SDK Flutter `bceao_pispi_qrcode` fournit une interface robuste, sécurisée et conforme aux standards EMV pour intégrer les QR Codes PI-SPI, permettant aux applications mobiles d'interagir avec l'écosystème PI-SPI de la BCEAO.

---

## ⚡ Fonctionnalités principales

- Génération de QR Codes **statiques** et **dynamiques**.
- Construction de payloads **conformes EMV**.
- Décodage et vérification des payloads QR.
- Calcul automatique du **CRC16** pour l'intégrité des données.
- Validation des **alias (UUID v4)** pour la sécurité des comptes.
- Gestion complète des **exceptions** avec codes d'erreur structurés.
- **Rendu configurable des QR Codes** avec logo PI-SPI intégré et style personnalisé.
- Génération de QR Codes en **SVG** pour export ou impression.

Ce SDK est conçu pour les applications financières et systèmes de paiement dans les pays de l'UEMOA.

---

## ⚙️ Intégration

### 1️⃣ Installation

Ajoutez le SDK à votre `pubspec.yaml` :

```yaml
dependencies:
  bceao_pispi_qrcode: ^1.0.1
```

Puis récupérez les dépendances :

flutter pub get
2️⃣ Importer la bibliothèque
```dart
    import 'package:bceao_pispi_qrcode/pispi_qr.dart';
```

3️⃣ Générer un payload QR
```dart
    final payload = PispiQrPayload.create(
        PispiQrPayloadInput(
            qrType: PispiQrType.dynamic,              // QR Code dynamique
            qrUser: PispiQrUser.businessEntity,       // Personne morale / entreprise
            alias: '111c3e1b-4312-49ec-b75e-4c8c74c10fd7', // Alias du compte (UUID v4)
            country: PispiQrCountry.ci,               // Code pays
            amount: 5000,                             // Montant de la transaction (optionnel)
            merchantChannel: '000',                    // Canal marchand
            referenceLabel: 'TX000000001',            // Label de référence (optionnel pour statique, obligatoire pour dynamique)
        ),
    );
```

4️⃣ Générer un QR Code en SVG
```dart
    final svgQr = await PispiQrGenerator.svg(
        payload,
        size: 200,                  // Taille du QR
        piIconSize: 40,             // Taille du logo PI-SPI
        backgroundColor: Colors.white,
        dataColor: Colors.black,
        eyeColor: Colors.black,
        margin: 10,
    );
```
// Vous pouvez ensuite l'afficher dans un widget SvgPicture

5️⃣ Décoder un payload QR
```dart
final result = PispiQrPayload.decode(payload);
print(result.toJson());
print(result.merchantAccountInformation.accountProxy);
print(result.transactionAmount);
```

6️⃣ Valider un alias
```dart
    final isValid = PispiQrPayload.isValidAlias(
        '111c3e1b-4312-49ec-b75e-4c8c74c10fd7'
    );
```
7️⃣ Afficher un QR Code dans Flutter
```dart
    PispiQrImage(
        payload: payload,
        qrImageOptions: QrImageOptions(
            piIconSize: 60,
            dataColor: Colors.black,
            eyeColor: Colors.black,
            label: QrImageOptionsLabel(
            text: "ACME Corp.",
            textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
            ),
            ),
        ),
    );
```

🛡️ Sécurité & Conformité

Payloads conformes EMV.
Validation CRC16 pour l'intégrité des données.
Validation d’alias pour correspondance correcte des comptes.
Gestion des exceptions structurées.
Seuls les pays et types d'utilisateurs supportés sont autorisés.

👤 Types d'utilisateurs QR

individualCustomer – Personne physique (non marchand)
individualMerchant – Personne physique marchande
businessEntity – Personne morale / entreprise

📄 Types de QR Code

static – QR Code fixe avec payload statique
dynamic – QR Code à usage unique par transaction

⚠️ Gestion des exceptions

Toutes les exceptions sont typées et fournissent des codes d'erreur explicites :

PispiQrPayloadInputException – Levée lors de la création d’un payload.
PispiQrPayloadDecodeException – Levée lors du décodage d’un payload.

Les codes d’erreur détaillés se trouvent dans PispiQrPayloadDecodeError.

📝 Licence

MIT License – libre d’utilisation et de modification, même dans des applications commerciales.

📞 Support

Pour toute question, problème ou contribution :

Email : support@bceao.int

GitHub : [https://github.com/pi-spi/qrcode-flutter.git]