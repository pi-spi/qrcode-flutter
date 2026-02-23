

// import 'package:flutter/material.dart';

// import 'pipsi_qr_decoder_page.dart';
// import 'pipsi_qr_generator_page.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         backgroundColor: Color(0xFFC08507),
//         title: const Text("PI-SPI QR Plugin demo", style: TextStyle(color: Colors.white, fontSize: 20, fontStyle: FontStyle.italic, fontWeight: FontWeight.w800),),
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
//       body: SizedBox(
//         width: MediaQuery.of(context).size.width,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Card(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20)),
//               elevation: 2,
//               child: SizedBox(
//                 width: MediaQuery.of(context).size.width,
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     children: [
//                       // Generer
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.of(context).push(
//                             MaterialPageRoute(
//                               builder: (context) => PispiQrGenerationPage(),
//                             ),
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color(0xFFC08507),
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 40, vertical: 15),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12)),
//                         ),
//                         child: const Text(
//                           "Qr Generator",
//                           style: TextStyle(fontSize: 16, color: Colors.white),
//                         ),
//                       ),
//                       const SizedBox(height: 15),

//                       // Decoder
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.of(context).push(
//                             MaterialPageRoute(
//                               builder: (context) => PispiQrDecoderPage(),
//                             ),
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color(0xFFC08507),
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 40, vertical: 15),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12)),
//                         ),
//                         child: const Text(
//                           "Qr Decode",
//                           style: TextStyle(fontSize: 16, color: Colors.white),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//           ],
//         ),
//       )
//     );
//   }
// }