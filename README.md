# BCEAO PI-SPI QR Code Flutter SDK

Le SDK Flutter `bceao_pispi_qrcode` fournit une interface robuste, sécurisée et conforme aux standards EMV pour intégrer les QR Codes PI-SPI, permettant aux applications mobiles d'interagir avec l'écosystème PI-SPI de la BCEAO.

---

## Structure du projet

```
└── 📁bceao_pispi_qrcode
    └── 📁assets
        └── 📁images
            ├── ic_qr.png
            ├── logo_spi_dark.png
            ├── logo_spi_light.png
            ├── logo_spi.png
    └── 📁example
        └── 📁assets
            ├── logo_spi.png
        └── 📁lib
            ├── home.dart
            ├── main.dart
            ├── pipsi_qr_decoder_page.dart
            └── pipsi_qr_generator_page.dart
    └── 📁lib
        └── 📁models
            ├── pispi_qr_const.dart
            ├── pispi_qr_country.dart
            ├── pispi_qr_exceptions.dart
            ├── pispi_qr_payload_decode.dart
            ├── pispi_qr_payload_input.dart
            ├── pispi_qr_type.dart
            ├── pispi_qr_user.dart
        └── 📁modules
            └── 📁paint
                ├── errors.dart
                ├── paint_cache.dart
                ├── qr_image.dart
                ├── qr_painter.dart
                ├── types.dart
            ├── pispi_qr_generator.dart
            ├── pispi_qr_image.dart
            ├── pispi_qr_payload.dart
        └── 📁services
            ├── pispi_qr_payload_service.dart
        ├── pispi_qr_web.dart
        ├── pispi_qr.dart
    └── 📁test
        ├── pispi_qr_payload_service_test.dart
    ├── .gitignore
    ├── .metadata
    ├── analysis_options.yaml
    ├── bceao_pispi_qrcode.iml
    ├── CHANGELOG.md
    ├── LICENSE
    ├── pubspec.lock
    ├── pubspec.yaml
    └── README.md
```

## Fonctionnalités principales

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

## Intégration

### 1️⃣ Installation

Ajoutez le SDK à votre `pubspec.yaml` :

```yaml
dependencies:
  bceao_pispi_qrcode: ^1.0.6
```
ou
```yaml
$ flutter pub add bceao_pispi_qrcode
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
            alias: '111c3e1b-4312-49ec-b75e-4c8c74c10fd7', // Alias du compte (UUID v4)
            countryCode: PispiQrCountry.ci,               // Code pays
            amount: 5000,                             // Montant de la transaction (optionnel)
            referenceLabel: 'TX000000001',            // Label de référence (optionnel pour statique, obligatoire pour dynamique)
        ),
    );
```
### PispiQrPayloadInput
| Champ               | Type               | Valeurs possibles                                                                                                                            | Contrainte    | Description                          |
| ------------------- | ------------------ | -------------------------------------------------------------------------------------------------------------------------------------------- | ------------- | ------------------------------------ |
| **qrType**          | `PispiQrType`      | • `static`<br>• `dynamic`                                                                                                                    | ✅ Obligatoire | Type de QR Code à générer            |
| **alias**           | `String` (UUID v4) | Format UUID v4                                                                                                                               | ✅ Obligatoire | Alias du compte PI-SPI               |
| **countryCode**         | `PispiQrCountry`   | • `bj` • `bf` • `ci` • `gw`<br>• `ml` • `ne` • `sn` • `tg`                                                                                   | ✅ Obligatoire | Code pays ISO 3166-1 alpha-2         |
| **amount**          | `double`           | Valeur numérique                                                                                                                             | ⚪ Optionnel   | Montant de la transaction            |
| **referenceLabel**  | `String`           | Max. 24 caractères                                                                                                                           | ⚪ Optionnel   | Référence unique de transaction (ID) |



