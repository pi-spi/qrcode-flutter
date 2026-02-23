
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:bceao_pispi_qrcode/pispi_qr.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}


/// --------------------- HOME Page
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Color(0xFFC08507),
        title: const Text("PI-SPI QR Plugin demo", style: TextStyle(color: Colors.white, fontSize: 20, fontStyle: FontStyle.italic, fontWeight: FontWeight.w800),),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Image.asset(
              'assets/logo_spi.png',
              height: 32,
            ),
          ),
        ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 2,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Generer
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PispiQrGenerationPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFC08507),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text(
                          "Qr Generator",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Decoder
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PispiQrDecoderPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFC08507),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text(
                          "Qr Decode",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      )
    );
  }
}


/// --------------------- Qr payload encode & Qr image generator Page
class PispiQrGenerationPage extends StatefulWidget {
  const PispiQrGenerationPage({super.key});

  @override
  State<PispiQrGenerationPage> createState() => _PispiQrGenerationPageState();
}

class _PispiQrGenerationPageState extends State<PispiQrGenerationPage> {
  final channels = ['731','000','400'];
  final defaultAlias = '111c3e1b-4312-49ec-b75e-4c8c74c10fd7';
  final _formKey = GlobalKey<FormState>();

  late TextEditingController aliasController;
  late TextEditingController amountController;
  late TextEditingController referenceController;

  late PispiQrUser qrUser;
  late PispiQrType qrType;
  late PispiQrCountry country;
  late String channel;

  String? payload;
  String? error;

  @override
  void initState() {
    super.initState();
    qrUser = PispiQrUser.individualCustomer;
    qrType = PispiQrType.static;
    country = PispiQrCountry.ci;
    channel = channels.first;
    aliasController = TextEditingController(text: defaultAlias);
    amountController = TextEditingController();
    referenceController = TextEditingController();
  }

  void reset(){
    setState(() {
      payload = null;
      error = null;
      qrUser = PispiQrUser.individualCustomer;
      qrType = PispiQrType.static;
      country = PispiQrCountry.ci;
      channel = channels.first;
      amountController.clear();
      referenceController.clear();
      aliasController.text = defaultAlias;
    });
  }

  void generateQr() async{
    if (!_formKey.currentState!.validate()) return;

    try {
      final input = PispiQrPayloadInput(
        qrType: qrType,
        qrUser: qrUser,
        alias: aliasController.text.trim(),
        country: country,
        amount: amountController.text.isEmpty
            ? null
            : double.tryParse(amountController.text),
        merchantChannel: channel,
        referenceLabel: referenceController.text.isEmpty
            ? null
            : referenceController.text.trim(),
      );

      final resultPayload = PispiQrPayload.create(input);

      setState(() {
        payload = resultPayload;
        error = null;
      });
    } on PispiQrPayloadInputException catch (e) {
      setState(() {
        error = e.toString();
        payload = null;
      });
    }
  }

