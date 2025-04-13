// lib/speech_to_text_continuous.dart
import 'dart:async';
import 'package:flutter/services.dart';

/// Clase principal del plugin speech_to_text_continuous
/// Se comunica con la parte nativa (por ahora solo Android)
class SpeechToTextContinuous {
  static const MethodChannel _channel =
      MethodChannel('speech_to_text_continuous');

  /// Callback para recibir texto en tiempo real desde el micrófono
  void Function(String text)? onTextReceived;

  SpeechToTextContinuous() {
    // Se encarga de recibir mensajes desde la parte nativa (por ejemplo, resultados de voz)
    _channel.setMethodCallHandler(_handleNativeCalls);
  }

  /// Inicializa el sistema de reconocimiento
  Future<void> initialize() async {
    await _channel.invokeMethod('initialize');
  }

  /// Comienza a escuchar continuamente sin detenerse en pausas
  Future<void> startListening() async {
    await _channel.invokeMethod('startListening');
  }

  /// Detiene la escucha
  Future<void> stopListening() async {
    await _channel.invokeMethod('stopListening');
  }

  /// Método interno para manejar llamadas que vienen del código nativo
  Future<void> _handleNativeCalls(MethodCall call) async {
    switch (call.method) {
      case 'onText':
        final String recognizedText = call.arguments as String;
        if (onTextReceived != null) {
          onTextReceived!(recognizedText);
        }
        break;
      default:
        // Si no se reconoce el método, no hacemos nada
        break;
    }
  }

  /// Ejemplo de método adicional si quieres probar la plataforma
  Future<String?> getPlatformVersion() async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}



// /// Plugin principal que conecta con las plataformas nativas.
// /// Permite reconocimiento de voz continuo en todas las plataformas.
// library speech_to_text_continuous;

// import 'dart:async';
// import 'package:flutter/services.dart';
// import 'speech_to_text_continuous_platform_interface.dart';

// typedef OnTextCallback = void Function(String text);

// class SpeechToTextContinuous {
//   static final SpeechToTextContinuous _instance = SpeechToTextContinuous._internal();

//   factory SpeechToTextContinuous() => _instance;

//   SpeechToTextContinuous._internal();

//   static const MethodChannel _channel = MethodChannel('speech_to_text_continuous');

//   OnTextCallback? _onTextCallback;

//   Future<String?> getPlatformVersion() {
//     return SpeechToTextContinuousPlatform.instance.getPlatformVersion();
//   }
//   /// Inicializa el sistema de reconocimiento de voz.
//   Future<void> initialize() async {
//     await _channel.invokeMethod('initialize');
//   }

//   /// Inicia el reconocimiento continuo.
//   Future<void> startListening({OnTextCallback? onText}) async {
//     _onTextCallback = onText;
//     _channel.setMethodCallHandler(_handleMethodCalls);
//     await _channel.invokeMethod('startListening');
//   }

//   /// Detiene el reconocimiento.
//   Future<void> stopListening() async {
//     await _channel.invokeMethod('stopListening');
//   }

//   /// Manejador de llamadas desde la plataforma nativa.
//   Future<void> _handleMethodCalls(MethodCall call) async {
//     switch (call.method) {
//       case 'onText':
//         final String text = call.arguments as String;
//         _onTextCallback?.call(text);
//         break;
//     }
//   }
// }
