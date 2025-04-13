import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'speech_to_text_continuous_platform_interface.dart';

/// An implementation of [SpeechToTextContinuousPlatform] that uses method channels.
class MethodChannelSpeechToTextContinuous extends SpeechToTextContinuousPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('speech_to_text_continuous');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
