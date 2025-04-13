
import 'speech_to_text_continuous_platform_interface.dart';

class SpeechToTextContinuous {
  Future<String?> getPlatformVersion() {
    return SpeechToTextContinuousPlatform.instance.getPlatformVersion();
  }
}
