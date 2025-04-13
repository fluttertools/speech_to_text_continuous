import 'package:flutter_test/flutter_test.dart';
import 'package:speech_to_text_continuous/speech_to_text_continuous.dart';
import 'package:speech_to_text_continuous/speech_to_text_continuous_platform_interface.dart';
import 'package:speech_to_text_continuous/speech_to_text_continuous_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSpeechToTextContinuousPlatform
    with MockPlatformInterfaceMixin
    implements SpeechToTextContinuousPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SpeechToTextContinuousPlatform initialPlatform = SpeechToTextContinuousPlatform.instance;

  test('$MethodChannelSpeechToTextContinuous is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSpeechToTextContinuous>());
  });

  test('getPlatformVersion', () async {
    SpeechToTextContinuous speechToTextContinuousPlugin = SpeechToTextContinuous();
    MockSpeechToTextContinuousPlatform fakePlatform = MockSpeechToTextContinuousPlatform();
    SpeechToTextContinuousPlatform.instance = fakePlatform;

    expect(await speechToTextContinuousPlugin.getPlatformVersion(), '42');
  });
}
