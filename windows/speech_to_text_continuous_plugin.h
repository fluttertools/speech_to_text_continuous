#ifndef FLUTTER_PLUGIN_SPEECH_TO_TEXT_CONTINUOUS_PLUGIN_H_
#define FLUTTER_PLUGIN_SPEECH_TO_TEXT_CONTINUOUS_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace speech_to_text_continuous {

class SpeechToTextContinuousPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  SpeechToTextContinuousPlugin();

  virtual ~SpeechToTextContinuousPlugin();

  // Disallow copy and assign.
  SpeechToTextContinuousPlugin(const SpeechToTextContinuousPlugin&) = delete;
  SpeechToTextContinuousPlugin& operator=(const SpeechToTextContinuousPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace speech_to_text_continuous

#endif  // FLUTTER_PLUGIN_SPEECH_TO_TEXT_CONTINUOUS_PLUGIN_H_
