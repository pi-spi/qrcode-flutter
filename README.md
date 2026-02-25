# BCEAO PI-SPI QR Code Flutter SDK

Le SDK Flutter `bceao_pispi_qrcode` fournit une interface robuste, sécurisée et conforme aux standards EMV pour intégrer les QR Codes PI-SPI, permettant aux applications mobiles d'interagir avec l'écosystème PI-SPI de la BCEAO.

---

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
  bceao_pispi_qrcode: ^1.0.5
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
            qrUser: PispiQrUser.businessEntity,       // Personne morale / entreprise
            alias: '111c3e1b-4312-49ec-b75e-4c8c74c10fd7', // Alias du compte (UUID v4)
            country: PispiQrCountry.ci,               // Code pays
            amount: 5000,                             // Montant de la transaction (optionnel)
            merchantChannel: '000',                    // Canal marchand
            referenceLabel: 'TX000000001',            // Label de référence (optionnel pour statique, obligatoire pour dynamique)
        ),
    );
```
### PispiQrPayloadInput
| Champ               | Type               | Valeurs possibles                                                                                                                            | Contrainte    | Description                          |
| ------------------- | ------------------ | -------------------------------------------------------------------------------------------------------------------------------------------- | ------------- | ------------------------------------ |
| **qrType**          | `PispiQrType`      | • `static`<br>• `dynamic`                                                                                                                    | ✅ Obligatoire | Type de QR Code à générer            |
| **qrUser**          | `PispiQrUser`      | • `individualCustomer` — Personne physique<br>• `individualMerchant` — Personne physique commerçante<br>• `businessEntity` — Personne morale | ✅ Obligatoire | Catégorie d’utilisateur PI-SPI       |
| **alias**           | `String` (UUID v4) | Format UUID v4                                                                                                                               | ✅ Obligatoire | Alias du compte PI-SPI               |
| **country**         | `PispiQrCountry`   | • `bj` • `bf` • `ci` • `gw`<br>• `ml` • `ne` • `sn` • `tg`                                                                                   | ✅ Obligatoire | Code pays ISO 3166-1 alpha-2         |
| **merchantChannel** | `String`           | • `731` — Personne physique<br>• `000` — Commerçant / Personne morale<br>• `400` — Personne morale                                           | ✅ Obligatoire | Code canal marchand BCEAO            |
| **amount**          | `double`           | Valeur numérique                                                                                                                             | ⚪ Optionnel   | Montant de la transaction            |
| **referenceLabel**  | `String`           | Max. 24 caractères                                                                                                                           | ⚪ Optionnel   | Référence unique de transaction (ID) |



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
| Paramètre           | Type     | Défaut  | Description                 |
| ------------------- | -------- | ------- | --------------------------- |
| **payload**         | `String` | —       | Payload EMV à encoder       |
| **size**            | `double` | `200`   | Taille totale du QR         |
| **piIconSize**      | `double` | `40`    | Taille du logo central      |
| **backgroundColor** | `Color`  | `white` | Couleur de fond             |
| **dataColor**       | `Color`  | `black` | Couleur des modules         |
| **eyeColor**        | `Color`  | `black` | Couleur des finder patterns |
| **margin**          | `double` | `10`    | Marge externe (quiet zone)  |

Vous pouvez ensuite l'afficher dans un widget SvgPicture

5️⃣ Décoder un payload QR
```dart
final result = PispiQrPayload.decode(payload);
print(result.toJson());
print(result.merchantAccountInformation.accountProxy);
print(result.transactionAmount);
```
### PispiQrPayloadDecodeResult
| Champ                          | Type                         | Tag EMV | Obligatoire | Description                                     |
| ------------------------------ | ---------------------------- | ------- | ----------- | ----------------------------------------------- |
| **payloadFormatIndicator**     | `String`                     | `00`    | ✅ Oui       | Indicateur de format (toujours `"01"`)         |
| **merchantAccountInformation** | `MerchantAccountInformation` | `36`    | ✅ Oui       | Informations du compte marchand                 |
| **merchantCategoryCode**       | `String`                     | `52`    | ✅ Oui       | Code catégoriel marchand (MCC)                  |
| **transactionCurrency**        | `String`                     | `53`    | ✅ Oui       | Devise de transaction (952 = XOF)               |
| **transactionAmount**          | `double`                     | `54`    | ⚪ Optionnel | Montant de la transaction (null si QR statique) |
| **countryCode**                | `String`                     | `58`    | ✅ Oui       | Code pays ISO 3166-1 alpha-2                    |
| **merchantName**               | `String`                     | `59`    | ✅ Oui       | Nom du marchand (toujours `"X"`)                |
| **merchantCity**               | `String`                     | `60`    | ✅ Oui       | Ville du marchand (toujours `"X"`)              |
| **additionalData**             | `AdditionalData`             | `62`    | ✅ Oui       | Données additionnelles                          |
| **crc**                        | `String`                     | `63`    | ✅ Oui       | Code CRC16 de validation                        |

#### MerchantAccountInformation
| Champ            | Type     | Sous-Tag | Obligatoire | Description                                |
| ---------------- | -------- | -------- | ----------- | ------------------------------------------ |
| **gui**          | `String` | `36.00`  | ✅ Oui       | Global Unique Identifier du système PI-SPI (toujours `"int.bceao.pi"`) |
| **accountProxy** | `String` | `36.01`  | ✅ Oui       | Alias du compte (UUID v4)                  |

#### AdditionalData
| Champ               | Type     | Sous-Tag | Obligatoire | Description                     |
| ------------------- | -------- | -------- | ----------- | ------------------------------- |
| **merchantChannel** | `String` | `62.11`  | ✅ Oui       | Canal marchand            |
| **referenceLabel**  | `String` | `62.05`  | ⚪ Optionnel | Référence unique de transaction |



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


Sécurité & Conformité

Payloads conformes EMV.
Validation CRC16 pour l'intégrité des données.
Validation d’alias pour correspondance correcte des comptes.
Gestion des exceptions structurées.
Seuls les pays et types d'utilisateurs supportés sont autorisés.

Types d'utilisateurs QR

individualCustomer – Personne physique (non marchand)
individualMerchant – Personne physique marchande
businessEntity – Personne morale / entreprise

Types de QR Code

static – QR Code fixe avec payload statique
dynamic – QR Code à usage unique par transaction

⚠️ Gestion des exceptions

Toutes les exceptions sont typées et fournissent des codes d'erreur explicites :

PispiQrPayloadInputException – Levée lors de la création d’un payload.
PispiQrPayloadDecodeException – Levée lors du décodage d’un payload.

Les codes d’erreur détaillés se trouvent dans PispiQrPayloadDecodeError.

Licence

MIT License – libre d’utilisation et de modification, même dans des applications commerciales.

Support

Pour toute question, problème ou contribution :

Email : pisfn-sandbox@bceao.int

GitHub : [https://github.com/pi-spi/qrcode-flutter.git]