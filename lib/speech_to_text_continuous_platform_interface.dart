import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'speech_to_text_continuous_method_channel.dart';

abstract class SpeechToTextContinuousPlatform extends PlatformInterface {
  /// Constructs a SpeechToTextContinuousPlatform.
  SpeechToTextContinuousPlatform() : super(token: _token);

  static final Object _token = Object();

  static SpeechToTextContinuousPlatform _instance = MethodChannelSpeechToTextContinuous();

  /// The default instance of [SpeechToTextContinuousPlatform] to use.
  ///
  /// Defaults to [MethodChannelSpeechToTextContinuous].
  static SpeechToTextContinuousPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SpeechToTextContinuousPlatform] when
  /// they register themselves.
  static set instance(SpeechToTextContinuousPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
