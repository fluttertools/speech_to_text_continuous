#include "include/speech_to_text_continuous/speech_to_text_continuous_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "speech_to_text_continuous_plugin.h"

void SpeechToTextContinuousPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  speech_to_text_continuous::SpeechToTextContinuousPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
