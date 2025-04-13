import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text_continuous/speech_to_text_continuous.dart';

void main() {
  runApp(const MyApp());
}

/// Ejemplo de uso del plugin speech_to_text_continuous
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _speechPlugin = SpeechToTextContinuous();
  String _recognizedText = '';
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initPlugin();
  }

  /// Inicializa el canal nativo
  Future<void> _initPlugin() async {
    _speechPlugin.initialize();

    // Escucha los mensajes del canal nativo
    const MethodChannel('speech_to_text_continuous')
        .setMethodCallHandler((call) async {
      if (call.method == "onText") {
        setState(() {
          _recognizedText = call.arguments;
        });
      }
    });
  }

  /// Inicia el reconocimiento
  void _startListening() {
    _speechPlugin.startListening();
    setState(() {
      _isListening = true;
    });
  }

  /// Detiene el reconocimiento
  void _stopListening() {
    _speechPlugin.stopListening();
    setState(() {
      _isListening = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speech To Text Continuous',
      home: Scaffold(
        appBar: AppBar(title: const Text('Reconocimiento de voz')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton.icon(
                icon: Icon(_isListening ? Icons.stop : Icons.mic),
                label: Text(_isListening ? 'Detener' : 'Escuchar'),
                onPressed: _isListening ? _stopListening : _startListening,
              ),
              const SizedBox(height: 20),
              const Text(
                'Texto reconocido:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    _recognizedText,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:speech_to_text_continuous/speech_to_text_continuous.dart';

// void main() {
//   runApp(const MyApp());
// }

// /// Pantalla principal de la app de ejemplo para probar el plugin speech_to_text_continuous
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final _speechPlugin = SpeechToTextContinuous();
//   String _recognizedText = '';
//   bool _isListening = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeSpeechRecognition();
//   }

//   /// Inicializa el plugin y escucha los textos reconocidos
//   Future<void> _initializeSpeechRecognition() async {
//     // Inicializar el canal nativo
//     await _speechPlugin.initialize();

//     // Escuchar los textos que llegan desde el canal nativo
//     _speechPlugin.onTextReceived = (text) {
//       setState(() {
//         _recognizedText = text;
//       });
//     };
//   }

//   /// Comienza el reconocimiento de voz continuo
//   Future<void> _startListening() async {
//     try {
//       await _speechPlugin.startListening();
//       setState(() {
//         _isListening = true;
//       });
//     } on PlatformException catch (e) {
//       debugPrint("Error al iniciar: ${e.message}");
//     }
//   }

//   /// Detiene el reconocimiento de voz
//   Future<void> _stopListening() async {
//     try {
//       await _speechPlugin.stopListening();
//       setState(() {
//         _isListening = false;
//       });
//     } on PlatformException catch (e) {
//       debugPrint("Error al detener: ${e.message}");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Reconocimiento Continuo',
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Reconocimiento de voz continuo'),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             children: [
//               const SizedBox(height: 20),
//               Text(
//                 _isListening ? 'Escuchando...' : 'Presiona para comenzar',
//                 style: TextStyle(
//                   fontSize: 20,
//                   color: _isListening ? Colors.green : Colors.grey,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade200,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Text(
//                       _recognizedText,
//                       style: const TextStyle(fontSize: 18),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton.icon(
//                 onPressed: _isListening ? _stopListening : _startListening,
//                 icon: Icon(_isListening ? Icons.stop : Icons.mic),
//                 label: Text(_isListening ? 'Detener' : 'Escuchar'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: _isListening ? Colors.red : Colors.blue,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// // import 'package:flutter/material.dart';
// // import 'dart:async';

// // import 'package:flutter/services.dart';
// // import 'package:speech_to_text_continuous/speech_to_text_continuous.dart';

// // void main() {
// //   runApp(const MyApp());
// // }

// // class MyApp extends StatefulWidget {
// //   const MyApp({super.key});

// //   @override
// //   State<MyApp> createState() => _MyAppState();
// // }

// // class _MyAppState extends State<MyApp> {
// //   String _platformVersion = 'Unknown';
// //   final _speechToTextContinuousPlugin = SpeechToTextContinuous();

// //   @override
// //   void initState() {
// //     super.initState();
// //     initPlatformState();
// //   }

// //   // Platform messages are asynchronous, so we initialize in an async method.
// //   Future<void> initPlatformState() async {
// //     String platformVersion;
// //     // Platform messages may fail, so we use a try/catch PlatformException.
// //     // We also handle the message potentially returning null.
// //     try {
// //       platformVersion =
// //           await _speechToTextContinuousPlugin.getPlatformVersion() ?? 'Unknown platform version';
// //     } on PlatformException {
// //       platformVersion = 'Failed to get platform version.';
// //     }

// //     // If the widget was removed from the tree while the asynchronous platform
// //     // message was in flight, we want to discard the reply rather than calling
// //     // setState to update our non-existent appearance.
// //     if (!mounted) return;

// //     setState(() {
// //       _platformVersion = platformVersion;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: Scaffold(
// //         appBar: AppBar(
// //           title: const Text('Plugin example app'),
// //         ),
// //         body: Center(
// //           child: Text('Running on: $_platformVersion\n'),
// //         ),
// //       ),
// //     );
// //   }
// // }
