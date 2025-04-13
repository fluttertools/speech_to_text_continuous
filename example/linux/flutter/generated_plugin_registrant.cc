//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <speech_to_text_continuous/speech_to_text_continuous_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) speech_to_text_continuous_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "SpeechToTextContinuousPlugin");
  speech_to_text_continuous_plugin_register_with_registrar(speech_to_text_continuous_registrar);
}