  InputDecoration inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: Color(0xFFC08507),
        title: const Text("PI-SPI QR Generator", style: TextStyle(color: Colors.white, fontSize: 20, fontStyle: FontStyle.italic, fontWeight: FontWeight.w800),),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Image.asset(
              'assets/logo_spi.png',
              height: 32,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10
        ),
        child: Column(
          children: [

            /// ERROR
            if (error != null)...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(height: 20),
            ],

            /// QR CODE
            if (payload != null) ...[
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: PispiQrImage(
                    payload: payload!,
                    qrImageOptions: QrImageOptions(
                      qrSize: 200,
                      margin: 10,
                      icon: QrImageOptionsIcon(
                        size: 40
                      ),
                      // eye: QrImageOptionsEye(
                      //   shape: QrEyeShape.circle,
                      //   //color: Colors.amber
                      // ),
                      // data: QrImageOptionsData(
                      //   shape: QrDataShape.circle
                      // ),
                      // label: QrImageOptionsLabel(text: "SEINI SALIO"),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Formulaire
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      /// Dropdown QR User
                      DropdownButtonFormField<PispiQrUser>(
                        initialValue: qrUser,
                        decoration: inputStyle("QR User"),
                        items: PispiQrUser.values
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(_qrUserName(e),style: TextStyle(fontSize: 14),),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => qrUser = v!),
                      ),
                      const SizedBox(height: 15),

                      /// Dropdown QR Type
                      DropdownButtonFormField<PispiQrType>(
                        initialValue: qrType,
                        decoration: inputStyle("QR Type"),
                        items: PispiQrType.values
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(_qrTypeName(e),style: TextStyle(fontSize: 14),),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => qrType = v!),
                      ),
                      const SizedBox(height: 15),

                      /// Country
                      DropdownButtonFormField<PispiQrCountry>(
                        initialValue: country,
                        decoration: inputStyle("Country"),
                        items: PispiQrCountry.values
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text('${e.code} - ${_qrPaysName(e)}',style: TextStyle(fontSize: 14),),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => country = v!),
                      ),
                      const SizedBox(height: 15),

                      /// Alias
                      TextFormField(
                        controller: aliasController,
                        decoration: inputStyle("Alias (UUID v4)"),
                        validator: (v) =>
                            v == null || v.isEmpty ? "Alias obligatoire" : null,
                      ),
                      const SizedBox(height: 15),

                      /// Merchant Channel
                      DropdownButtonFormField<String>(
                        initialValue: channel,
                        decoration: inputStyle("Merchant Channel"),
                        items: channels
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e, style: TextStyle(fontSize: 14),),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => channel = v!),
                      ),
                      const SizedBox(height: 15),

                      /// Amount
                      TextFormField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: inputStyle("Montant (optionnel)"),
                      ),
                      const SizedBox(height: 15),

                      /// Reference
                      TextFormField(
                        controller: referenceController,
                        decoration: inputStyle("Reference Label (optionnel)"),
                      ),

                      const SizedBox(height: 25),

                      ElevatedButton(
                        onPressed: generateQr,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFC08507),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text(
                          "GÉNÉRER LE QR CODE",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 10),

                      ElevatedButton(
                        onPressed: reset,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFFD573),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text(
                          "REINITIALISER",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _qrTypeName(PispiQrType type){
    switch(type){
      case PispiQrType.static: return "Qr Code statique";
      case PispiQrType.dynamic: return "Qr Code dynamique";
    }
  }

  String _qrUserName(PispiQrUser user){
    switch(user){
      case PispiQrUser.individualCustomer: return "Personne physique";
      case PispiQrUser.individualMerchant: return "Personne physique commerçante";
      case PispiQrUser.businessEntity: return "Personne morale";
    }
  }

  String _qrPaysName(PispiQrCountry country){
    switch(country){
      case PispiQrCountry.bj: return "Bénin";
      case PispiQrCountry.bf: return "Burkina Faso";
      case PispiQrCountry.ci: return "Côte d'Ivoire";
      case PispiQrCountry.ml: return "Mali";
      case PispiQrCountry.ne: return "Niger";
      case PispiQrCountry.tg: return "Togo";
      case PispiQrCountry.sn: return "Sénégal";
      case PispiQrCountry.gw: return "Guinée-Bissau";
    }
  }
}

/// --------------------- Qr payload decoder Page

class PispiQrDecoderPage extends StatefulWidget {
  const PispiQrDecoderPage({super.key});

  @override
  State<PispiQrDecoderPage> createState() => _PispiQrDecoderPageState();
}

class _PispiQrDecoderPageState extends State<PispiQrDecoderPage> {

  late final MobileScannerController controller;

  PispiQrPayloadDecodeResult? result;
  String? error;

  bool _isProcessing = false;
  double _currentZoom = 1.0;

  @override
  void initState() {
    super.initState();

    controller = MobileScannerController(
      torchEnabled: false,
      formats: [BarcodeFormat.qrCode],
      facing: CameraFacing.back,
      detectionSpeed: DetectionSpeed.normal,
      autoZoom: true,
      cameraResolution: const Size(1280, 720),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void playCamera() async {
    setState(() {
      result = null;
      error = null;
      _isProcessing = false;
    });

    await controller.start();
  }

  void decodeQr(String payload) {
    if (_isProcessing) return;

    _isProcessing = true;

    try {
      final response = PispiQrPayload.decode(payload);

      setState(() {
        result = response;
        error = null;
      });
    } on PispiQrPayloadDecodeException catch (e) {
      setState(() {
        error = e.message;
        result = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double textPos = height / 5;

    final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(const Offset(0, -50)),
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.width * 0.8,
    );

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => _back(),
        ),
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: const Color(0xFFC08507),
        title: const Text(
          "PI-SPI QR Decoder",
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w800),
        ),
      ),
      body: error == null && result == null
          ? Stack(
              children: [
                GestureDetector(
                  onScaleStart: (_) => _currentZoom = 1.0,
                  onScaleUpdate: (details) async {
                    _currentZoom =
                        (_currentZoom * details.scale).clamp(1.0, 4.0);
                    await controller.setZoomScale(_currentZoom);
                  },
                  child: MobileScanner(
                    controller: controller,
                    scanWindow: scanWindow,
                    onDetect: (capture) async {
                      final barcode = capture.barcodes.first;
                      if (barcode.rawValue != null) {
                        await controller.stop();
                        decodeQr(barcode.rawValue!);
                      }
                    },
                  ),
                ),
                CustomPaint(
                  size: MediaQuery.of(context).size,
                  painter: ScanWindowPainter(
                    borderColor: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    borderStrokeCap: StrokeCap.butt,
                    borderStrokeJoin: StrokeJoin.miter,
                    borderStyle: PaintingStyle.stroke,
                    borderWidth: 2.0,
                    scanWindow: scanWindow,
                    color: const Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                ),
                Positioned(
                  bottom: textPos,
                  right: 48,
                  left: 48,
                  child: const Text(
                    "Scannez un PI-SPI QR pour le décoder",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            )
          : _resultView(),
    );
  }

  Widget _resultView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          if (error != null) ...[
            _errorCard(),
            const SizedBox(height: 20),
            _btnScan(),
          ] else if (result != null) ...[
            _resultCard(),
            const SizedBox(height: 20),
            _btnScan(),
          ]
        ],
      ),
    );
  }

