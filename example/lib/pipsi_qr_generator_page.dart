

// import 'package:bceao_pispi_qrcode/pispi_qr.dart';
// import 'package:flutter/material.dart';

// class PispiQrGenerationPage extends StatefulWidget {
//   const PispiQrGenerationPage({super.key});

//   @override
//   State<PispiQrGenerationPage> createState() => _PispiQrGenerationPageState();
// }

// class _PispiQrGenerationPageState extends State<PispiQrGenerationPage> {
//   final channels = ['731','000','400'];
//   final defaultAlias = '111c3e1b-4312-49ec-b75e-4c8c74c10fd7';
//   final _formKey = GlobalKey<FormState>();

//   late TextEditingController aliasController;
//   late TextEditingController amountController;
//   late TextEditingController referenceController;

//   late PispiQrUser qrUser;
//   late PispiQrType qrType;
//   late PispiQrCountry country;
//   late String channel;

//   String? payload;
//   String? error;

//   @override
//   void initState() {
//     super.initState();
//     qrUser = PispiQrUser.individualCustomer;
//     qrType = PispiQrType.static;
//     country = PispiQrCountry.ci;
//     channel = channels.first;
//     aliasController = TextEditingController(text: defaultAlias);
//     amountController = TextEditingController();
//     referenceController = TextEditingController();
//   }

//   void reset(){
//     setState(() {
//       payload = null;
//       error = null;
//       qrUser = PispiQrUser.individualCustomer;
//       qrType = PispiQrType.static;
//       country = PispiQrCountry.ci;
//       channel = channels.first;
//       amountController.clear();
//       referenceController.clear();
//       aliasController.text = defaultAlias;
//     });
//   }

//   void generateQr() async{
//     if (!_formKey.currentState!.validate()) return;

//     try {
//       final input = PispiQrPayloadInput(
//         qrType: qrType,
//         qrUser: qrUser,
//         alias: aliasController.text.trim(),
//         country: country,
//         amount: amountController.text.isEmpty
//             ? null
//             : double.tryParse(amountController.text),
//         merchantChannel: channel,
//         referenceLabel: referenceController.text.isEmpty
//             ? null
//             : referenceController.text.trim(),
//       );

//       final resultPayload = PispiQrPayload.create(input);

//       setState(() {
//         payload = resultPayload;
//         error = null;
//       });
//     } on PispiQrPayloadInputException catch (e) {
//       setState(() {
//         error = e.toString();
//         payload = null;
//       });
//     }
//   }