4️⃣ Générer un QR Code en SVG
```dart
    final svgQr = await PispiQrGenerator.svg(
        payload,
        size: 200,                  // Taille du QR
        logoSize: 40,             // Taille du logo PI-SPI
        backgroundColor: Colors.white,
        dotColor: Colors.black,
        margin: 10,
    );
```
| Paramètre           | Type     | Défaut  | Description                 |
| ------------------- | -------- | ------- | --------------------------- |
| **payload**         | `String` | —       | Payload EMV à encoder       |
| **size**            | `double` | `200`   | Taille totale du QR         |
| **logoSize**      | `double` | `40`    | Taille du logo central      |
| **backgroundColor** | `Color`  | `white` | Couleur de fond             |
| **dotColor**       | `Color`  | `black` | Couleur des modules         |
| **margin**          | `double` | `10`    | Marge externe (quiet zone)  |

Vous pouvez ensuite l'afficher dans un widget SvgPicture

⚠️ Gestion des exceptions

Toutes les exceptions sont typées et fournissent des codes d'erreur explicites :

PispiQrPayloadInputException – Levée lors de la création d’un payload.
PispiQrPayloadDecodeException – Levée lors du décodage d’un payload.

Les codes d’erreur détaillés se trouvent dans PispiQrPayloadDecodeError.

5️⃣ Décoder un payload QR
```dart
final result = PispiQrPayload.decode(payload);
print(result.toJson());
print(result.alias);
print(result.amount);
```
### PispiQrPayloadDecodeResult
| Champ                          | Type                         |
| ------------------------------ | ---------------------------- |
| **qrType**     | `PispiQrType`                     |
| **merchantChannel**               | `str`                     |
| **alias** | `String` |
| **countryCode**       | `PispiQrCountry`                     |
| **amount**        | `double?`                     |
| **referenceLabel**                | `String?`                     |

6️⃣ Valider un alias
```dart
    final isValid = PispiQrPayload.isValidAlias(
        '111c3e1b-4312-49ec-b75e-4c8c74c10fd7'
    );
```
7️⃣ Afficher un QR Code dans Flutter
```dart
    PispiQrImage(
        payload: payload, // String
        qrImageOptions: QrImageOptions(
            qrSize: 220,
            margin: 12,
            icon: QrImageOptionsIcon(
                size: 40,
            ),
            eye: QrImageOptionsEye(
                color: Colors.black,
                shape: QrEyeShape.square,
            ),
            data: QrImageOptionsData(
                color: Colors.black,
                shape: QrDataShape.circle,
            ),
            label: QrImageOptionsLabel( 
                text: "Nom ",
            ),
        ),
    );
```
### QrImageOptions
Configuration de l’icône centrale.
| Propriété  | Type                   | Défaut        | Description                  |
| ---------- | ---------------------- | ------------- | ---------------------------- |
| **qrSize** | `double?`              | Responsive    | Taille personnalisée du QR   |
| **margin** | `double`               | `10`          | Marge externe (quiet zone)   |
| **icon**   | `QrImageOptionsIcon?`  | Logo PI-SPI   | Icône centrale               |
| **data**   | `QrImageOptionsData?`  | Noir / cercle | Style des modules de données |
| **eye**    | `QrImageOptionsEye?`   | Noir / carré  | Style des finder patterns    |
| **label**  | `QrImageOptionsLabel?` | `null`        | Texte affiché sous le QR     |

#### QrImageOptionsIcon
Permet de configurer l’apparence du QR Code.
| Propriété | Type             | Défaut      | Description         |
| --------- | ---------------- | ----------- | ------------------- |
| **image** | `ImageProvider?` | Logo PI-SPI | Image personnalisée |
| **size**  | `double`         | `60`        | Taille de l’icône   |

#### QrImageOptionsLabel
Configuration du texte affiché sous le QR.
| Propriété     | Type         | Description        |
| ------------- | ------------ | ------------------ |
| **text**      | `String`     | Texte du label     |
| **textStyle** | `TextStyle?` | Style personnalisé |

#### Modules de données (data)
| Propriété | Type          | Description          |
| --------- | ------------- | -------------------- |
| **color** | `Color`       | Couleur des modules  |
| **shape** | `QrDataShape` | `circle` ou `square` |

#### Finder Patterns (eye)
| Propriété | Type         | Description                       |
| --------- | ------------ | --------------------------------- |
| **color** | `Color`      | Couleur des yeux                  |
| **shape** | `QrEyeShape` | `square` ou autre forme supportée |



Support

Pour toute question :

Email : piz@bceao.int

GitHub : [https://github.com/pi-spi/qrcode-flutter.git]