  Widget _errorCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        error!,
        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _resultCard() {
    final r = result!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              blurRadius: 10, color: Colors.black12, offset: Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _field("Alias", r.merchantAccountInformation.accountProxy),
          _field("Pays", r.countryCode),
          _field("Montant", r.transactionAmount?.toString() ?? "-"),
          _field("Reference Label", r.additionalData.referenceLabel ?? '-'),
          _field("Merchant Channel", r.additionalData.merchantChannel),
          _field("CRC", r.crc),
        ],
      ),
    );
  }

  Widget _field(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.grey),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value ?? "-",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _btnScan() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: playCamera,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFC08507),
            padding:
                const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text(
            "Scanner à nouveau",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        const SizedBox(height: 10),
        
        ElevatedButton(
          onPressed: () => _back(),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFD573),
            padding:
                const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text(
            "Retour",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }

  void _back() async{
    await controller.stop();
    if (context.mounted){
      Navigator.of(context).pop();
    }
  }
}


/// This class represents a [CustomPainter] that draws a [scanWindow] rectangle.
class ScanWindowPainter extends CustomPainter {
  /// Construct a new [ScanWindowPainter] instance.
  const ScanWindowPainter({
    required this.borderColor,
    required this.borderRadius,
    required this.borderStrokeCap,
    required this.borderStrokeJoin,
    required this.borderStyle,
    required this.borderWidth,
    required this.color,
    required this.scanWindow,
  });

  /// The color for the scan window border.
  final Color borderColor;

  /// The border radius for the scan window and its border.
  final BorderRadius borderRadius;

  /// The stroke cap for the border around the scan window.
  final StrokeCap borderStrokeCap;

  /// The stroke join for the border around the scan window.
  final StrokeJoin borderStrokeJoin;

  /// The style for the border around the scan window.
  final PaintingStyle borderStyle;

  /// The width for the border around the scan window.
  final double borderWidth;

  /// The color for the scan window box.
  final Color color;

  /// The rectangle that defines the scan window.
  final Rect scanWindow;

  @override
  void paint(Canvas canvas, Size size) {
    if (scanWindow.isEmpty || scanWindow.isInfinite) {
      return;
    }

    // Define the main overlay path covering the entire screen.
    final backgroundPath = Path()..addRect(Offset.zero & size);

    // The cutout rect depends on the border radius.
    final RRect cutoutRect = borderRadius == BorderRadius.zero
        ? RRect.fromRectAndCorners(scanWindow)
        : RRect.fromRectAndCorners(
            scanWindow,
            topLeft: borderRadius.topLeft,
            topRight: borderRadius.topRight,
            bottomLeft: borderRadius.bottomLeft,
            bottomRight: borderRadius.bottomRight,
          );

    // The cutout path is always in the center.
    final Path cutoutPath = Path()..addRRect(cutoutRect);

    // Combine the two paths: overlay minus the cutout area
    final Path overlayWithCutoutPath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    final Paint overlayWithCutoutPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.srcOver; // android

    final Paint borderPaint = Paint()
      ..color = borderColor
      ..style = borderStyle
      ..strokeWidth = borderWidth
      ..strokeCap = borderStrokeCap
      ..strokeJoin = borderStrokeJoin;

    // Paint the overlay with the cutout.
    canvas.drawPath(overlayWithCutoutPath, overlayWithCutoutPaint);

    // Then, draw the border around the cutout area.
    canvas.drawRRect(cutoutRect, borderPaint);
  }

  @override
  bool shouldRepaint(ScanWindowPainter oldDelegate) {
    return oldDelegate.scanWindow != scanWindow ||
        oldDelegate.color != color ||
        oldDelegate.borderRadius != borderRadius;
  }
}