//   InputDecoration inputStyle(String label) {
//     return InputDecoration(
//       labelText: label,
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         iconTheme: IconThemeData(
//           color: Colors.white
//         ),
//         backgroundColor: Color(0xFFC08507),
//         title: const Text("PI-SPI QR Generator", style: TextStyle(color: Colors.white, fontSize: 20, fontStyle: FontStyle.italic, fontWeight: FontWeight.w800),),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 12),
//             child: Image.asset(
//               'assets/logo_spi.png',
//               height: 32,
//             ),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(
//           horizontal: 10,
//           vertical: 10
//         ),
//         child: Column(
//           children: [

//             /// ERROR
//             if (error != null)...[
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.red[100],
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   error!,
//                   style: const TextStyle(color: Colors.red),
//                 ),
//               ),
//               const SizedBox(height: 20),
//             ],

//             /// QR CODE
//             if (payload != null) ...[
//               Card(
//                 elevation: 2,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20)),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                   child: PispiQrImage(
//                     payload: payload!,
//                     qrImageOptions: QrImageOptions(
//                       qrSize: 200,
//                       margin: 10,
//                       icon: QrImageOptionsIcon(
//                         size: 40
//                       ),
//                       // eye: QrImageOptionsEye(
//                       //   shape: QrEyeShape.circle,
//                       //   //color: Colors.amber
//                       // ),
//                       // data: QrImageOptionsData(
//                       //   shape: QrDataShape.circle
//                       // ),
//                       // label: QrImageOptionsLabel(text: "SEINI SALIO"),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//             ],

//             // Formulaire
//             Card(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20)),
//               elevation: 2,
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       /// Dropdown QR User
//                       DropdownButtonFormField<PispiQrUser>(
//                         initialValue: qrUser,
//                         decoration: inputStyle("QR User"),
//                         items: PispiQrUser.values
//                             .map((e) => DropdownMenuItem(
//                                   value: e,
//                                   child: Text(_qrUserName(e),style: TextStyle(fontSize: 14),),
//                                 ))
//                             .toList(),
//                         onChanged: (v) => setState(() => qrUser = v!),
//                       ),
//                       const SizedBox(height: 15),

//                       /// Dropdown QR Type
//                       DropdownButtonFormField<PispiQrType>(
//                         initialValue: qrType,
//                         decoration: inputStyle("QR Type"),
//                         items: PispiQrType.values
//                             .map((e) => DropdownMenuItem(
//                                   value: e,
//                                   child: Text(_qrTypeName(e),style: TextStyle(fontSize: 14),),
//                                 ))
//                             .toList(),
//                         onChanged: (v) => setState(() => qrType = v!),
//                       ),
//                       const SizedBox(height: 15),

//                       /// Country
//                       DropdownButtonFormField<PispiQrCountry>(
//                         initialValue: country,
//                         decoration: inputStyle("Country"),
//                         items: PispiQrCountry.values
//                             .map((e) => DropdownMenuItem(
//                                   value: e,
//                                   child: Text('${e.code} - ${_qrPaysName(e)}',style: TextStyle(fontSize: 14),),
//                                 ))
//                             .toList(),
//                         onChanged: (v) => setState(() => country = v!),
//                       ),
//                       const SizedBox(height: 15),

//                       /// Alias
//                       TextFormField(
//                         controller: aliasController,
//                         decoration: inputStyle("Alias (UUID v4)"),
//                         validator: (v) =>
//                             v == null || v.isEmpty ? "Alias obligatoire" : null,
//                       ),
//                       const SizedBox(height: 15),

//                       /// Merchant Channel
//                       DropdownButtonFormField<String>(
//                         initialValue: channel,
//                         decoration: inputStyle("Merchant Channel"),
//                         items: channels
//                             .map((e) => DropdownMenuItem(
//                                   value: e,
//                                   child: Text(e, style: TextStyle(fontSize: 14),),
//                                 ))
//                             .toList(),
//                         onChanged: (v) => setState(() => channel = v!),
//                       ),
//                       const SizedBox(height: 15),

//                       /// Amount
//                       TextFormField(
//                         controller: amountController,
//                         keyboardType: TextInputType.number,
//                         decoration: inputStyle("Montant (optionnel)"),
//                       ),
//                       const SizedBox(height: 15),

//                       /// Reference
//                       TextFormField(
//                         controller: referenceController,
//                         decoration: inputStyle("Reference Label (optionnel)"),
//                       ),

//                       const SizedBox(height: 25),

//                       ElevatedButton(
//                         onPressed: generateQr,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color(0xFFC08507),
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 40, vertical: 15),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12)),
//                         ),
//                         child: const Text(
//                           "GÉNÉRER LE QR CODE",
//                           style: TextStyle(fontSize: 16, color: Colors.white),
//                         ),
//                       ),
//                       const SizedBox(height: 10),

//                       ElevatedButton(
//                         onPressed: reset,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color(0xFFFFD573),
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 40, vertical: 15),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12)),
//                         ),
//                         child: const Text(
//                           "REINITIALISER",
//                           style: TextStyle(fontSize: 16, color: Colors.white),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   String _qrTypeName(PispiQrType type){
//     switch(type){
//       case PispiQrType.static: return "Qr Code statique";
//       case PispiQrType.dynamic: return "Qr Code dynamique";
//     }
//   }

//   String _qrUserName(PispiQrUser user){
//     switch(user){
//       case PispiQrUser.individualCustomer: return "Personne physique";
//       case PispiQrUser.individualMerchant: return "Personne physique commerçante";
//       case PispiQrUser.businessEntity: return "Personne morale";
//     }
//   }

//   String _qrPaysName(PispiQrCountry country){
//     switch(country){
//       case PispiQrCountry.bj: return "Bénin";
//       case PispiQrCountry.bf: return "Burkina Faso";
//       case PispiQrCountry.ci: return "Côte d'Ivoire";
//       case PispiQrCountry.ml: return "Mali";
//       case PispiQrCountry.ne: return "Niger";
//       case PispiQrCountry.tg: return "Togo";
//       case PispiQrCountry.sn: return "Sénégal";
//       case PispiQrCountry.gw: return "Guinée-Bissau";
//     }
//   }
// }