const packageName = 'bceao_pispi_qrcode';

/// Format de numéro de téléphone des 8 pays de l'union
const patternMBNO =
    r'^(?:\+225\d{10}|\+221\d{9}|\+223\d{8}|\+226\d{8}|\+229\d{10}|\+228\d{8}|\+227\d{8}|\+245\d{6})$';

const patternSHID =
    r'^[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}$';

const defaultPispiQrPayloadIndicator = '01';

const defaultPispiQrGui = 'int.bceao.pi';

const defaultPispiQrMerchantCategoryCode  = '0000';

const defaultPispiQrTransactionCurrency  = '952';

const defaultPispiQrMerchantName  = 'X';

const defaultPispiQrMerchantCity  = 'X';


const String icPiSpiQr = 'assets/images/ic_qr.png';

const String logoPiSpi = 'assets/images/logo_spi.png';

const String logoPiSpiDark = 'assets/images/logo_spi_dark.png';

const String logoPiSpiLight = 'assets/images/logo_spi_light.png';